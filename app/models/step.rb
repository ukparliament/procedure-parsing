class Step < ActiveRecord::Base
  
  def outbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.from_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
end
