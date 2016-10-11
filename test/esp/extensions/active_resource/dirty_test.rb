require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

module ActiveResource
  class DirtyTest < ActiveSupport::TestCase
    context Dirty do
      context 'changed_attributes' do
        context 'for new record' do
          context '#create' do
            should 'pass all attributes to API and reset changed_attributes' do
              stub_request(:post, /custom_signatures.json/).to_return(body: json(:custom_signature, name: 'abc', description: '123'))
              custom_signature = ESP::CustomSignature.create(name: 'abc', description: '123')

              assert_requested :post, /custom_signatures.json/ do |request|
                json = JSON.parse(request.body)
                json['data']['attributes']['name'] == 'abc' &&
                json['data']['attributes']['description'] == '123'
              end
              assert_equal({}, custom_signature.changed_attributes)
            end
          end

          context 'save' do
            should 'pass all attributes to API and reset changed_attributes' do
              custom_signature = ESP::CustomSignature.new
              custom_signature.name = 'abc'
              custom_signature.description = '123'
              stub_request(:post, /custom_signatures\.json/).to_return(body: json(:custom_signature, name: 'abc', description: '123'))

              custom_signature.save

              assert_requested :post, /custom_signatures.json/ do |request|
                json = JSON.parse(request.body)
                json['data']['attributes']['name'] == 'abc' &&
                json['data']['attributes']['description'] == '123'
              end
              assert_equal({}, custom_signature.changed_attributes)
            end
          end
        end

        context 'for record from api' do
          context 'save' do
            should 'pass only changed attributes to API and reset changed_attributes' do
              stub_request(:get, %r{custom_signatures/1.json}).to_return(body: json(:custom_signature, name: 'abc', description: '123'))
              custom_signature = ESP::CustomSignature.find(1)
              custom_signature.name = 'def'
              custom_signature.description = '123'
              stub_request(:put, %r{custom_signatures/#{custom_signature.id}.json}).to_return(body: custom_signature.to_json)

              custom_signature.save

              assert_requested :put, %r{custom_signatures/#{custom_signature.id}.json} do |request|
                json = JSON.parse(request.body)
                json['data']['attributes']['name'] == 'def' &&
                json['data']['attributes'].exclude?(:description)
              end
              assert_equal({}, custom_signature.changed_attributes)
            end
          end

          context 'update_attributes' do
            should 'pass only changed attributes to API and reset changed_attributes' do
              stub_request(:get, %r{custom_signatures/1.json}).to_return(body: json(:custom_signature, name: 'abc', description: '123'))
              custom_signature = ESP::CustomSignature.find(1)
              stub_request(:put, %r{custom_signatures/#{custom_signature.id}.json}).to_return(body: custom_signature.to_json)

              custom_signature.update_attributes(name: 'def', description: '123')

              assert_requested :put, %r{custom_signatures/#{custom_signature.id}.json} do |request|
                json = JSON.parse(request.body)
                json['data']['attributes']['name'] == 'def' &&
                json['data']['attributes'].exclude?(:description)
              end
              assert_equal({}, custom_signature.changed_attributes)
            end
          end
        end
      end
    end
  end
end
