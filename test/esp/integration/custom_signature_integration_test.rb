require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CustomSignatureTest < ESP::Integration::TestCase
    context ESP::CustomSignature do
      context 'live calls' do
        setup do
          @custom_signature = ESP::CustomSignature.last
          fail "Live DB does not have any custom_signatures.  Add a custom_signature and run tests again." if @custom_signature.blank?
        end

        context '#organization' do
          should 'return an organization' do
            organization = @custom_signature.organization

            assert_equal @custom_signature.organization_id, organization.id
            assert_equal ESP::Organization, organization.class
          end
        end

        context '#teams' do
          should 'return list of teams' do
            team = @custom_signature.teams

            assert_equal ESP::Team, team.resource_class
          end
        end

        context '.where' do
          should 'return custom_signature objects' do
            custom_signatures = ESP::CustomSignature.where(id_eq: @custom_signature.id)

            assert_equal ESP::CustomSignature, custom_signatures.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            team = ESP::Team.last
            assert_predicate team, :present?
            custom_signature = ESP::CustomSignature.new(@custom_signature.attributes.merge(team_ids: [team.id]))

            assert_predicate custom_signature, :new?

            custom_signature.save

            refute_predicate custom_signature, :new?

            custom_signature.identifier = 'new identifier'
            custom_signature.save

            assert_nothing_raised do
              ESP::CustomSignature.find(custom_signature.id)
            end

            custom_signature.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::CustomSignature.find(custom_signature.id)
            end
          end
        end
      end
    end
  end
end
