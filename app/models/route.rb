class Route < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :parliamentary_procedures, :through => 'procedure_routes'
  
  def target_step
    Step.where( 'id = ?', self.to_step_id ).first
  end
end