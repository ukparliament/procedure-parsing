class InstrumentController < ApplicationController
  
  def show
    instrument = params[:instrument]
    @work_package = WorkPackage.find_by_work_packaged_thing_triplestore_id( instrument )
    redirect_to( work_package_show_url( :work_package => @work_package.triplestore_id) ) if @work_package
  end
end
