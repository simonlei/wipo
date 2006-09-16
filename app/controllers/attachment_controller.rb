class AttachmentController < ApplicationController
  scaffold :attachment

  def list
    @page = Page.find( params[:id])
    @attachments = @page.attachments
  end
end
