require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class Stat
    class CustomSignatureTest < ActiveSupport::TestCase
      context ESP::StatCustomSignature do
        context '.for_stat' do
          context '.where' do
            should 'not be implemented' do
              assert_raises ESP::NotImplementedError do
                StatCustomSignature.where(id_eq: 2)
              end
            end
          end

          should 'throw an error if stat id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatCustomSignature.for_stat
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the api' do
            stub_custom_signature = stub_request(:get, %r{stats/5/custom_signatures.json_api*}).to_return(body: json_list(:stat_custom_signature, 2))

            custom_signatures = ESP::StatCustomSignature.for_stat(5)

            assert_requested(stub_custom_signature)
            assert_equal ESP::StatCustomSignature, custom_signatures.resource_class
          end
        end

        context '.find' do
          should 'throw an error if stat_id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatCustomSignature.find(:all, params: { id: 3 })
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the show api and return a custom_signature if searching by id' do
            stub_custom_signature = stub_request(:get, %r{custom_signatures/5.json_api*}).to_return(body: json(:stat_custom_signature))

            custom_signature = ESP::StatCustomSignature.find(5)

            assert_requested(stub_custom_signature)
            assert_equal ESP::StatCustomSignature, custom_signature.class
          end

          should 'call the api and return custom_signatures when stat_id is supplied' do
            stub_custom_signature = stub_request(:get, %r{stats/5/custom_signatures.json_api*}).to_return(body: json_list(:stat_custom_signature, 2))

            custom_signatures = ESP::StatCustomSignature.find(:all, params: { stat_id: 5 })

            assert_requested(stub_custom_signature)
            assert_equal ESP::StatCustomSignature, custom_signatures.resource_class
          end
        end

        context '#create' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::StatCustomSignature.create(name: 'test')
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            custom_signature = ESP::StatCustomSignature.new
            assert_raises ESP::NotImplementedError do
              custom_signature.save
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::StatCustomSignature.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#custom_signature' do
          should 'call the show api and return the custom_signature' do
            custom_signature_stat = ESP::StatCustomSignature.new(custom_signature_id: 3)

            stub_custom_signature = stub_request(:get, %r{custom_signatures/#{custom_signature_stat.custom_signature_id}.json_api*}).to_return(body: json(:custom_signature))

            custom_signature = custom_signature_stat.custom_signature

            assert_requested(stub_custom_signature)
            assert_equal ESP::CustomSignature, custom_signature.class
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

          context '.for_stat' do
            should 'return tags for stat id' do
              report = ESP::Report.find(:first, params: { id_eq: 1 })
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatCustomSignature.for_stat(stat_id)

              assert_equal ESP::StatCustomSignature, stats.resource_class
            end
          end
        end
      end
    end
  end
end
