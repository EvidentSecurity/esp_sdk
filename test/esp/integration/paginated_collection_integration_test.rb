require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class PaginatedCollectionTest < ESP::Integration::TestCase
    context ActiveResource::PaginatedCollection do
      context 'live calls' do
        should 'always return the correct page and update itself when using the ! methods' do
          report = ESP::Report.all.detect { |r| r.status == 'complete' }
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

          alerts.page!(3)
          assert_equal '3', alerts.current_page_number
          refute_equal first_id, alerts.first.id
        end

        should 'always return the correct page when not using the ! methods' do
          report = ESP::Report.all.detect { |r| r.status == 'complete' }
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

          page = alerts.page(3)
          assert_equal '3', page.current_page_number
          refute_equal first_id, page.first.id
        end
      end
    end
  end
end
