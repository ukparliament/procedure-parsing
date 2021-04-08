# # Route model.
# A route is always from one step - its source via its from_step_id attribute - and to another step - its target via its to_step_id attribute.
class Route < ActiveRecord::Base
  
  # We create the association to the procedures a route is in.
  # A route might be in one or more procedures through the procedure_routes table.
  has_many :procedure_routes
  has_many :parliamentary_procedures, :through => 'procedure_routes'
  
  # ## A method to get the source step of a route.
  # This method also returns the name of the type of the source step to save on querying for this later.
  def source_step
    Step.all.select( 's.*, st.name as step_type_name' ).joins( 'as s, step_types as st' ).where( 's.step_type_id = st.id' ).where( 's.id = ?', self.from_step_id ).order( 's.id' ).first
  end
  
  # ## A method to get the target step of a route.
  # This method also returns the name of the type of the target step to save on querying for this later.
  def target_step
    Step.all.select( 's.*, st.name as step_type_name' ).joins( 'as s, step_types as st' ).where( 's.step_type_id = st.id' ).where( 's.id = ?', self.to_step_id ).order( 's.id' ).first
  end
  
  # ## A method to check if a route is currently traversible.
  def current
    
    # If the route has a start date and the start date is in the future, being today or beyond today ...
    if self.start_date and self.start_date >= Date.today
      
      # ... we set current to false - the route is not yet traversible.
      current = false
      
    # If the route has an end date and the end date is in the past, being earlier than today ...
    elsif self.end_date and self.end_date < Date.today
      
      # ... we set current to false - the route has ceased to be traversible.
      current = false
      
    # Otherwise, if the route has no start date or a start date in the past or no end date or an end date in the future ...
    else
      
      # ... we set current to true - the route is currently traversible.
      current = true
    end
    
    # We return the value we've set for the route's currency.
    current
  end
end