require 'csv'

task :import => [
  :import_step_types,
  :import_steps,
  :import_houses,
  :import_routes,
  :import_parliamentary_procedures,
  :import_procedure_routes,
  :import_work_packages,
  :import_house_steps,
  :import_business_items,
  :import_actualisations,
  :import_step_collection_types,
  :import_step_collections] do
end

task :import_step_types => :environment do
  puts "importing step types"
  CSV.foreach( 'db/data/step-types.tsv', :col_sep => "\t" ) do |row|
    step_type = StepType.new
    step_type.id = row[0]
    step_type.triple_store_id = row[0]
    step_type.name = row[2]
    step_type.description = row[3]
    step_type.save
  end
end
task :import_steps => :environment do
  puts "importing steps"
  CSV.foreach( 'db/data/steps.tsv', :col_sep => "\t" ) do |row|
    step = Step.new
    step.id = row[0]
    step.triple_store_id = row[1]
    step.name = row[2]
    step.description = row[5]
    step.step_type_id = row[10]
    step.save
  end
end
task :import_houses => :environment do
  puts "importing houses"
  CSV.foreach( 'db/data/houses.tsv', :col_sep => "\t" ) do |row|
    house = House.new
    house.id = row[0]
    house.triple_store_id = row[1]
    house.name = row[2]
    house.save
  end
end
task :import_routes => :environment do
  puts "importing routes"
  CSV.foreach( 'db/data/routes.tsv', :col_sep => "\t" ) do |row|
    route = Route.new
    route.id = row[0]
    route.triple_store_id = row[1]
    route.from_step_id = row[2]
    route.to_step_id = row[3]
    route.start_date = row[7]
    route.end_date = row[8]
    route.save
  end
end
task :import_parliamentary_procedures => :environment do
  puts "importing parliamentary procedures"
  CSV.foreach( 'db/data/procedures.tsv', :col_sep => "\t" ) do |row|
    parliamentary_procedure = ParliamentaryProcedure.new
    parliamentary_procedure.id = row[0]
    parliamentary_procedure.triple_store_id = row[1]
    parliamentary_procedure.name = row[2]
    parliamentary_procedure.description = row[3]
    parliamentary_procedure.save
  end
end
task :import_procedure_routes => :environment do
  puts "importing procedure routes"
  CSV.foreach( 'db/data/procedure_routes.tsv', :col_sep => "\t" ) do |row|
    procedure_route = ProcedureRoute.new
    procedure_route.id = row[0]
    procedure_route.route_id = row[1]
    procedure_route.parliamentary_procedure_id = row[2]
    procedure_route.save
  end
end
task :import_work_packages => :environment do
  puts "importing work packages"
  CSV.foreach( 'db/data/work_packages.tsv', :col_sep => "\t" ) do |row|
    work_package = WorkPackage.new
    work_package.id = row[0]
    work_package.triple_store_id = row[1]
    work_package.web_link = row[2]
    work_package.work_packaged_thing_triple_store_id = row[3]
    work_package.parliamentary_procedure_id = row[4]
    work_package.save
  end
end
task :import_house_steps => :environment do
  puts "importing house steps"
  CSV.foreach( 'db/data/house_steps.tsv', :col_sep => "\t" ) do |row|
    house_step = HouseStep.new
    house_step.id = row[0]
    house_step.step_id = row[1]
    house_step.house_id = row[2]
    house_step.save
  end
end
task :import_business_items => :environment do
  puts "importing business items"
  CSV.foreach( 'db/data/business_items.tsv', :col_sep => "\t" ) do |row|
    business_item = BusinessItem.new
    business_item.id = row[0]
    business_item.triple_store_id = row[1]
    business_item.web_link = row[2]
    business_item.work_package_id = row[3]
    business_item.date = row[6]
    business_item.save
  end
end
task :import_actualisations => :environment do
  puts "importing actualisations"
  CSV.foreach( 'db/data/actualisations.tsv', :col_sep => "\t" ) do |row|
    actualisation = Actualisation.new
    actualisation.id = row[0]
    actualisation.business_item_id = row[1]
    actualisation.step_id = row[2]
    actualisation.save
  end
end
task :import_step_collection_types => :environment do
  puts "importing step collection types"
  CSV.foreach( 'db/data/step_collection_types.tsv', :col_sep => "\t" ) do |row|
    step_collection_type = StepCollectionType.new
    step_collection_type.name = row[0]
    step_collection_type.save
  end
end
task :import_step_collections => :environment do
  puts "importing step collections"
  CSV.foreach( 'db/data/step_collections.tsv', :col_sep => "\t" ) do |row|
    step_collection = StepCollection.new
    step_collection.step_id = row[4]
    step_collection.parliamentary_procedure_id = row[2]
    step_collection.step_collection_type_id = row[0]
    step_collection.save
  end
end