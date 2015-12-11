require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ActiveResource
  class PaginatedCollectionTest < ActiveSupport::TestCase
    context ActiveResource::PaginatedCollection do
      context "with ESP::Alert" do
        context '#parse_pagination_links' do
          should 'not set the previous page or next page or last page when there is only 1 page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 2, page: { number: 1, size: 20 }))

            alerts = report.alerts

            assert_equal '1', alerts.current_page_number
            assert_nil alerts.next_page_number
            assert_nil alerts.previous_page_number
            assert_nil alerts.last_page_number
            refute_predicate alerts, :next_page?
            refute_predicate alerts, :previous_page?
            assert_predicate alerts, :last_page?
          end

          should 'not set the previous page when on the first page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 2, page: { number: 1, size: 1 }))

            alerts = report.alerts

            assert_equal '1', alerts.current_page_number
            assert_equal '2', alerts.next_page_number
            assert_nil alerts.previous_page_number
            assert_equal '2', alerts.last_page_number
            assert_predicate alerts, :next_page?
            refute_predicate alerts, :previous_page?
            refute_predicate alerts, :last_page?
          end

          should 'not set the next or last page page when on the last page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 2, page: { number: 2, size: 1 }))

            alerts = report.alerts

            assert_equal '2', alerts.current_page_number
            assert_nil alerts.next_page_number
            assert_equal '1', alerts.previous_page_number
            assert_nil alerts.last_page_number
            refute_predicate alerts, :next_page?
            assert_predicate alerts, :previous_page?
            assert_predicate alerts, :last_page?
          end

          should 'set the next, last and previous page page when not on the first or last page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 }))

            alerts = report.alerts

            assert_equal '2', alerts.current_page_number
            assert_equal '3', alerts.next_page_number
            assert_equal '1', alerts.previous_page_number
            assert_equal '3', alerts.last_page_number
            assert_predicate alerts, :next_page?
            assert_predicate alerts, :previous_page?
            refute_predicate alerts, :last_page?
          end

          should 'set page size on each link' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 }))

            alerts = report.alerts

            assert_equal '1', alerts.next_page_params['page']['size']
            assert_equal '1', alerts.previous_page_params['page']['size']
            assert_equal '1', alerts.last_page_params['page']['size']
          end

          should 'not set page size on previous link if on the last page' do
            # The last page may not contain the full per page number of records, and will therefore come back with an incorrect size since the
            # size is based on the collection size.  This will mess up further calls to previous_page or first page so remove the size so it will bring back the default size.
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 2 }))

            alerts = report.alerts

            assert_equal false, alerts.previous_page_params['page'].key?('size')
          end
        end

        context '#first_page' do
          should 'call the api with the original url and params and the page number 1 param' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts(status: 'pass')

            page = alerts.first_page

            assert_equal '1', page.current_page_number
            assert_equal '2', alerts.current_page_number # original object is unchanged
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body["page"].present? # The first call will not have a body["page"], only the second call
                assert_equal 1, body["page"]["number"]
                assert_equal 'pass', body["filter"]["status"]
              end
            end
          end

          should 'not call the api and return self if already on the first page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts

            page = alerts.first_page

            assert_equal '1', page.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              assert_predicate req.uri.query, :blank? # It will only be called once to get the first page
            end
          end
        end

        context '#first_page!' do
          should 'call the api with the original url and the page number 1 param and update itself' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts

            alerts.first_page!

            assert_equal '1', alerts.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              assert_equal 1, body["page"]["number"] if body.present? # The first call will not have a body, only the second call
            end
          end
        end

        context '#previous_page' do
          should 'call the api with the original url and original params and the previous page number param' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts(status: 'pass')

            page = alerts.previous_page

            assert_equal '1', page.current_page_number
            assert_equal '2', alerts.current_page_number # original object is unchanged
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body["page"].present? # The first call will not have a body["page"], only the second call
                assert_equal '1', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
                assert_equal 'pass', body["filter"]["status"]
              end
            end
          end

          should 'not call the api and return self if already on the first page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts

            page = alerts.previous_page

            assert_equal '1', page.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              assert_predicate req.uri.query, :blank? # It will only be called once to get the first page
            end
          end
        end

        context '#previous_page!' do
          should 'call the api with the original url and the previous page number param and update itself' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 1, size: 1 }))
            alerts = report.alerts

            alerts.previous_page!

            assert_equal '1', alerts.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body.present? # The first call will not have a body, only the second call
                assert_equal '1', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
              end
            end
          end
        end

        context '#next_page' do
          should 'call the api with the original url and original params and the next page number param' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts(status: 'pass')

            page = alerts.next_page

            assert_equal '3', page.current_page_number
            assert_equal '2', alerts.current_page_number # original object is unchanged
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body["page"].present? # The first call will not have a body["page"], only the second call
                assert_equal '3', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
                assert_equal 'pass', body["filter"]["status"]
              end
            end
          end

          should 'not call the api and return self if already on the last page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            page = alerts.next_page

            assert_equal '3', page.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              assert_predicate req.uri.query, :blank? # It will only be called once to get the first page
            end
          end
        end

        context '#next_page!' do
          should 'call the api with the original url and the next page number param and update itself' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            alerts.next_page!

            assert_equal '3', alerts.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body.present? # The first call will not have a body, only the second call
                assert_equal '3', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
              end
            end
          end
        end

        context '#last_page' do
          should 'call the api with the original url and original params and the last page number param' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts(status: 'pass')

            page = alerts.last_page

            assert_equal '3', page.current_page_number
            assert_equal '2', alerts.current_page_number # original object is unchanged
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body["page"].present? # The first call will not have a body["page"], only the second call
                assert_equal '3', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
                assert_equal 'pass', body["filter"]["status"]
              end
            end
          end

          should 'not call the api and return self if already on the last page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            page = alerts.last_page

            assert_equal '3', page.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              assert_predicate req.uri.query, :blank? # It will only be called once to get the first page
            end
          end
        end

        context '#last_page!' do
          should 'call the api with the original url and the last page number param and update itself' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            alerts.last_page!

            assert_equal '3', alerts.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body.present? # The first call will not have a body, only the second call
                assert_equal '3', body["page"]["number"]
                assert_equal '1', body["page"]["size"]
              end
            end
          end
        end

        context '#page' do
          should 'raise an error if the page number is not given' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            error = assert_raises ArgumentError do
              alerts.page
            end
            assert_equal "You must supply a page number.", error.message
          end

          should 'raise an error if the page number is not a positive number' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            error = assert_raises ArgumentError do
              alerts.page(0)
            end
            assert_equal "Page number cannot be less than 1.", error.message
          end

          should 'raise an error if the page number is greater than the last page number' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            error = assert_raises ArgumentError do
              alerts.page(4)
            end
            assert_equal "Page number cannot be greater than the last page number.", error.message
          end

          should 'call the api with the original url and original params and the page number param' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts(status: 'pass')

            page = alerts.page(3)

            assert_equal '3', page.current_page_number
            assert_equal '2', alerts.current_page_number # original object is unchanged
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body["page"].present? # The first call will not have a body["page"], only the second call
                assert_equal 3, body["page"]["number"]
                assert_equal '1', body["page"]["size"]
                assert_equal 'pass', body["filter"]["status"]
              end
            end
          end

          should 'not call the api and return self if already on that page' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 }))
            alerts = report.alerts

            page = alerts.page(2)

            assert_equal '2', page.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              assert_predicate req.uri.query, :blank? # It will only be called once to get the first page
            end
          end
        end

        context '#page!' do
          should 'call the api with the original url and the page number 1 param and update itself' do
            report = build(:report)
            stub_request(:put, %r{reports/#{report.id}/alerts.json*}).to_return(body: json_list(:alert, 3, page: { number: 2, size: 1 })).then.to_return(body: json_list(:alert, 3, page: { number: 3, size: 1 }))
            alerts = report.alerts

            alerts.page!(3)

            assert_equal '3', alerts.current_page_number
            assert_requested(:put, %r{reports/#{report.id}/alerts.json*}) do |req|
              body = JSON.parse(req.body)
              if body.present? # The first call will not have a body, only the second call
                assert_equal '3', body["page"]["number"].to_s
                assert_equal '1', body["page"]["size"].to_s
              end
            end
          end
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
        end

        teardown do
          WebMock.disable_net_connect!
        end

        should 'always return the correct page and update itself when using the ! methods' do
          report = ESP::Report.last
          alerts = report.alerts
          last_page_number = alerts.last_page_number

          assert_equal '1', alerts.current_page_number
          first_id = alerts.first.id

          alerts.next_page!
          assert_equal '2', alerts.current_page_number
          refute_equal first_id, alerts.first.id
          first_id = alerts.first.id

          alerts.last_page!
          assert_equal last_page_number, alerts.current_page_number
          refute_equal first_id, alerts.first.id
          first_id = alerts.first.id

          alerts.previous_page!
          assert_equal alerts.last_page_number.to_i - 1, alerts.current_page_number.to_i
          refute_equal first_id, alerts.first.id
          assert_equal 20, alerts.count # make sure the size did not get messed up while on the last page
          first_id = alerts.first.id

          alerts.page!(4)
          assert_equal '4', alerts.current_page_number
          refute_equal first_id, alerts.first.id
        end

        should 'always return the correct page and when not using the ! methods' do
          report = ESP::Report.last
          alerts = report.alerts
          last_page_number = alerts.last_page_number

          assert_equal '1', alerts.current_page_number
          first_id = alerts.first.id

          page = alerts.next_page
          assert_equal '2', page.current_page_number
          refute_equal first_id, page.first.id
          first_id = page.first.id

          page = page.last_page
          assert_equal last_page_number, page.current_page_number
          refute_equal first_id, page.first.id
          first_id = page.first.id

          page = page.previous_page
          assert_equal page.last_page_number.to_i - 1, page.current_page_number.to_i
          refute_equal first_id, page.first.id
          assert_equal 20, page.count # make sure the size did not get messed up while on the last page
          first_id = page.first.id

          page = alerts.page(4)
          assert_equal '4', page.current_page_number
          refute_equal first_id, page.first.id
        end
      end
    end
  end
end
