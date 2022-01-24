# # Step model.
# A step may be attached to routes in one or more procedures.
# A step has one or more inbound routes.
# A step has one or more outbound routes, or none. 
# Within a procedure, the [expected numbers of inbound and outbound routes depend on the type of the step](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#validating-inputs-and-outputs-to-steps).

# A step belongs to one House, both Houses or neither.
class Step < ActiveRecord::Base
  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Commons.
  # This method evaluates as true if this step takes place in the House of Commons.
  def in_commons?
    in_commons = false
    in_commons = true  if self.is_in_commons
    in_commons
  end
  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Lords.
  # This method evaluates as true if this step takes place in the House of Lords.
  def in_lords?
    in_lords = false
    in_lords = true  if self.is_in_lords
    in_lords
  end
  
  # ## A method to construct a House label for a step.
  def house_label
    house_label = ''
    
    # If the step takes place in both Houses ...
    if self.in_commons? and self.in_lords?
      
      # ... we set the label to say both Houses. 
      house_label = 'House of Commons and House of Lords'
      
    # Otherwise, if the step only takes place in the House of Commons ...
    elsif self.in_commons?
      
      # ... we set the label to say House of Commons.
      house_label = 'House of Commons'
      
    # Otherwise, if the step only takes place in the House of Lords ...
    elsif self.in_lords?
      
      # ... we set the label to say House of Lords.
      house_label = 'House of Lords'
      
    # Otherwise, the step must take place in neither House ...
    else
      
      # ... so we set the label appropriately.
      house_label = 'Neither House'
    end
    
    # We return the house label.
    house_label
  end
  
  # ## A method to construct a full label for a step.
  # This includes the name of the step, the type of the step - unless the step is a business step, and the house label for the step.
  def full_label_with_house
    full_label_with_house = self.name
    unless self.step_type_name == 'Business step'
      full_label_with_house += ' ' + self.step_type_name
    else
      full_label_with_house += ' (' + self.house_label + ')'
    end
    full_label_with_house
  end
  
  # ## A method to construct a class for nodes (steps) in the SVG map of a work package.
  # This uses the actualisation or otherwise of the step and the parsed status of its inbound route to construct a class for the step.
  def class_for_node( inbound_route_status  )
    class_for_node = ''
    
    # If the step is a business step ...
    if self.step_type_name == 'Business step'
      
      # ... we want to add its current state.
      # If the business step has been actualised ...
      if self.is_actualised
        
        # ... we add 'current-actualised' to the class.
        class_for_node += 'current-actualised'
        
      # If business step has not been actualised ...
      else
        
        # ... we add 'current-unactualised' to the class.
        class_for_node += 'current-unactualised'
      end
      
      # ... we want to add its future state.
      # We add a future value to the class based on the status of the inbound route.
      class_for_node += " future-#{inbound_route_status.downcase}"
      
    # If the step is not a business step ...
    else
      
      # ... we add 'non-business-step' to the class.
      class_for_node += 'non-business-step'
    end
    class_for_node
  end
  
  # ## A method to calculate the occurrence score for a step.
    def occurrence_score( work_package_count, concluded_work_package_count, bicamerally_concluded_work_package_count )
    occurrence_score = ''

    # If the step is marked as being in the Lords ...
    # ... it must be either in the Lords or a joint step ...
    if self.in_lords?
      
      # ... so we compare against the number of bicamerally concluded work packages.
      # Noting that joint steps are also marked as as being in the Lords.
      occurrence_score += "#{( ( work_package_count.to_f / bicamerally_concluded_work_package_count.to_f ) * 100 ).round(2)}%"
      
    # Otherwise, if the step is not in the Lords ...
    # ... it must be either in the Commons or outside of Parliament ...
    else
      
      # ... so we compare against the total number of concluded work packages.
      occurrence_score += "#{( ( work_package_count.to_f / concluded_work_package_count.to_f ) * 100 ).round(2)}%"
    end
    occurrence_score
  end
end