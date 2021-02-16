class Route < ActiveRecord::Base
  
  # Used to record if the route is current.
  # For routes with a start date, current means start date in past or today.
  # For routes with an end date, current means end date in future.
  attr_accessor :current
   def initialize( current )
     @current = current
   end
  
  # Used to record the state of the route as it's parsed, being NULL, TRUE, FALSE or UNTRAVERSABLE
  attr_accessor :status
   def initialize( status )
     @status = status
   end
  
  # Used to record if whether a route has been fully parsed or not.
  # Routes being output from an AND or an OR step may need to be parsed more than once depending on the parse order.
  # It is possible therefore for a route to have a parsed status of not NULL but to still not be fully parsed.
  # All routes start unparsed - obviously
  attr_accessor :parsed
   def initialize( parsed )
     @parsed = parsed
   end
  
  def target_step
    Step.where( 'id = ?', self.to_step_id ).first
  end
end