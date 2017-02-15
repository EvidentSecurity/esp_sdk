require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP::Integration
  class CustomSignatureDefinitionTest < ESP::Integration::TestCase
    context ESP::CustomSignature::Definition do
      context 'live calls' do
        context '#custom_signature' do
          should 'return a custom_signature' do
            archived_definition = ESP::CustomSignature::Definition.where(status_eq: 'archived').last
            fail 'Missing definition' if archived_definition.blank?

            custom_signature = archived_definition.custom_signature

            assert_equal archived_definition.custom_signature_id, custom_signature.id
            assert_equal ESP::CustomSignature, custom_signature.class
          end
        end

        context '#results' do
          should 'return list of results' do
            archived_definition = ESP::CustomSignature::Definition.where(status_eq: 'archived').last
            fail 'Missing definition' if archived_definition.blank?

            results = archived_definition.results

            assert_equal ESP::CustomSignature::Result, results.resource_class
          end
        end

        context '.where' do
          should 'return definition objects' do
            archived_definition = ESP::CustomSignature::Definition.where(status_eq: 'archived').last
            fail 'Missing definition' if archived_definition.blank?

            definitions = ESP::CustomSignature::Definition.where(id_eq: archived_definition.id)

            assert_equal ESP::CustomSignature::Definition, definitions.resource_class
          end
        end

        context '.archive' do
          should 'archive definition' do
            definition = ESP::CustomSignature::Definition.where(status_eq: 'active').last
            fail 'Missing definition' if definition.blank?

            definition.archive

            assert_equal 'archived', definition.status
          end
        end

        context '.activate' do
          should 'activate definition' do
            custom_signature = ESP::CustomSignature.last
            fail 'Missing custom signature' if custom_signature.blank?
            definition = custom_signature.definitions.last

            if definition.blank? || definition.status != 'editable'
              definition = ESP::CustomSignature::Definition.create(custom_signature_id: custom_signature.id)
            end

            assert_equal 'editable', definition.status

            definition.activate

            assert_equal 'validating', definition.status
          end
        end

        context '#CRUD' do
          should 'be able to create, update and destroy' do
            custom_signature = ESP::CustomSignature.last
            fail 'Missing custom signature' if custom_signature.blank?
            old_definition = custom_signature.definitions.last

            if old_definition.present? && old_definition.status == 'editable'
              old_definition.destroy

              assert_raises ActiveResource::ResourceNotFound do
                ESP::CustomSignature::Definition.find(old_definition.id)
              end
            end

            definition = ESP::CustomSignature::Definition.new(custom_signature_id: custom_signature.id)

            assert_predicate definition, :new?

            definition.save

            refute_predicate definition, :new?

            definition.code = 'ABC123'
            definition.save

            assert_nothing_raised do
              ESP::CustomSignature::Definition.find(definition.id)
            end

            definition.destroy

            assert_raises ActiveResource::ResourceNotFound do
              ESP::CustomSignature::Definition.find(definition.id)
            end
          end
        end
      end
    end
  end
end
