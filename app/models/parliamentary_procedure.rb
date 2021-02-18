class ParliamentaryProcedure < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :routes, :through => 'procedure_routes'
  has_many :work_packages
  
  def start_steps
    Step.all.select('s.*, st.name as step_type_name' ).joins( 'as s, step_collections as sc, step_collection_types as sct, step_types as st' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self ).where( 's.step_type_id = st.id' )
  end
  
  def routes_with_steps
    Route.all.select( 'r.*, ss.name as source_step_name, ts.name as target_step_name, sst.name as source_step_type, tst.name as target_step_type' ).joins( 'as r, procedure_routes as pr, steps as ss, steps as ts, step_types as sst, step_types as tst' ).where( 'r.id = pr.route_id' ).where( 'pr.parliamentary_procedure_id = ?', self ).where( 'r.from_step_id = ss.id' ).where( 'r.to_step_id = ts.id' ).where( 'ss.step_type_id = sst.id' ).where( 'ts.step_type_id = tst.id' )
  end
end
