class StepCollectionMembership < ApplicationRecord
  
  belongs_to :step
  belongs_to :step_collection
end
