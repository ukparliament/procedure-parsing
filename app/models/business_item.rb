class BusinessItem < ActiveRecord::Base
  
  has_many :actualisations
  has_many :steps, :through => 'actualisations'
  
  def steps_with_house_count
    Step.find_by_sql(
      "
        SELECT s.*, SUM(commons_step.is_commons) AS is_in_commons, SUM(lords_step.is_lords) AS is_in_lords
        FROM steps s
        INNER JOIN actualisations a
      	  ON s.id = a.step_id
          AND a.business_item_id = #{self.id}
        LEFT JOIN
          (
            SELECT 1 as is_commons, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 1
            GROUP BY hs.id
          ) commons_step
          ON s.id = commons_step.step_id
        LEFT JOIN
          (
            SELECT 1 as is_lords, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 2
            GROUP BY hs.id
          ) lords_step
          ON s.id = lords_step.step_id
        GROUP BY s.id;
      "
    )
  end
  
  def visible_steps_with_house_count( procedure )
    Step.find_by_sql(
      "
        SELECT s.*, SUM(commons_step.is_commons) AS is_in_commons, SUM(lords_step.is_lords) AS is_in_lords, step_display_depth.display_depth
        FROM steps s
        INNER JOIN actualisations a
      	  ON s.id = a.step_id
          AND a.business_item_id = #{self.id}
        LEFT JOIN
          (
            SELECT 1 AS is_commons, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 1
            GROUP BY hs.id
          ) commons_step
          ON s.id = commons_step.step_id
        LEFT JOIN
          (
            SELECT 1 AS is_lords, hs.step_id
            FROM house_steps hs
            WHERE hs.house_id = 2
            GROUP BY hs.id
          ) lords_step
          ON s.id = lords_step.step_id
        LEFT JOIN
          (
            SELECT s.id AS step_id, sdd.display_depth AS display_depth
            FROM steps s, step_display_depths sdd
            WHERE s.id = sdd.step_id
            AND sdd.parliamentary_procedure_id = #{procedure.id}
          ) step_display_depth
          ON s.id = step_display_depth.step_id,
        step_collection_memberships scm, step_collections sc
        WHERE s.id = scm.step_id
        AND scm.step_collection_id = sc.id
        AND sc.label = 'Website visible steps'
        GROUP BY s.id, step_display_depth.display_depth
        ORDER BY step_display_depth.display_depth;
      "
    )
  end

  def web_link_domain
     if web_link
       uri = URI.parse( web_link.strip )
       case uri.scheme
       when "https"
         uri.host
       when "http"
         uri.host
       else
         ""
       end
     else
       ''
     end
   end

  def step_names
    step_names = ''
    if self.steps.size == 1
      step_names += self.steps.first.name + ' (' + self.steps.first.house_label + ')'
    else
      self.steps.each do |step|
        step_names += step.name + ' (' + self.steps.first.house_label + ')' + ' <br /> '
      end
    end
    step_names
  end
end
