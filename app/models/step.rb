class Step < ActiveRecord::Base
  
  def outbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.from_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  def inbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.to_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  def actualised_has_happened_in_work_package?( work_package )
    BusinessItem.all.select( 'bi.*' ).joins( 'as bi, actualisations as a' ).where( 'a.step_id = ?', self ).where( 'a.business_item_id = bi.id' ).where( 'bi.work_package_id  ?', work_package ).where( 'bi.date >= ?', Date.today )
  end
end
