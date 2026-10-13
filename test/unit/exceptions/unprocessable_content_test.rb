require File.expand_path('../../../test_helper', __FILE__)

class UnprocessableContentTest < ActiveSupport::TestCase
  class InvalidResource
    def self._relationships
      {}
    end

    def self._has_attribute?(_name)
      true
    end

    def model_error_messages
      { title: ["can't be blank"] }
    end

    def validation_error_metadata
      nil
    end
  end

  def test_validation_errors_report_422_without_a_rack_deprecation
    errors = nil
    assert_silent do
      errors = JSONAPI::Exceptions::ValidationErrors.new(InvalidResource.new).errors
    end
    assert_equal ['422'], errors.map(&:status)
  end

  def test_save_failed_reports_422_without_a_rack_deprecation
    errors = nil
    assert_silent do
      errors = JSONAPI::Exceptions::SaveFailed.new.errors
    end
    assert_equal ['422'], errors.map(&:status)
  end
end
