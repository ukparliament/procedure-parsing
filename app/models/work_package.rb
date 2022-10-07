require 'open-uri'
require 'nokogiri'

class WorkPackage < ActiveRecord::Base
  
  belongs_to :parliamentary_procedure
  # https://guides.rubyonrails.org/caching_with_rails.html
  def web_link_meta_tags
    # Rails.cache.fetch([web_link], :expires => 1.hour) do
      Nokogiri::HTML(URI.open(self.web_link)).xpath('//meta')
    # end
  end

  def web_link_links
    # Rails.cache.fetch([web_link], :expires => 1.hour) do
    Nokogiri::HTML(URI.open(self.web_link)).xpath('//link')
    # end
  end
  
  def business_items_that_have_happened
    BusinessItem.find_by_sql(
      "
        SELECT bi.*, step_display_depth.display_depth as display_depth
        FROM business_items bi, actualisations a, steps s
        
        /* Left join to get the step depth where present. */
        LEFT JOIN
          (
            SELECT sdd.display_depth as display_depth, sdd.step_id
            FROM step_display_depths sdd
            WHERE sdd.parliamentary_procedure_id = #{self.parliamentary_procedure.id}
          ) step_display_depth
          ON s.id = step_display_depth.step_id
          
        WHERE bi.work_package_id = #{self.id}
        AND bi.date <= '#{Date.today}'
        AND bi.id = a.business_item_id
        AND a.step_id = s.id
        ORDER BY bi.date, display_depth;
      "
    )
  end

  def business_items_that_are_scheduled_to_happen
    BusinessItem.find_by_sql(
      "
        SELECT bi.*, step_display_depth.display_depth as display_depth
        FROM business_items bi, actualisations a, steps s
        
        /* Left join to get the step depth where present. */
        LEFT JOIN
          (
            SELECT sdd.display_depth as display_depth, sdd.step_id
            FROM step_display_depths sdd
            WHERE sdd.parliamentary_procedure_id = #{self.parliamentary_procedure.id}
          ) step_display_depth
          ON s.id = step_display_depth.step_id
          
        WHERE bi.work_package_id = #{self.id}
        AND bi.date > '#{Date.today}'
        AND bi.id = a.business_item_id
        AND a.step_id = s.id
        ORDER BY bi.date, display_depth;
      "
    )
  end
  
  def business_items_unknown
    BusinessItem.find_by_sql(
      "
        SELECT bi.*, step_display_depth.display_depth as display_depth
        FROM business_items bi, actualisations a, steps s
        
        /* Left join to get the step depth where present. */
        LEFT JOIN
          (
            SELECT sdd.display_depth as display_depth, sdd.step_id
            FROM step_display_depths sdd
            WHERE sdd.parliamentary_procedure_id = #{self.parliamentary_procedure.id}
          ) step_display_depth
          ON s.id = step_display_depth.step_id
          
        WHERE bi.work_package_id = #{self.id}
        AND bi.date is null
        AND bi.id = a.business_item_id
        AND a.step_id = s.id
        ORDER BY bi.date, display_depth;
      "
    )
  end

  def business_items_that_have_happened_number
    case business_items_that_have_happened.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_that_have_happened.to_s
    end
  end

  def business_items_that_are_scheduled_to_happen_number
    case business_items_that_are_scheduled_to_happen.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_that_are_scheduled_to_happen.to_s
    end
  end
  
  def business_items_unknown_number
    case business_items_unknown.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_unknown.to_s
    end
  end
end
