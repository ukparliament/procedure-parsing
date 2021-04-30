module StepHelper
  
  # ## Method to return the house label for a step.
  # We call the method with the ID of the step.
  def house_label_for_step_id( step_id )
    
    # We find the step object ...
    step = Step.find( step_id )
    
    # ... and call the house_label method.
    step.house_label
  end
end
