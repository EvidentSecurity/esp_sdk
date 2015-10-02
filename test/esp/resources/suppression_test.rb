require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class SuppressionTest < ActiveSupport::TestCase
    context ESP::Suppression do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::User.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          u = build(:user)
          assert_raises ESP::NotImplementedError do
            u.destroy
          end
        end
      end

      context '#organization' do
        should 'call the api' do
          s = build(:suppression, organization_id: 1)
          stub_org = stub_request(:get, %r{organizations/#{s.organization_id}.json*}).to_return(body: json(:organization))

          s.organization

          assert_requested(stub_org)
        end
      end

      context '#created_by' do
        should 'call the api' do
          s = build(:suppression, created_by_id: 1)
          stub_user = stub_request(:get, %r{users/#{s.created_by_id}.json*}).to_return(body: json(:user))

          s.created_by

          assert_requested(stub_user)
        end
      end

      context '#deactivate' do
        should 'call the api and not throw an error if an error is returned' do
          s = build(:suppression)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          s.expects(:patch).raises(error)

          assert_nothing_raised do
            refute_predicate s, :deactivate
          end

          assert_equal JSON.parse(error_response)['errors'].first['title'], s.errors.full_messages.first
        end
      end

      context '#deactivate!' do
        should 'call the api and throw an error if an error is returned' do
          s = build(:suppression)
          error = ActiveResource::BadRequest.new('')
          error_response = json(:error)
          response = mock(body: error_response)
          error.expects(:response).returns(response)
          s.expects(:patch).raises(error)

          error = assert_raises ActiveResource::ResourceInvalid do
            s.deactivate!
          end
          assert_equal "Failed.  Response message = #{JSON.parse(error_response)['errors'].first['title']}.", error.message
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @s = ESP::Suppression.first
          skip "Live DB does not have any suppressions.  Add a suppression and run tests again." if @s.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '#organization' do
          should 'return an organization' do
            org = @s.organization

            assert_equal @s.organization_id, org.id
          end
        end

        context '#created_by' do
          should 'return a user' do
            u = @s.created_by

            assert_equal @s.created_by_id, u.id
          end
        end

        context '#deactivate' do
          should 'deactivate the suppression' do
            status = @s.status

            @s.deactivate

            assert_equal 'inactive', @s.status
            assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
          end
        end

        context '#deactivate!' do
          should 'raise an error if already inactive' do
            status = @s.status

            if status == 'inactive'
              assert_raises ActiveResource::ResourceInvalid do
                @s.deactivate!
              end
              assert_equal 'inactive', @s.status
              assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
            end
          end
        end
      end
    end
  end
end
