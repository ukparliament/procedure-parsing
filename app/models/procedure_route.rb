class ProcedureRoute < ActiveRecord::Base
  
  belongs_to :parliamentary_procedure
  belongs_to :route
end
