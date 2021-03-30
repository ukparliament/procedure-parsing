class ProcedureController < ApplicationController

  def index
    @procedures = ParliamentaryProcedure.all.order( 'name' )

    respond_to do |format|
      format.html
      format.xml { render xml: @procedures }
      format.json { render json: @procedures }
    end
  end
  
  def show
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
  end
  
  def work_package_index
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
  end
  
  def route_index
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
    @steps = Step.all
  end
  
  def route_create
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
    route = Route.new
    route.from_step_id = params[:route][:from_step_id]
    route.to_step_id = params[:route][:to_step_id]
    procedure_route = ProcedureRoute.new
    procedure_route.route = route
    procedure_route.parliamentary_procedure = @procedure
    procedure_route.save
    redirect_to procedure_route_list_url
  end
end
