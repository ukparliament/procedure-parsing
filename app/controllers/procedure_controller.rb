class ProcedureController < ApplicationController
  
  def index
    @procedures = ParliamentaryProcedure.all.order( 'name' )
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
