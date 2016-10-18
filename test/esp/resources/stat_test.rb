require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class StatTest < ActiveSupport::TestCase
    context ESP::Stat do
      context '.where' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            Stat.where(id_eq: 2)
          end
        end
      end

      context '#report' do
        should 'call the api' do
          stat = build(:stat, report_id: 3)
          stubbed_report = stub_request(:get, %r{reports/#{stat.report_id}.json*}).to_return(body: json(:report))

          stat.report

          assert_requested(stubbed_report)
        end
      end

      context '#regions' do
        should 'call the api for the stat' do
          stat = build(:stat)
          stubbed_regions = stub_request(:get, %r{stats/#{stat.id}/regions.json*}).to_return(body: json_list(:stat_region, 2))

          stat.regions

          assert_requested(stubbed_regions)
        end
      end

      context '#services' do
        should 'call the api for the stat' do
          stat = build(:stat)
          stubbed_services = stub_request(:get, %r{stats/#{stat.id}/services.json*}).to_return(body: json_list(:stat_service, 2))

          stat.services

          assert_requested(stubbed_services)
        end
      end

      context '#signatures' do
        should 'call the api for the stat' do
          stat = build(:stat)
          stubbed_signatures = stub_request(:get, %r{stats/#{stat.id}/signatures.json*}).to_return(body: json_list(:stat_signature, 2))

          stat.signatures

          assert_requested(stubbed_signatures)
        end
      end

      context '#custom_signatures' do
        should 'call the api for the stat' do
          stat = build(:stat)
          stubbed_custom_signatures = stub_request(:get, %r{stats/#{stat.id}/custom_signatures.json*}).to_return(body: json_list(:stat_custom_signature, 2))

          stat.custom_signatures

          assert_requested(stubbed_custom_signatures)
        end
      end

      context '#find' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Stat.find(1)
          end
        end
      end

      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Stat.create(report_id: 1)
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          s = build(:stat)

          assert_raises ESP::NotImplementedError do
            s.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          s = build(:stat)

          assert_raises ESP::NotImplementedError do
            s.destroy
          end
        end
      end

      context '.for_report' do
        should 'raise an error if report_id is not provided' do
          error = assert_raises ArgumentError do
            ESP::Stat.for_report
          end
          assert_equal "You must supply a report id.", error.message
        end

        should 'call the api and return a stat' do
          stub_stat = stub_request(:get, %r{reports/5/stats.json*}).to_return(body: json(:stat))

          stat = ESP::Stat.for_report(5)

          assert_requested(stub_stat)
          assert_equal ESP::Stat, stat.class
        end
      end

      context '.latest_for_teams' do
        should 'call the api and return a collection of stats' do
          stub_stat = stub_request(:get, %r{stats/latest_for_teams*}).to_return(body: json_list(:stat, 2))

          stats = ESP::Stat.latest_for_teams

          assert_requested(stub_stat)
          assert_equal ESP::Stat, stats.resource_class
        end

        context 'next_page' do
          should 'request page 2 when multiple stats' do
            stub_stat = stub_request(:get, %r{stats/latest_for_teams*}).with(body: nil).to_return(body: json_list(:stat, 25))
            stub_stat2 = stub_request(:put, %r{stats/latest_for_teams*}).with(body: { filter: {}, page: { number: '2', size: '20' } }.to_json).to_return(body: json_list(:stat, 2))

            stats = ESP::Stat.latest_for_teams
            stats.next_page

            assert_requested(stub_stat)
            assert_requested(stub_stat2)
          end
        end
      end
    end
  end
end
