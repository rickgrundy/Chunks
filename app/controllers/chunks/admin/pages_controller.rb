module Chunks::Admin
  class PagesController < AdminController
    def index
      @pages = Chunks::Page.paginate(page: params[:page])
      @pages = @pages.where(template: params[:template]) if params[:template]
      @pages = @pages.where("LOWER(title) like ?", "%#{params[:q].downcase}%") if params[:q]
    end
    
    def show
      redirect_to edit_admin_page_path(params[:id])
    end
    
    def new
      @page = Chunks::Page.new(template: params[:template])
      @available_templates = Chunks.config.templates unless params[:template]
    end
    
    def create
      @page = Chunks::Page.new(params[:page])
      @page.template ||= params[:template]
      if @page.save
        redirect_to edit_admin_page_path(@page)
      else
        @available_templates = Chunks.config.templates unless params[:template]
        render status: :error, action: "edit"
      end
    end
    
    def edit
      @page = Chunks::Page.find(params[:id])
    end
    
    def update
      @page = Chunks::Page.find(params[:id])
      if @page.update_all_chunks(params[:page])
        redirect_to admin_pages_path
      else
        render status: :error, action: "edit"
      end
    end
  end
end