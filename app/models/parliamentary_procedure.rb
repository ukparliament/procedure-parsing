# # Parliamentary procedure model.
# Renamed from the source schema because Rails reserves the name procedure.
class ParliamentaryProcedure < ActiveRecord::Base
  
  # We create an association to the routes which appear in a procedure.
  # A route may appear in one or more procedures, through the procedure_routes table.
  has_many :procedure_routes
  has_many :routes, :through => 'procedure_routes'
  
  # We create an association to the work packages subject to a procedure.
  has_many :work_packages
    
  # ## Method to return an array of start steps in a procedure.
    # New tables have been added to the database to reflect what we plan to happen with the step collections work: these place steps into a collection of start steps for a given procedure. Until this work happens, we'll need to hardcode an array.
  # This method returns an array of start steps and the name of each step’s type, to save on querying for this later.
  def start_steps
    Step.all.select('s.*, st.name as step_type_name' ).joins( 'as s, step_collections as sc, step_collection_types as sct, step_types as st' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self ).where( 's.step_type_id = st.id' )
  end
  
  # ## Method to return all routes which appear in a procedure, together with the name and type of the source step of each route and the name and type of the target step of each route. This saves us having to query for these later.
  def routes_with_steps
    Route.all.select( 'r.*, ss.name as source_step_name, ts.name as target_step_name, sst.name as source_step_type, tst.name as target_step_type' ).joins( 'as r, procedure_routes as pr, steps as ss, steps as ts, step_types as sst, step_types as tst' ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', self ).where( 'r.from_step_id = ss.id' ).where( 'r.to_step_id = ts.id' ).where( 'ss.step_type_id = sst.id' ).where( 'ts.step_type_id = tst.id' )
  end
  
  ###================
  
  # ## Method to return all steps connected to routes in a procedure, together with a count of the number of business items having a date in the past or of today actualising each step.
  # Todo: query needs work. actualisation_has_happened_count looks incorrect. Suspect it needs to group before left joining but don't know how to do that.
  def steps_with_actualisations_in_work_package( work_package )
    Step.find_by_sql( "select distinct(s.*), count(business_items.id) as actualisation_has_happened_count, count( hs1.id ) as commons_count, count( hs2.id ) as lords_count
      from steps s
      inner join routes r
        on (s.id = r.from_step_id)
      inner join procedure_routes pr
        on (r.id=pr.route_id
        and pr.parliamentary_procedure_id = #{self.id})
      left join actualisations
        on s.id = actualisations.step_id
      left join business_items
        on actualisations.business_item_id = business_items.id
        and business_items.date <= CURRENT_DATE
        and business_items.work_package_id = #{work_package.id}
      left join house_steps hs1
        on s.id = hs1.step_id
        and hs1.house_id = 1
      left join house_steps hs2
        on s.id = hs2.step_id
        and hs2.house_id = 2
      group by s.id;" 
    )
  end
  # =========================

  # ## A method to add ellipses to a description of a procedure, if the description is longer than 255 characters.
  def description_massaged
    description.length < 256 ? description : description + " ..."
  end
end