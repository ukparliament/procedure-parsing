class WorkPackageController < ApplicationController
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  end
end
