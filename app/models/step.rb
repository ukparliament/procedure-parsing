# # Step model.
# A step may have one or more inbound routes and zero, one or more outbound routes.
# The [expected count of inbound and outbound routes in a procedure depends on the type of the step](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/?jj#validating-inputs-and-outputs-to-steps).
# A step might be attached to routes in one or more procedures.
# A step belongs to one House, both Houses or neither.
class Step < ActiveRecord::Base
  
  # ## We get all outbound routes from a step in the given procedure.
  # An outbound route is one with a from_step_id attribute of this step's ID.
  def outbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.from_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  # ## We get all inbound routes from a step in the given procedure.
  # An inbound route is one with a to_step_id attribute of this step's ID.
  def inbound_routes_in_procedure( procedure )
    Route.all.select( 'r.*' ).joins( 'as r, procedure_routes as pr' ).where( 'r.to_step_id = ?', self ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', procedure )
  end
  
  # # We get whether a step has been actualised by a business item in this work package having happened.
  # A business item is described as having happened if its date is today or earlier than today.
  # This method evaluates as true for a given step if that step has been actualised with one or more business steps having happened.
  def actualised_has_happened_in_work_package?( work_package )
    BusinessItem.all.select( 'bi.*' ).joins( 'as bi, actualisations as a' ).where( 'a.step_id = ?', self ).where( 'a.business_item_id = bi.id' ).where( 'bi.work_package_id = ?', work_package ).where( 'bi.date <= ?', Date.today ).order( 'bi.id' ).first
  end
  
  # ## We get houses steps - the join between steps and Houses - for this step in the House of Commons.
  # This method evaluates as true if this step takes place in the House of Commons.
  def in_commons?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Commons' ).order( 'hs.id' ).first
  end
  
  # ## We get houses steps - the join between steps and Houses - for this step in the House of Lords.
  # This method evaluates as true if this step takes place in the House of Lords.
  def in_lords?
    HouseStep.all.select( 'hs.*' ).joins( 'as hs, houses as h' ).where( 'hs.step_id = ?', self ).where( 'hs.house_id = h.id').where( 'h.name =?', 'House of Lords' ).order( 'hs.id' ).first
  end
  
  # ## We construct a house label for a step.
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
    house_label
  end
end