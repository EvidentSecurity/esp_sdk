require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class RoleTest < ActiveSupport::TestCase
    context ESP::Role do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Role.create(name: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          role = build(:role)
          assert_raises ESP::NotImplementedError do
            role.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          role = build(:role)
          assert_raises ESP::NotImplementedError do
            role.destroy
          end
        end
      end

      context '.find' do
        should 'call the show api and return a role if searching by id' do
          stub_role = stub_request(:get, %r{roles/5.json*}).to_return(body: json(:role))

          role = ESP::Role.find(5)

          assert_requested(stub_role)
          assert_equal ESP::Role, role.class
        end
      end
    end
  end
end
