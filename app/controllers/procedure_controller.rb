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
end
