require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < ActiveSupport::TestCase

  def test_for_organization_paged
    assert_equal 64, Service.for_organization(organizations(:sfbk)).paginate.size
    assert_equal 20, Service.for_organization(organizations(:sfbk)).paginate.to_a.size
    assert_equal 64, Service.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).size
    assert_equal 10, Service.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).to_a.size
  end

  def test_for_organization_in_date_range
    from, to = Date.new(2007,8,1), Date.new(2008,2,3)
    assert_equal 54, Service.for_organization(organizations(:sfbk)).before(from).size
    assert_equal 7, Service.for_organization(organizations(:sfbk)).after(from).before(to).size
  end

  def test_for_service_types
    assert_equal 3, Service.for_service_types('MEMBERSHIP').size
    assert_equal 64, Service.for_service_types(['MEMBERSHIP', 'CLASS']).size
  end
  
  def test_to_csv
    assert_match /^Mary,Member,mary@example.com,,,MEMBERSHIP,\d{4}-\d{2}-\d{2},\d{4}-\d{2}-\d{2},false,true,/, services(:mary_membership).to_csv
  end

end
