class Step < ActiveRecord::Base
  
  def outbound_routes
    Route.all.where( 'from_step_id = ?', self )
  end
end
