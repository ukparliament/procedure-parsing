class ParliamentaryProcedure < ActiveRecord::Base
  
  has_many :procedure_routes
  has_many :routes, :through => 'procedure_routes'
  has_many :work_packages
end
