# # Route model.
# A route joins two steps: a source step and a target step. The source step for the route is identified by the from_step_id attribute and the target step for the route by the to_step_id attribute.
class Route < ActiveRecord::Base
  
  # We create an association to the procedures a route appears in.
  # A route may appear in one or more procedures, through the procedure_routes table.
  has_many :procedure_routes
  has_many :parliamentary_procedures, :through => 'procedure_routes'
end