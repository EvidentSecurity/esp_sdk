require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class Stat
    class SignatureTest < ActiveSupport::TestCase
      context ESP::StatSignature do
        context '.for_stat' do
          should 'throw an error if stat id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatSignature.for_stat
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the api' do
            stub_signature = stub_request(:get, %r{stats/5/signatures.json_api*}).to_return(body: json_list(:stat_signature, 2))

            signatures = ESP::StatSignature.for_stat(5)

            assert_requested(stub_signature)
            assert_equal ESP::StatSignature, signatures.resource_class
          end
        end

        context '.find' do
          should 'throw an error if stat_id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatSignature.find(:all, params: { id: 3 })
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the show api and return a signature if searching by id' do
            stub_signature = stub_request(:get, %r{signatures/5.json_api*}).to_return(body: json(:stat_signature))

            signature = ESP::StatSignature.find(5)

            assert_requested(stub_signature)
            assert_equal ESP::StatSignature, signature.class
          end

          should 'call the api and return signatures when stat_id is supplied' do
            stub_signature = stub_request(:get, %r{stats/5/signatures.json_api*}).to_return(body: json_list(:stat_signature, 2))

            signatures = ESP::StatSignature.find(:all, params: { stat_id: 5 })

            assert_requested(stub_signature)
            assert_equal ESP::StatSignature, signatures.resource_class
          end
        end

        context '#create' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::StatSignature.create(name: 'test')
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            signature = ESP::StatSignature.new
            assert_raises ESP::NotImplementedError do
              signature.save
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::StatSignature.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#signature' do
          should 'call the show api and return the signature' do
            signature_stat = ESP::StatSignature.new(signature_id: 3)

            stub_signature = stub_request(:get, %r{signatures/#{signature_stat.signature_id}.json_api*}).to_return(body: json(:signature))

            signature = signature_stat.signature

            assert_requested(stub_signature)
            assert_equal ESP::Signature, signature.class
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
              report = ESP::Report.find(:first, params: { status: 'complete' })
              skip "make sure you have a complete report" unless report.present?
              stat_id = report.stat.id
              stats = ESP::StatSignature.for_stat(stat_id)

              assert_equal ESP::StatSignature, stats.resource_class
            end
          end
        end
      end
    end
  end
end
