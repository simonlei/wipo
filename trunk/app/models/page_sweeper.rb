class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Weblog

  def after_save(record)
    case record
      when Page:
        puts "=Begin=Sweep==#{record}==========================="
        expire_page :controller=>"space", :action=>"show"
        expire_page(:controller=>"space", :action=>"show", :id=>record.space.id)
        expire_page(:controller=>"page", :action=>"show", :id=>record.id)
        puts "=End=Sweep======#{record.id}======================="
      # when Comment:
        # Comment 的话，只要expire spaces和当前page就行
    end
  end
end
