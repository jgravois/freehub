require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase

  include ApplicationHelper

  def test_labeled_input
    result = labeled_input 'Label' do
      'name'
    end
    assert_equal '<p><label>Label</label><br/>name</p>', result.to_s
  end

  def test_labeled_input_with_for
    result = labeled_input 'Label', :for => :name do
      'name'
    end
    assert_equal '<p><label for="name">Label</label><br/>name</p>', result.to_s
  end
end
