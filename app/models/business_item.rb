class BusinessItem < ActiveRecord::Base
  
  has_many :actualisations
  has_many :steps, :through => 'actualisations'
  
  def steps_with_house_count
    Step.find_by_sql(
      "select s.*, count( hs1.id ) as commons_count, count( hs2.id ) as lords_count
      from steps s
      inner join actualisations
      on s.id = actualisations.step_id 
      and actualisations.business_item_id = #{self.id}
      left join house_steps hs1
        on s.id = hs1.step_id
        and hs1.house_id = 1
      left join house_steps hs2
        on s.id = hs2.step_id
        and hs2.house_id = 2
      group by s.id"
    )
  end

  def web_link_domain
     if web_link
       uri = URI.parse(web_link)
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
