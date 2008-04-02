# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def include page, page_title
    page_included=Page.find :first, :conditions=>["title=? and space_id=?", page_title[1..-1], page.space.id]
    markup page_included, page_included.content
  end

  def code page, param
    "<pre>"
  end

  def dailyComic page, param
    time = Time.now
    "<img src=\"#{time.strftime( param)[1..-1]}\"/>"
  end

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

  MACRO_RE= /(^|[^\{])\{(\w*)(:[^}*]*)?\}/ unless const_defined?(:MACRO_RE)

  class WipoRedCloth < RedCloth
    def initialize(page, text, existing_wiki_pages, rails_helper)
      super(text)
      @existing_wiki_pages = existing_wiki_pages
      @rails_helper = rails_helper
      @page = page
      #breakpoint
    end

    def block_macro_run(text)
      text.gsub!(MACRO_RE) do
        macro_name, parameters = $2, $3
        @rails_helper.send( macro_name, @page, parameters)
      end
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
      text.gsub!(Page::PAGE_LINK) do
        page = title = $1
        page = $2 unless $2.empty?
        if page =~ /^\d+$/ # it's a id
          @rails_helper.link_to title, :controller=>"page", :action=>"show", :id=>page.to_i
        elsif page =~ /^http/ # it's a link already
          "<a href=\"#{page}\">#{title}</a>"
        elsif page =~ /^\^/ # it's a ref to attach
          page=page[1..-1]
          if page =~ /(jpg|jpeg|gif|bmp|png)$/i # it's a img
            "<img src=\"#{@rails_helper.url_for(:controller=>"page", :action=>"download_attach", :page_id=>@page.id, :name=>page)}\" />"
          else # give the link
            @rails_helper.link_to(title, :controller=>"page", :action=>:download_attach, :page_id=>@page.id, :name=>page)
          end
        elsif @existing_wiki_pages.include?(page)
          @rails_helper.link_to(title, page_url(page), :class => "existingWikiWord")
        else
          @rails_helper.content_tag("span", title + @rails_helper.link_to("?", new_page_url(page)), :class=>"newWikiWord")
        end
      end
    end

    private
    def new_page_url title
      @rails_helper.url_for :controller=>"page", :action=>"new", :space_id=>@page.space.id, :type=>"Wiki", :title=>title
    end

    def page_url title
      @rails_helper.display_page_url :space_name => @page.space.name, :page_title=>title
    end
  end

  def markup page, content, existing_page=nil 
    existing_page_titles = page.space.existing_page_titles if existing_page.nil?
    return WipoRedCloth.new(page, content, existing_page_titles,self).to_html( :refs_insert_wiki_links, :refs_auto_link, :block_macro_run, *RedCloth::DEFAULT_RULES) 
  end

  def differences(original, new)
    HTMLDiff.diff(original, new)
  end
end
