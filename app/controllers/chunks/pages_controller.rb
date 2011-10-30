module Chunks
  class PagesController < ApplicationController
    def show
      @page = Chunks::Page.find(params[:id])
      render template: @page.template.view_name
    end
  end
end