
task :toggle_visibility => :environment do
  puts "Toggling visibility of a business step"
  
  # Get the EVEL considered business step.
  step = Step.all.where( 'name = ?', 'Considered for English votes for English laws (EVEL) certification' ).first
  
  # Find the EVEL considered business step in the Website visible steps collection.
  step_collection_membership = StepCollectionMembership.all.where( 'step_id = ?', step.id).where( 'step_collection_id = ?', 4 ).first
  
  # Delete the EVEL considered business step from the Website visible steps collection.
  step_collection_membership.destroy
end


task :toggle_visibility_2 => :environment do
  puts "Toggling visibility of a business step"
  
  # Get the EVEL English only business step.
  step = Step.all.where( 'name = ?', 'Certified as England only under the English votes for English laws (EVEL) process' ).first
  
  # Find the EVEL English only business step in the Website visible steps collection.
  step_collection_membership = StepCollectionMembership.all.where( 'step_id = ?', step.id).where( 'step_collection_id = ?', 4 ).first
  
  # Delete the EVEL English only business step from the Website visible steps collection.
  step_collection_membership.destroy
end


