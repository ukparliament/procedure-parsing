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
    @work_packages = WorkPackage.all
  end
end
