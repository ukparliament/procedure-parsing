class Route < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :parliamentary_procedures, :through => 'procedure_routes'
  
  # Get the source step of a route.
  def source_step
    Step.all.select( 's.*, st.name as step_type_name' ).joins( 'as s, step_types as st' ).where( 's.step_type_id = st.id' ).where( 's.id = ?', self.from_step_id ).order( 's.id' ).first
  end
  
  # Get the target step of a route.
  def target_step
    Step.all.select( 's.*, st.name as step_type_name' ).joins( 'as s, step_types as st' ).where( 's.step_type_id = st.id' ).where( 's.id = ?', self.to_step_id ).order( 's.id' ).first
  end
  
  # Check if the route is current.
  def current
    
    # If the route has a start date and the start date is in the future, being today or beyond today ...
    if self.start_date and self.start_date >= Date.today
      
      # ... set current to false - the route is not yet active
      current = false
      
    # If the route has an end date and the end date is in the past, being earlier than ...
    elsif self.end_date and self.end_date < Date.today
      
      # ... set current to false - the route has ceased to be active
      current = false
      
    # Otherwise, if the route has no start date or a start date in the past or no end date or an end date in the future ...
    else
      
      # ... set current to true - the route is currently active
      current = true
    end
    current
  end
  
  # No longer used.
  # Check if the route is parseable.
  def is_parseable?( procedure, routes )
    
    # We assume the route is not parseable ...
    is_parseable = false
    
    # If the route has not been parsed ...
    if routes[self][:parse_pass_count] == 0
      
      # ... the route can be parsed.
      is_parseable = true
      
    # ... otherwise, if the route has been parsed ...
    else
      
      # ... we check the type of the source step ...
      case routes[self][:source_step_type]
        
      # ... if the source step of the route is of type AND or OR ...
      when "AND", "OR"
        
        # ... if both inbound routes to the source step have been parsed ...
        if routes[ self.source_step.inbound_routes_in_procedure( procedure )[0]][:parsed] == true and routes[ self.source_step.inbound_routes_in_procedure( procedure )[1]][:parsed] == true
          
          # ... then this route is parseable.
          is_parseable = true
        end
        
      # ... if the source step is not of type AND or OR ...
      else
        
        # ... if the inbound route to the source step has been parsed ...
        if routes[ self.source_step.inbound_routes_in_procedure( procedure )[0]][:parsed] == true
          
          # ... then this route is parseable.
          is_parseable = true
        end
      end
    end
    is_parseable
  end
end