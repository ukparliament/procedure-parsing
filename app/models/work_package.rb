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
        SELECT bi.*, step_display_depth.minimum_display_depth as minimum_display_depth
        FROM business_items bi
        
        /* We only want to include business items that actualise a step in the 'Website visible steps' collection. */
        /* So we left join to actualisations, steps and step collections ... */
        LEFT JOIN (
        
          /* ... counting the number of actualisations of steps in the 'Website visible steps' collection. */
          SELECT a.business_item_id, count(a.id) AS actualisation_count
          FROM actualisations a, steps s, step_collection_memberships scm, step_collections sc
          WHERE a.step_id = s.id
          AND s.id = scm.step_id
          AND scm.step_collection_id = sc.id
          AND sc.label = 'Website visible steps'
          GROUP BY a.business_item_id
        ) actualisations
        ON actualisations.business_item_id = bi.id
        
        /* We want to order by the minimum step depth of all steps actualised by the business item. */
        /* So we left join to actualistions, steps and step display depths ... */
        LEFT JOIN (
        
          /* ... returning the minimum display depth of steps actualised by this business item in this procedure. */
          SELECT a.business_item_id, MIN(sdd.display_depth) AS minimum_display_depth
          FROM actualisations a, steps s, step_display_depths sdd
          WHERE a.step_id = s.id
          AND s.id = sdd.step_id
          AND sdd.parliamentary_procedure_id = #{self.parliamentary_procedure_id}
          GROUP BY a.business_item_id
        ) step_display_depth
        ON step_display_depth.business_item_id = bi.id
        
        WHERE bi.work_package_id = #{self.id}
        
        /* We only include business items with a date of today or earlier. */
        AND bi.date <= '#{Date.today}'
        
        /* We only include business items actualising visible steps. */
        AND actualisations.actualisation_count > 0
        
        /* We order, first by the date of the business item, then by the step depth. */
        ORDER BY bi.date, step_display_depth.minimum_display_depth;
      "
    )
  end

  def business_items_that_are_scheduled_to_happen
    BusinessItem.find_by_sql(
      "
        SELECT bi.*, step_display_depth.minimum_display_depth as minimum_display_depth
        FROM business_items bi
        
        /* We only want to include business items that actualise a step in the 'Website visible steps' collection. */
        /* So we left join to actualisations, steps and step collections ... */
        LEFT JOIN (
        
          /* ... counting the number of actualisations of steps in the 'Website visible steps' collection. */
          SELECT a.business_item_id, count(a.id) AS actualisation_count
          FROM actualisations a, steps s, step_collection_memberships scm, step_collections sc
          WHERE a.step_id = s.id
          AND s.id = scm.step_id
          AND scm.step_collection_id = sc.id
          AND sc.label = 'Website visible steps'
          GROUP BY a.business_item_id
        ) actualisations
        ON actualisations.business_item_id = bi.id
        
        /* We want to order by the minimum step depth of all steps actualised by the business item. */
        /* So we left join to actualistions, steps and step display depths ... */
        LEFT JOIN (
        
          /* ... returning the minimum display depth of steps actualised by this business item in this procedure. */
          SELECT a.business_item_id, MIN(sdd.display_depth) AS minimum_display_depth
          FROM actualisations a, steps s, step_display_depths sdd
          WHERE a.step_id = s.id
          AND s.id = sdd.step_id
          AND sdd.parliamentary_procedure_id = #{self.parliamentary_procedure_id}
          GROUP BY a.business_item_id
        ) step_display_depth
        ON step_display_depth.business_item_id = bi.id
        
        WHERE bi.work_package_id = #{self.id}
        
        /* We only include business items with a date in the future. */
        AND bi.date > '#{Date.today}'
        
        /* We only include business items actualising visible steps. */
        AND actualisations.actualisation_count > 0
        
        /* We order, first by the date of the business item, then by the step depth. */
        ORDER BY bi.date, step_display_depth.minimum_display_depth;
      "
    )
  end
  
  def business_items_unknown
    BusinessItem.find_by_sql(
      "
        SELECT bi.*, step_display_depth.minimum_display_depth as minimum_display_depth
        FROM business_items bi
        
        /* We only want to include business items that actualise a step in the 'Website visible steps' collection. */
        /* So we left join to actualisations, steps and step collections ... */
        LEFT JOIN (
        
          /* ... counting the number of actualisations of steps in the 'Website visible steps' collection. */
          SELECT a.business_item_id, count(a.id) AS actualisation_count
          FROM actualisations a, steps s, step_collection_memberships scm, step_collections sc
          WHERE a.step_id = s.id
          AND s.id = scm.step_id
          AND scm.step_collection_id = sc.id
          AND sc.label = 'Website visible steps'
          GROUP BY a.business_item_id
        ) actualisations
        ON actualisations.business_item_id = bi.id
        
        /* We want to order by the minimum step depth of all steps actualised by the business item. */
        /* So we left join to actualistions, steps and step display depths ... */
        LEFT JOIN (
        
          /* ... returning the minimum display depth of steps actualised by this business item in this procedure. */
          SELECT a.business_item_id, MIN(sdd.display_depth) AS minimum_display_depth
          FROM actualisations a, steps s, step_display_depths sdd
          WHERE a.step_id = s.id
          AND s.id = sdd.step_id
          AND sdd.parliamentary_procedure_id = #{self.parliamentary_procedure_id}
          GROUP BY a.business_item_id
        ) step_display_depth
        ON step_display_depth.business_item_id = bi.id
        
        WHERE bi.work_package_id = #{self.id}
        
        /* We only include business items with no date. */
        AND bi.date is null
        
        /* We only include business items actualising visible steps. */
        AND actualisations.actualisation_count > 0
        
        /* We order, first by the date of the business item, then by the step depth. */
        ORDER BY bi.date, step_display_depth.minimum_display_depth;
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
