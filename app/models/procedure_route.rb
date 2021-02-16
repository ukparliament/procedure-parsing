class ProcedureRoute < ActiveRecord::Base
  
  belongs_to :procedure
  belongs_to :route
end
