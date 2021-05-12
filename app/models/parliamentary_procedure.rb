# # Parliamentary procedure model.
# Table and model renamed from the source schema because Rails reserves the name 'procedure'.
class ParliamentaryProcedure < ActiveRecord::Base
  
  # The procedure_routes table joins parliamentary_procedures to their routes, allowing a route to appear in many procedures and a procedure to have many routes.
  has_many :procedure_routes
  
  # A procedure may have many routes, through the procedure_routes table.
  has_many :routes, :through => 'procedure_routes'
  
  # We create an association to the work packages subject to a procedure.
  # Many work packages may be subject to the same procedure.
  has_many :work_packages
    
  # ## Method to return an array of start steps in a procedure.
    # New tables have been added to the database to reflect what we plan to happen with the [step collections](https://ukparliament.github.io/ontologies/procedure/procedure-ontology.html#d4e244) work: these place steps into a collection of start steps for a given procedure. Until this work happens, we'll need to hardcode an array.
  # This method returns an array of start steps and the name of the type of each step, to save on querying for this later.
  def start_steps
    Step.all.select('s.*, st.name as step_type_name' ).joins( 'as s, step_collections as sc, step_collection_types as sct, step_types as st' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self ).where( 's.step_type_id = st.id' )
  end
  
  # ## Method to return all routes which appear in a procedure, together with the name and type of the source step of each route and the name and type of the target step of each route. This saves us having to query for these later.
  def routes_with_steps
    Route.all.select( 'r.*, ss.name as source_step_name, ts.name as target_step_name, sst.name as source_step_type, tst.name as target_step_type' ).joins( 'as r, procedure_routes as pr, steps as ss, steps as ts, step_types as sst, step_types as tst' ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', self ).where( 'r.from_step_id = ss.id' ).where( 'r.to_step_id = ts.id' ).where( 'ss.step_type_id = sst.id' ).where( 'ts.step_type_id = tst.id' )
  end
  
  # ## Method to return all steps connected to routes in a procedure, together with a count of the number of business items having a date in the past or of today actualising each step.
  def steps_with_actualisations_in_work_package( work_package )
    Step.find_by_sql(
      "
        SELECT s.*, SUM(commons_step.is_commons) AS is_in_commons, SUM(lords_step.is_lords) AS is_in_lords, SUM(actualisations.is_actualised_has_happened) AS is_actualised_has_happened
        FROM steps s
        INNER JOIN routes r
        	ON r.to_step_id = s.id
        INNER JOIN procedure_routes pr
        	ON pr.route_id = r.id
        	AND pr.parliamentary_procedure_id = #{self.id}
        LEFT JOIN
          (
            SELECT 1 as is_commons, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 1
          ) commons_step
          ON s.id = commons_step.step_id
        LEFT JOIN
          (
            SELECT 1 as is_lords, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 2
          ) lords_step
          ON s.id = lords_step.step_id
        LEFT JOIN
          (
            SELECT 1 as is_actualised_has_happened, a.step_id
            FROM business_items bi, actualisations a
            WHERE bi.id = a.business_item_id
            AND bi.date <= CURRENT_DATE
            AND bi.work_package_id = #{work_package.id}
          ) actualisations
          ON s.id = actualisations.step_id
          GROUP BY s.id;
      "
    )
  end

  # ## A method to add an ellipsis to a description of a procedure, if the description text is longer than 255 characters.
  def description_massaged
    description.length < 256 ? description : description + " ..."
  end
end