class BusinessItem < ActiveRecord::Base
  
  has_many :actualisations
  has_many :steps, :through => 'actualisations'
  
  def step_names
    step_names = ''
    if self.steps.size == 1
      step_names += self.steps.first.name
    else
      self.steps.each do |step|
        step_names += step.name + ' <br /> '
      end
    end
    step_names
  end
end
