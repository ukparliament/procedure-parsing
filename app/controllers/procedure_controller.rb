class ProcedureController < ApplicationController

  def index
    @procedures = ParliamentaryProcedure.find_by_sql(
      "
        select p.*
        from parliamentary_procedures p
        inner join (
        	select parliamentary_procedure_id
        	from work_packages
        	group by parliamentary_procedure_id
        ) work_packages
        on work_packages.parliamentary_procedure_id = p.id
        order by name;
      "
    )

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
  
  def step_index
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
    @work_packages = @procedure.work_packages
    @concluded_work_packages = @procedure.concluded_work_packages
    @steps_with_work_package_count = @procedure.steps_with_work_package_count
  end
  
  def work_package_index
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
  end
  
  def route_index
    procedure = params[:procedure]
    @procedure = ParliamentaryProcedure.find( procedure )
    @routes = @procedure.routes_with_steps
  end
end
