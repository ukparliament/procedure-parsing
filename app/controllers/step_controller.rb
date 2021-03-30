class StepController < ApplicationController
  
  def index
    @steps = Step.all
    @step_types = StepType.all
  end
  
  def create
    @step = Step.new
    @step.name = params[:step][:name]
    @step.description = params[:step][:description]
    @step.step_type_id = params[:step][:step_type_id]
    @step.save
    redirect_to step_list_url
  end
end
