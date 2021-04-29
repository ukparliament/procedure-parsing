# # Step model.
# A step may be attached to routes in one or more procedures.
# A step has one or more inbound routes.
# A step has one or more outbound routes, or none. 
# Within a procedure, the [expected numbers of inbound and outbound routes depend on the type of the step](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps).
# A step belongs to one House, both Houses or neither.
class Step < ActiveRecord::Base
  
  ###======================
  
  def outbound_route_ids( routes_from_steps )
    routes_from_steps[self.id]
  end
  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Commons.
  # This method evaluates as true if this step takes place in the House of Commons.
  def in_commons?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Commons' ).order( 'hs.id' ).first
  end
  

  
  # ## A method to select house steps - the join between steps and Houses - for a step taking place in the House of Lords.
  # This method evaluates as true if this step takes place in the House of Lords.
  def in_lords?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Lords' ).order( 'hs.id' ).first
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
  ###======================
  
  # ## A method to select all outbound routes from a step in a given procedure.
    # An outbound route is a route with a from_step_id attribute of this step's ID.
  #def outbound_routes_in_procedure( procedure )
    #Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.from_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
    #end
  
  # ## A method to select all inbound routes from a step in a given procedure.
    # An inbound route is a route with a to_step_id attribute of this step's ID.
  #def inbound_routes_in_procedure( procedure )
    #Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.to_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
    #end
  
  # ## A method to check whether a step has been actualised by a business item in a given work package, the business item having happened.
  # A business item is described as having happened if its date is today or before today.
  # This method evaluates as true for a given step, if that step has been actualised with one or more business items having happened.
  #def actualised_has_happened_in_work_package?( work_package )
    #BusinessItem.all.select( 'bi.*' ).joins( 'as bi, actualisations as a' ).where( 'a.step_id = ?', self ).where( 'a.business_item_id = bi.id' ).where( 'bi.work_package_id = ?', work_package ).where( 'bi.date <= ?', Date.today ).order( 'bi.id' ).first
    #end
  
  
end