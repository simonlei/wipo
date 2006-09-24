class AttachmentController < ApplicationController
  scaffold :attachment

  def list
    @page = Page.find( params[:id])
    @attachments = @page.attachments
  end

  def delete
    attach=Attachment.find( params[:id])
    page = attach.page
    File.unlink File.join( ATTACHMENT_DIR, page.id.to_s, attach.name) rescue nil
    attach.destroy
    redirect_to :action=>'list', :id=>page
  end

  def download
    attach=Attachment.find( params[:id])
    send_file File.join( ATTACHMENT_DIR, attach.page_id.to_s, attach.name) 
  end

  # Add this line to get uplaod status for your action 
  upload_status_for :upload

  def upload
    case request.method
    when :post
      file = params[:document][:file]
      page_id = params[:page_id]
      @message = '文件上传成功，大小：' + file.size.to_s

      redirect_to :action => 'list', :id=>page_id

      finish_upload_status "'#{@message}'"
      # create attachment
      if file
        save_file page_id, file
      end
        
      attach = Attachment.new 
      attach.name = file.original_filename
      attach.size = file.size
      attach.page_id = page_id
      attach.user_id = current_user.id
      attach.description = params[:comment]

      Page.find( params[:page_id]).attachments << attach
    end
  end

  private

  def create_directory page_id
    FileUtils.mkdir_p File.join( ATTACHMENT_DIR, page_id)
  end

  def save_file page_id, file
    create_directory page_id
    # write_attribute ' extension', file_data.original_filename.split('.').last.downcase
    path = File.join( ATTACHMENT_DIR, page_id, file.original_filename)
    FileUtils.copy file.path, path
  end
end
