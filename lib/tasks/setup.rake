task :modify => [
  :import_step_types] do
end

task :import_step_types => :environment do
  puts "importing step types"
    CSV.foreach( 'db/data/step-types.csv' ) do |row|
      puts "lalla"
    end
  end
end