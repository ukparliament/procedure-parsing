class WorkPackage < ActiveRecord::Base
  
  belongs_to :parliamentary_procedure
  
  def business_items_that_have_happened
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date <= ?', Date.today ).order( 'date' )
  end
  
  def business_items_that_are_scheduled_to_happen
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date > ?', Date.today ).order( 'date' )
  end
  
  def business_items_unknown
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date is null' ).order( 'date' )
  end
end
