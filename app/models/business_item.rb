class BusinessItem < ActiveRecord::Base
  
  has_many :actualisations
  has_many :steps, :through => 'actualisations'

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
