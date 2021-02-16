class Route < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :parliamentary_procedures, :through => 'procedure_routes'
  
  def target_step
    Step.all.select( 's.*, st.name as step_type_name' ).joins( 'as s, step_types as st' ).where( 's.id = ?', self.to_step_id ).where( 's.step_type_id = st.id' ).order( 's.id' ).first
  end
end