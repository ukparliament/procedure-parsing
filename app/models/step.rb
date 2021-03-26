class Step < ActiveRecord::Base
  
  def outbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.from_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  def inbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.to_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  def actualised_has_happened_in_work_package?( work_package )
    BusinessItem.all.select( 'bi.*' ).joins( 'as bi, actualisations as a' ).where( 'a.step_id = ?', self ).where( 'a.business_item_id = bi.id' ).where( 'bi.work_package_id = ?', work_package ).where( 'bi.date >= ?', Date.today ).order( 'bi.id' ).first
  end
  
  def in_commons?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Commons' ).order( 'hs.id' ).first
  end
  
  def in_lords?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Lords' ).order( 'hs.id' ).first
  end
  
  def house_label
    house_label = ''
    if self.in_commons? and self.in_lords?
      house_label = 'House of Commons and House of Lords'
    elsif self.in_commons?
      house_label = 'House of Commons'
    elsif self.in_lords?
      house_label = 'House of Lords'
    else
      house_label = 'Neither House'
    end
    house_label
  end
end
