# # Parliamentary procedure class.
# Renamed from the source schema because Rails reserves the name procedure.
class ParliamentaryProcedure < ActiveRecord::Base
  
  # We create an association to the routes in a procedure.
  # A route might be in one or more procedures through the procedure_routes table.
  has_many :procedure_routes
  has_many :routes, :through => 'procedure_routes'
  
  # We create an association to the work packages subject to a procedure.
  has_many :work_packages

  # ## A method to add elipses to a description of a procedure if the description is longer than 255 characters.
  def description_massaged
    description.length < 256 ? description : description + "..."
  end
  
  # ## We return an array of start steps in a procedure.
  # Parsing starts from each of the start steps.
  # New tables have been added to the database to reflect what we plan to happen with the step collections work. These place steps into a collection of start steps for a given procedure. Until this work happens, we'll need to hardcode an array.
  # This method also returns the name of the type of each start step, which should always be business steps.
  def start_steps
    Step.all.select('s.*, st.name as step_type_name' ).joins( 'as s, step_collections as sc, step_collection_types as sct, step_types as st' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self ).where( 's.step_type_id = st.id' )
  end
  
  # ## We return all routes in a procedure.
  # We use this method in preference to the basic procedure.routes association to also return the name and type of the source step of each route and the name and type of the target step of each route. This saves us having to query for these later.
  def routes_with_steps
    Route.all.select( 'r.*, ss.name as source_step_name, ts.name as target_step_name, sst.name as source_step_type, tst.name as target_step_type' ).joins( 'as r, procedure_routes as pr, steps as ss, steps as ts, step_types as sst, step_types as tst' ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', self ).where( 'r.from_step_id = ss.id' ).where( 'r.to_step_id = ts.id' ).where( 'ss.step_type_id = sst.id' ).where( 'ts.step_type_id = tst.id' )
  end
end
