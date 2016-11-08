require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  module Formats
    class JsonAPIFormatTest < ESP::Integration::TestCase
      context ActiveResource::Formats::JsonAPIFormat do
        context 'live calls' do
          should 'merge included objects' do
            report = ESP::Report.first(params: { sorts: 'id' })
            alert = ESP::Alert.where(report_id: report.id, include: 'external_account.team.organization,region,signature,custom_signature').first

            assert_not_nil alert.attributes['external_account']
            assert_equal alert.external_account_id, alert.external_account.id

            assert_nil alert.attributes['team']
            assert_not_nil alert.external_account.attributes['team']
            assert_equal alert.external_account.team_id, alert.external_account.team.id

            assert_nil alert.attributes['organization']
            assert_not_nil alert.external_account.team.attributes['organization']
            assert_equal alert.external_account.team.organization_id, alert.external_account.team.organization.id

            assert_not_nil alert.attributes['region']
            assert_equal alert.region_id, alert.region.id
            if alert.signature.present?
              assert_not_nil alert.attributes['signature']
              assert_equal alert.signature_id, alert.signature.id
            else
              assert_not_nil alert.attributes['custom_signature']
              assert_equal alert.custom_signature_id, alert.custom_signature.id
            end
          end

          should 'assign foreign key for a belongs_to relationship' do
            user = ESP::User.last

            assert_not_nil user.organization_id
          end

          should 'assign foreign key for a has_many relationship' do
            user = ESP::User.last

            assert_not_nil user.sub_organization_ids
          end
        end
      end

      context ActiveResource::ConnectionError do
        context 'live calls' do
          context "with ESP::Team" do
            context '.initialize' do
              should 'parse the error and return a descriptive error message' do
                error = assert_raises ActiveResource::BadRequest do
                  ESP::Team.create
                end
                assert_equal 'Failed.  Response code = 400.  Response message = param is missing or the value is empty: attributes.', error.message
              end
            end
          end
        end
      end
    end
  end
end
