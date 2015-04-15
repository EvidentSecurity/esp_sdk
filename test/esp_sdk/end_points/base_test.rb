require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class BaseTest < ActiveSupport::TestCase
  context 'Base' do
    setup do
      # Stub the token setup for our configuration object
      EspSdk::Configure.any_instance.expects(:token_setup).returns(nil).at_least_once
      @config = EspSdk::Configure.new(email: 'test@evident.io')
      @base = EspSdk::EndPoints::Base.new(@config)
    end

    context '#next_page' do
      should 'call list if @current_page is blank' do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }].to_json)
        @base.expects(:list)

        @base.next_page
      end

      should "return the current page if @page_links['links']' are blank" do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }].to_json)
        @base.expects(:current_page)

        @base.next_page
      end

      should 'request next page and set current_page' do
        WebMock.stub_request(:get, 'http://0.0.0.0:3000/api/v1/base')
          .to_return(:body => [{ stub: 'page1' }].to_json,
                     headers: { :link => %(<http://0.0.0.0:3000/api/v1/base?page=5>; rel="last", <http://0.0.0.0:3000/api/v1/base?page=2>; rel="next") })
        WebMock.stub_request(:get, 'http://0.0.0.0:3000/api/v1/base?page=2')
          .to_return(:body => [{ stub: 'page2' }].to_json)

        @base = EspSdk::EndPoints::Base.new(@config)
        @base.list
        @base.next_page

        assert_equal 'page2', @base.current_page.first[:stub]
      end
    end

    context '#prev_page' do
      setup do
        WebMock.stub_request(:get, %r{api/v1/base})
          .to_return(:body => [{ stub: 'Stub' }].to_json)
      end

      should 'call list if @current_page is blank' do
        @base.expects(:list)
        @base.prev_page
      end

      should "return the current page if @page_links['links']' are blank" do
        @base.expects(:current_page)
        @base.prev_page
      end
    end

    context '#list' do
      should 'set the current page and setup link pagination' do
        WebMock.stub_request(:get, %r{api/v1/base})
          .to_return(:body => [{ stub: 'Stub' }].to_json)
        @base.expects(:pagination_links)

        response = @base.list

        assert response.first.key?('stub')
        assert_equal response, @base.current_page
      end
    end

    context '#show' do
      should 'call validate id and return the stub response, and set the current_record' do
        WebMock.stub_request(:get, %r{api/v1/base/1})
          .to_return(:body => { stub: 'Stub' }.to_json)
        payload = { id: 1 }

        @base.expects(:validate_id).with(payload)

        response = @base.show(payload)
        assert response.key?('stub')
        assert_equal response, @base.current_record
      end
    end

    context '#update' do
      should 'call validate id and return the stub response, and set the current_record' do
        WebMock.stub_request(:get, %r{api/v1/base/1})
          .to_return(:body => { stub: 'Stub' }.to_json)
        payload = { id: 1, name: 'Test' }

        @base.expects(:validate_id).with(payload)

        response = @base.show(payload)
        assert response.key?('stub')
        assert_equal response, @base.current_record
      end
    end

    context '#destroy' do
      should 'call validate id and return the stub response, and set the current_record' do
        WebMock.stub_request(:get, /api\/v1\/base\/1/)
          .to_return(:body => { success: 'Stub has been destroyed' }.to_json)
        payload = { id: 1 }

        @base.expects(:validate_id).with(payload)

        response = @base.show(payload)
        assert response.key?('success')
        assert_equal response, @base.current_record
      end
    end

    context '#validate_id' do
      should 'return nil when an ID is present' do
        assert_nil @base.send(:validate_id, { id: 1 })
      end

      should 'raise EspSdk::MissingAttribute for a missing id' do
        e = assert_raises EspSdk::MissingAttribute do
          @base.send(:validate_id, {})
        end

        assert_equal 'Missing required attribute id', e.message
      end
    end

    context '#id_url' do
      should 'return a valid id url for the test environment' do
        # Test through a different endpoint to get a valid URL
        EspSdk.instance_variable_set(:@env, :development)
        external_account = EspSdk::EndPoints::ExternalAccounts.new(@config)
        assert_equal 'http://0.0.0.0:3000/api/v1/external_accounts/1', external_account.send(:id_url, 1)
      end

      should 'return a valid id url for the release environment' do
        EspSdk.instance_variable_set(:@env, :release)
        config = EspSdk::Configure.new(email: 'test@evident.io')
        # Test through a different endpoint to get a valid URL
        external_account = EspSdk::EndPoints::ExternalAccounts.new(config)
        assert_equal 'https://api-rel.evident.io/api/v1/external_accounts/1', external_account.send(:id_url, 1)
      end

      should 'return a valid id url for the production environment' do
        EspSdk.instance_variable_set(:@env, :production)
        config = EspSdk::Configure.new(email: 'test@evident.io')
        # Test through a different endpoint to get a valid URL
        external_account = EspSdk::EndPoints::ExternalAccounts.new(config)
        assert_equal 'https://api.evident.io/api/v1/external_accounts/1', external_account.send(:id_url, 1)
      end
    end

    context '#base_url' do
      should 'return a valid base url for the development environment' do
        # Test through a different endpoint to get a valid URL
        EspSdk.instance_variable_set(:@env, :development)
        external_account = EspSdk::EndPoints::ExternalAccounts.new(@config)
        assert_equal 'http://0.0.0.0:3000/api/v1/external_accounts', external_account.send(:base_url)
      end

      should 'return a valid base url for the release environment' do
        EspSdk.expects(:release?).returns(true)
        config = EspSdk::Configure.new(email: 'test@evident.io')
        # Test through a different endpoint to get a valid URL
        external_account = EspSdk::EndPoints::ExternalAccounts.new(config)
        assert_equal 'https://api-rel.evident.io/api/v1/external_accounts', external_account.send(:base_url)
      end

      should 'return a valid base url for the production environment' do
        EspSdk.expects(:production?).returns(true)
        config = EspSdk::Configure.new(email: 'test@evident.io')
        # Test through a different endpoint to get a valid URL
        external_account = EspSdk::EndPoints::ExternalAccounts.new(config)
        assert_equal 'https://api.evident.io/api/v1/external_accounts', external_account.send(:base_url)
      end
    end

    context 'current_page' do
      should 'convert hashes to ActiveSupport::HashWithIndifferentAccess' do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }, {}].to_json)

        @base.list

        assert @base.current_page.first.is_a?(ActiveSupport::HashWithIndifferentAccess)
        assert @base.current_page.last.is_a?(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context 'current_record' do
      should 'be ActiveSupport::HashWithIndifferentAccess' do
        WebMock.stub_request(:get, %r{api/v1/base/1}).to_return(body: [{ stub: 'Stub' }].to_json)

        @base.show(id: 1)

        assert @base.current_record.is_a?(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context 'page_links' do
      should 'be ActiveSupport::HashWithIndifferentAccess' do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }].to_json)

        @base.list

        assert @base.instance_variable_get(:@page_links).is_a?(ActiveSupport::HashWithIndifferentAccess)
      end

      should 'set @page_links to hash with URLs if in JSON format' do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }].to_json,
                                                              headers: { link: %({"next": "http://test.host/api/v1/custom_signatures?page=2", "last": "http://test.host/api/v1/custom_signatures?page=5"}) })

        @base.list

        links = @base.instance_variable_get(:@page_links)
        assert_equal 'http://test.host/api/v1/custom_signatures?page=5', links[:last]
        assert_equal 'http://test.host/api/v1/custom_signatures?page=2', links[:next]
      end

      should 'set @page_links to hash with URLs if in HTTP format' do
        WebMock.stub_request(:get, %r{api/v1/base}).to_return(body: [{ stub: 'Stub' }].to_json,
                                                              headers: { link: %(<http://test.host/api/v1/custom_signatures?page=5>; rel="last", <http://test.host/api/v1/custom_signatures?page=2>; rel="next") })
        @base.list

        links = @base.instance_variable_get(:@page_links)
        assert_equal 'http://test.host/api/v1/custom_signatures?page=5', links[:last]
        assert_equal 'http://test.host/api/v1/custom_signatures?page=2', links[:next]
      end
    end
  end
end
