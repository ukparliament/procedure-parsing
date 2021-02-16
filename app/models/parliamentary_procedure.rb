class ParliamentaryProcedure < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :routes, :through => 'procedure_routes'
  has_many :work_packages
  
  def start_steps
    Step.all.select('s.*' ).joins( 'as s, step_collections as sc, step_collection_types as sct' ).where( 's.id = sc.step_id' ).where( 'sc.step_collection_type_id = sct.id' ).where( 'sct.name = ?', 'Start steps' ).where( 'sc.parliamentary_procedure_id =?', self )
  end
end
