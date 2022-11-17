class MetaController < ApplicationController
  
  def index
  end
  
  def schema
  end
  
  def comments
  end
  
  def bookmarklet
  end
  
  def link_check
  end
  
  def link_check_work_package
    @work_packages = WorkPackage.all.order( 'id' )
  end
  
  def link_check_business_item
    @business_items = BusinessItem.all.order( 'id' )
  end
end
