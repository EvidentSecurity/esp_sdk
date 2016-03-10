require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class SuppressionTest < ESP::Integration::TestCase
    context ESP::Suppression do
      context 'live calls' do
        setup do
          @s = ESP::Suppression.first
          fail "Live DB does not have any suppressions.  Add a suppression and run tests again." if @s.blank?
        end

        context '#organization' do
          should 'return an organization' do
            org = @s.organization

            assert_equal @s.organization_id, org.id
          end
        end

        context '#created_by' do
          should 'return a user' do
            u = @s.created_by

            assert_equal @s.created_by_id, u.id
          end
        end

        context '#regions' do
          should 'return regions' do
            r = @s.regions

            assert_equal ESP::Region, r.resource_class unless r == []
          end
        end

        context '#external_accounts' do
          should 'return external_accounts' do
            e = @s.external_accounts

            assert_equal ESP::ExternalAccount, e.resource_class
          end
        end

        context '#signatures' do
          should 'return signatures' do
            s = @s.signatures

            assert_equal ESP::Signature, s.resource_class unless s == []
          end
        end

        context '#custom_signatures' do
          should 'return custom_signatures' do
            cs = @s.custom_signatures

            assert_equal ESP::CustomSignature, cs.resource_class unless cs == []
          end
        end

        context '#deactivate' do
          should 'deactivate the suppression' do
            status = @s.status

            @s.deactivate

            assert_equal 'inactive', @s.status
            assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
          end
        end

        context '#deactivate!' do
          should 'raise an error if already inactive' do
            status = @s.status

            if status == 'inactive'
              assert_raises ActiveResource::ResourceInvalid do
                @s.deactivate!
              end
              assert_equal 'inactive', @s.status
              assert_contains @s.errors.full_messages.first, 'Access Denied' if status == 'inactive'
            end
          end
        end

        context '.where' do
          should 'return suppression objects' do
            suppressions = ESP::Suppression.where(id_eq: @s.id)

            assert_equal ESP::Suppression, suppressions.resource_class
          end
        end
      end
    end
  end
end
