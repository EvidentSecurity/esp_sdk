require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ESP
  class Suppression
    class SignatureTest < ActiveSupport::TestCase
      context ESP::Suppression::Signature do
        context '.where' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::Suppression::Signature.where(id_eq: 2)
            end
          end
        end

        context '#find' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::Suppression::Signature.find(4)
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            s = ESP::Suppression::Signature.new
            assert_raises ESP::NotImplementedError do
              s.update
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::Suppression::Signature.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#create' do
          should 'call the api' do
            stub_request(:post, %r{suppressions/signatures.json*}).to_return(body: json(:suppression_signature))

            suppression = ESP::Suppression::Signature.create(signature_ids: [4, 2], custom_signature_ids: [3], regions: ['us_east_1'], external_account_ids: [5], reason: 'because')

            assert_requested(:post, %r{suppressions/signatures.json*}) do |req|
              body = JSON.parse(req.body)
              assert_equal 'because', body['data']['attributes']['reason']
              assert_equal [4, 2], body['data']['attributes']['signature_ids']
              assert_equal [3], body['data']['attributes']['custom_signature_ids']
              assert_equal ['us_east_1'], body['data']['attributes']['regions']
              assert_equal [5], body['data']['attributes']['external_account_ids']
            end
            assert_equal ESP::Suppression::Signature, suppression.class
          end

          context 'for alert' do
            should 'call the api' do
              stub_request(:post, %r{suppressions/alert/5/signatures.json*}).to_return(body: json(:suppression_signature))

              suppression = ESP::Suppression::Signature.create(alert_id: 5, reason: 'because')

              assert_requested(:post, %r{suppressions/alert/5/signatures.json*}) do |req|
                body = JSON.parse(req.body)
                assert_equal 'because', body['data']['attributes']['reason']
              end
              assert_equal ESP::Suppression::Signature, suppression.class
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

          context '.create' do
            should 'return error when reason is not supplied' do
              signature_id = ESP::Signature.last.id
              external_account_id = ESP::ExternalAccount.last.id

              suppression = ESP::Suppression::Signature.create(signature_ids: [signature_id], custom_signature_ids: [], regions: ['us_east_1'], external_account_ids: [external_account_id])

              assert_equal "Reason can't be blank", suppression.errors.full_messages.first
            end

            should 'return suppression' do
              signature_id = ESP::Signature.last.id
              external_account_id = ESP::ExternalAccount.last.id

              suppression = ESP::Suppression::Signature.create(signature_ids: [signature_id], custom_signature_ids: [], reason: 'test', regions: ['us_east_1'], external_account_ids: [external_account_id])

              assert_equal ESP::Suppression::Signature, suppression.class
            end

            context 'for_alert' do
              should 'return error when reason is not supplied' do
                alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

                suppression = ESP::Suppression::Signature.create(alert_id: alert_id)

                assert_equal "Reason can't be blank", suppression.errors.full_messages.first
              end

              should 'return suppression' do
                alert_id = ESP::Report.all.detect { |r| r.status == 'complete' }.alerts.last.id

                suppression = ESP::Suppression::Signature.create(alert_id: alert_id, reason: 'test')

                assert_predicate suppression.errors, :blank?
                assert_equal ESP::Suppression::Signature, suppression.class
              end
            end
          end
        end
      end
    end
  end
end
