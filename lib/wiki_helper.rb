module WikiHelper
  def nlink_to(name, options = {}, html_options = {}, *parameters_for_method_reference)
    link_to(name, options, html_options.update(:class => "navlink"), *parameters_for_method_reference)
  end

  def page_title
    if @page && (@page.title == 'Home Page') && (%w( show published print ).include?(@controller.action_name))
      @book.name
    elsif @book
      "#{@title} in #{@book.name}"
    else
      @title
    end
  end
  
  def page_heading
    if @page && (@page.title == 'Home Page') && (%w( show published print ).include?(@controller.action_name))
      @book.name
    elsif @book
      content_tag("small", @book.name) + tag("br") + @title
    else
      @title
    end
  end

  def markup page, existing_page=nil 
    existing_page_titles = page.space.existing_page_titles if existing_page.nil?
    return RedClothWipo.new(page.content, existing_page_titles, self).to_html
  end

  def differences(original, new)
    HTMLDiff.diff(original, new)
  end
  
  def link_to_author(author)
    link_to(author.name, page_url(:page_title => author)) + " (#{author.ip})"
  end

  def page_url title
    url_for :controller => 'page', :action => 'show', :id => 1
  end
end 
