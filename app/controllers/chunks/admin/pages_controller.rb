module Chunks::Admin
  class PagesController < AdminController
    def index
      @pages = Chunks::Page.paginate(page: params[:page])
    end
    
    def new
      @page = Chunks::Page.new(template: params[:template])
      @available_templates = Chunks::AllTemplates unless params[:template]
    end
    
    def edit
      @page = Chunks::Page.find(params[:id])
    end
    
    def create
      @page = Chunks::Page.new(params[:chunks_page])
      @page.template ||= params[:template]
      if @page.save
        redirect_to chunks_admin_pages_path
      else
        @available_templates = Chunks::AllTemplates unless params[:template]
        render status: :error, action: "edit"
      end
    end
    
    def update
      @page = Chunks::Page.find(params[:id])
      @page.update_attributes(params[:chunks_page])
      if @page.save
        redirect_to chunks_admin_pages_path
      else
        render status: :error, action: "edit"
      end
    end
  end
end