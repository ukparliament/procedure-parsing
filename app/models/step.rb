# # Step model.
# A step may be attached to routes in one or more procedures.
# A step has one or more inbound routes.
# A step has one or more outbound routes, or none. 
# Within a procedure, the [expected numbers of inbound and outbound routes depend on the type of the step](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps).
# A step belongs to one House, both Houses or neither.
class Step < ActiveRecord::Base
  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Commons.
  # This method evaluates as true if this step takes place in the House of Commons.
  def in_commons?
    in_commons = false
    in_commons = true  if self.commons_count != 0
    in_commons
  end
  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Lords.
  # This method evaluates as true if this step takes place in the House of Lords.
  def in_lords?
    in_lords = false
    in_lords = true  if self.lords_count != 0
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
end