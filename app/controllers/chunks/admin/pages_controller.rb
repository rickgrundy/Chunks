module Chunks::Admin
  class PagesController < AdminController
    def index
      @pages = Chunks::Page.paginate(page: params[:page])
    end
    
    def edit
      @page = Chunks::Page.find(params[:id])
    end
    
    def new
      @available_templates = Chunks::AllTemplates
      @page = Chunks::Page.new(template: params[:template])
    end
    
    def create
      @page = Chunks::Page.new(params[:chunks_page])
      if @page.save
        redirect_to chunks_admin_pages_path
      else
        render status: :error, action: "edit"
      end
    end
  end
end