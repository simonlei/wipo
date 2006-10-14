class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Weblog

  def after_save(record)
    # 把cache全删了
    FileUtils.rm_rf(RAILS_ROOT + "/public/index.html")
    FileUtils.rm_rf(RAILS_ROOT + "/public/space/")
    FileUtils.rm_rf(RAILS_ROOT + "/public/page/")
    FileUtils.rm_rf(RAILS_ROOT + "/public/display/")
  end
end
