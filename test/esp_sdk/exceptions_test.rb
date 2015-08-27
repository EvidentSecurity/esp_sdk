require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ExceptionsTest < ActiveSupport::TestCase
  context 'Exceptions' do
    context 'MissingAttribute' do
      should 'be a StandardError' do
        assert ESP::MissingAttribute.new.is_a?(StandardError)
      end
    end

    context 'UnknownAttribute' do
      should 'be a StandardError' do
        assert ESP::UnknownAttribute.new.is_a?(StandardError)
      end
    end

    context 'TokenExpired' do
      should 'be a StandardError' do
        assert ESP::TokenExpired.new.is_a?(StandardError)
      end
    end

    context 'RecordNotFound' do
      should 'be a StandardError' do
        assert ESP::RecordNotFound.new.is_a?(StandardError)
      end
    end

    context 'Exception' do
      should 'be a StandardError' do
        assert ESP::Exception.new.is_a?(StandardError)
      end
    end

    context 'Unauthorized' do
      should 'be a StandardError' do
        assert ESP::Unauthorized.new.is_a?(StandardError)
      end
    end
  end
end
