class AttachmentController < ApplicationController
  scaffold :attachment

  def list
    @attachments = Page.find(params[:page_id]).attachments
  end
end
