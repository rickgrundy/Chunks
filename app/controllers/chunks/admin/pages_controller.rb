module Chunks::Admin
  class PagesController < AdminController
    def index
      @pages = Chunks::Page.paginate(:page => params[:page])
    end
    
    def edit
      @page = Chunks::Page.find(params[:id])
    end
    
    def new
      @templates = Chunks::Template.all
      @page = Chunks::Page.new
    end
    
    def create
      @page = Chunks::Page.create!(params[:chunks_page])
    end
  end
end