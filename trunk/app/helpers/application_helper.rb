# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  PAGE_LINK = /\[([^\]|]*)[|]?([^\]]*)\]/

  def url_for_user user
    if user.personal_space_id > 0
      link_to user.login, {:controller=>"space", :action=>"show_home", :id => user.personal_space_id}, :class=>'user_link'
    else
      link_to user.login, {:controller=>"/active_rbac/user", :action=>"show", :id=>user}, :class=>'user_link'
    end
  end

  def time_to_str time
    time.strftime "%Y 年 %m 月 %d 日 %H:%M" unless time.nil?
  end
  
  # ========================#
  # pasted from wiki helper
  # ========================#
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

  AUTO_LINK_RE = /
                (                       #   leading text
                  <\w+.*?>|             #   leading HTML tag, or
                  [^=!:'"\/]|           #   leading punctuation, or 
                  ^                     #   beginning of line
                )
                (
                  (?:http[s]?:\/\/)|    # protocol spec, or
                  (?:www\.)             # www.*
                ) 
                (
                  ([\w]+:?[=?&\/.-]?)*  # url segment
                  \w+[\/]?              # url tail
                  (?:\#\w*)?            # trailing anchor
                )
                ([[:punct:]]|\s|<|$)    # trailing text
               /x unless const_defined?(:AUTO_LINK_RE)

  class WipoRedCloth < RedCloth
    def initialize(space_name, text, existing_wiki_pages, rails_helper)
      super(text)
      @existing_wiki_pages = existing_wiki_pages
      @rails_helper = rails_helper
      @space_name = space_name
      #breakpoint
    end

    # TextHelper's auto link doesn't change text, so I rewrite it.
    def refs_auto_link(text)
      @rails_helper.auto_link(text)
      text.gsub!(AUTO_LINK_RE) do
        all, a, b, c, d = $&, $1, $2, $3, $5
        if a =~ /<a\s/i # don't replace URL's that are already linked
          all
        else
          text = b + c
          %(#{a}<a href="#{b=="www."?"http://www.":b}#{c}">#{text}</a>#{d})
        end
      end
    end

    def refs_insert_wiki_links(text)
      text.gsub!(PAGE_LINK) do
        page = title = $1
        page = $2 unless $2.empty?
        #puts "============="
        #puts page
        #puts title
        #puts "------------"
        if page =~ /^http/
          "<a href=\"#{page}\">#{title}</a>"
        elsif @existing_wiki_pages.include?(page)
          @rails_helper.link_to(title, page_url(page), :class => "existingWikiWord")
        else
          # Should be new page url
          @rails_helper.content_tag("span", title + @rails_helper.link_to("?", page_url(page)), :class=>"newWikiWord")
        end
      end
    end

    private
    def page_url title
      #@rails_helper.display_page_url :controller => 'page', :action => 'display', :space_name => @space_name, :page_title=>title
      @rails_helper.display_page_url :space_name => @space_name, :page_title=>title
    end
  end

  def markup page, existing_page=nil 
    existing_page_titles = page.space.existing_page_titles if existing_page.nil?
    return WipoRedCloth.new(page.space.name, page.content, existing_page_titles,self).to_html( :refs_insert_wiki_links, :refs_auto_link, *RedCloth::DEFAULT_RULES) 
  end

  def differences(original, new)
    HTMLDiff.diff(original, new)
  end
end
