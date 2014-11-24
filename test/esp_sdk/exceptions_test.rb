require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ExceptionsTest < ActiveSupport::TestCase
  context 'Exceptions' do
    context 'MissingAttribute' do
      should 'be a StandardError' do
        assert EspSdk::MissingAttribute.new.is_a?(StandardError)
      end
    end

    context 'UnknownAttribute' do
      should 'be a StandardError' do
        assert EspSdk::UnknownAttribute.new.is_a?(StandardError)
      end
    end

    context 'TokenExpired' do
      should 'be a StandardError' do
        assert EspSdk::TokenExpired.new.is_a?(StandardError)
      end
    end

    context 'RecordNotFound' do
      should 'be a StandardError' do
        assert EspSdk::RecordNotFound.new.is_a?(StandardError)
      end
    end

    context 'Exception' do
      should 'be a StandardError' do
        assert EspSdk::Exception.new.is_a?(StandardError)
      end
    end

    context 'Unauthorized' do
      should 'be a StandardError' do
        assert EspSdk::Unauthorized.new.is_a?(StandardError)
      end
    end
  end
end
