require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class Stat
    class ServiceTest < ActiveSupport::TestCase
      context ESP::StatService do
        context '.for_stat' do
          should 'throw an error if stat id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatService.for_stat
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the api' do
            stub_service = stub_request(:get, %r{stats/5/services.json*}).to_return(body: json_list(:stat_service, 2))

            services = ESP::StatService.for_stat(5)

            assert_requested(stub_service)
            assert_equal ESP::StatService, services.resource_class
          end
        end
        context '.find' do
          should 'throw an error if stat_id is not supplied' do
            error = assert_raises ArgumentError do
              ESP::StatService.find(:all, params: { id: 3 })
            end
            assert_equal 'You must supply a stat id.', error.message
          end

          should 'call the show api and return a service if searching by id' do
            stub_service = stub_request(:get, %r{services/5.json*}).to_return(body: json(:stat_service))

            service = ESP::StatService.find(5)

            assert_requested(stub_service)
            assert_equal ESP::StatService, service.class
          end

          should 'call the api and return services when stat_id is supplied' do
            stub_service = stub_request(:get, %r{stats/5/services.json*}).to_return(body: json_list(:stat_service, 2))

            services = ESP::StatService.find(:all, params: { stat_id: 5 })

            assert_requested(stub_service)
            assert_equal ESP::StatService, services.resource_class
          end
        end

        context '#create' do
          should 'not be implemented' do
            assert_raises ESP::NotImplementedError do
              ESP::StatService.create(name: 'test')
            end
          end
        end

        context '#update' do
          should 'not be implemented' do
            service = ESP::StatService.new
            assert_raises ESP::NotImplementedError do
              service.save
            end
          end
        end

        context '#destroy' do
          should 'not be implemented' do
            s = ESP::StatService.new
            assert_raises ESP::NotImplementedError do
              s.destroy
            end
          end
        end

        context '#service' do
          should 'call the show api and return the service' do
            service_stat = ESP::StatService.new(service_id: 3)

            stub_service = stub_request(:get, %r{services/#{service_stat.service_id}.json*}).to_return(body: json(:service))

            service = service_stat.service

            assert_requested(stub_service)
            assert_equal ESP::Service, service.class
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
              stats = ESP::StatService.for_stat(stat_id)

              assert_equal ESP::StatService, stats.resource_class
            end
          end
        end
      end
    end
  end
end
