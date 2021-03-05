DB_HOST="peerages.postgres.database.azure.com"
DB_DATABASE="procedures"
DB_USERNAME="<username>"
DB_PASSWORD="<password>"


# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

RUBY_THREAD_VM_STACK_SIZE=10000000