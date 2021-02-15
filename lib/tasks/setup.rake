require 'csv'

task :import => [
  :import_step_types,
  #:import_steps,
  :import_houses,
  :import_routes,
  :import_parliamentary_procedures,
  :import_procedure_routes,
  :import_work_packages,
  :import_house_steps,
  :import_business_items,
  :import_actualisations] do
end

task :import_step_types => :environment do
  puts "importing step types"
  CSV.foreach( 'db/data/step-types.tsv', { :col_sep => "\t" } ) do |row|
    step_type = StepType.new
    step_type.id = row[0].to_i
    step_type.triple_store_id = row[1]
    step_type.name = row[2]
    step_type.description = row[3]
    step_type.save
    puts step_type.inspect
  end
end
task :import_steps => :environment do
  puts "importing steps"
  CSV.foreach( 'db/data/steps.tsv', { :col_sep => "\t" } ) do |row|
    step = Step.new
    step.id = row[0].to_i
    step.triple_store_id = row[1]
    step.name = row[2]
    step.description = row[5]
    step.step_type_id = row[10]
    step.save
  end
end
task :import_houses => :environment do
  puts "importing houses"
  CSV.foreach( 'db/data/houses.tsv', { :col_sep => "\t" } ) do |row|
    house = House.new
    house.id = row[0].to_i
    house.triple_store_id = row[1]
    house.name = row[2]
    house.save
  end
end
task :import_routes => :environment do
  puts "importing routes"
end
task :import_parliamentary_procedures => :environment do
  puts "importing parliamentary procedures"
end
task :import_procedure_routes => :environment do
  puts "importing procedure routes"
end
task :import_work_packages => :environment do
  puts "importing work packages"
end
task :import_house_steps => :environment do
  puts "importing house steps"
end
task :import_business_items => :environment do
  puts "importing business items"
end
task :import_actualisations => :environment do
  puts "importing actualisations"
end