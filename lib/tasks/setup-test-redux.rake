require 'csv'

task :import_test_redux_1 => [
  :test_import_step_types,
  :test_import_parliamentary_procedures,
  :test_import_work_packages] do
end

task :import_test_redux_2 => [
  :test_import_step_collection_types,
  :test_import_step_collections,
  :test_import_business_items,
  :test_import_actualisations
  ] do
end