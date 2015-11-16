require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ESP
  class Suppression
    class UniqueIdentifierTest < ActiveSupport::TestCase
      context ESP::Suppression::UniqueIdentifier do
        context '#find' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::Suppression::UniqueIdentifier.find(4)
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            s = ESP::Suppression::UniqueIdentifier.new
            assert_raises ESP::NotImplementedError do
              s.update
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::Suppression::UniqueIdentifier.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#create' do
          should 'call the api' do
            stub_request(:post, %r{suppressions/alert/5/unique_identifiers.json_api*}).to_return(body: json(:suppression_unique_identifier))

            suppression = ESP::Suppression::UniqueIdentifier.create(alert_id: 5, reason: 'because')

            assert_requested(:post, %r{suppressions/alert/5/unique_identifiers.json_api*}) do |req|
              body = JSON.parse(req.body)
              assert_equal 'because', body['data']['attributes']['reason']
            end
            assert_equal ESP::Suppression::UniqueIdentifier, suppression.class
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

          context '.create' do
            should 'return error when reason is not supplied' do
              alert_id = ESP::Report.last.alerts.last.id

              suppression = ESP::Suppression::UniqueIdentifier.create(alert_id: alert_id)

              assert_equal "Reason can't be blank", suppression.errors.full_messages.first
            end

            should 'return suppression' do
              alert_id = ESP::Report.last.alerts.last.id

              suppression = ESP::Suppression::UniqueIdentifier.create(alert_id: alert_id, reason: 'test')

              assert_predicate suppression.errors, :blank?
              assert_equal ESP::Suppression::UniqueIdentifier, suppression.class
            end
          end
        end
      end
    end
  end
end
