# add wiki syntax rules straight into RedCloth, 
# this prevents a lot of interesting rendering failures
require 'redcloth'
class RedClothWipo < RedCloth

  def initialize(text, existing_wiki_pages, rails_helper)
    super(text)
    @existing_wiki_pages = existing_wiki_pages
    @rails_helper = rails_helper
    #breakpoint
  end

  def refs_auto_link(text)
    @rails_helper.auto_link(text, @existing_wiki_pages)
  end

  def refs_insert_wiki_links(text)
    text.gsub!(Page::PAGE_LINK) do
      page = title = $1
      title = $2 unless $2.empty?
      if @existing_wiki_pages.include?(page)
        @rails_helper.link_to(title, @rails_helper.page_url(:page_title => page), :class => "existingWikiWord")
      else
        @rails_helper.content_tag("span", title + @rails_helper.link_to("?", @rails_helper.page_url(:page_title => page)), :class => "newWikiWord")
      end
    end
  end

  def to_html
    super(:refs_auto_link, :refs_insert_wiki_links, *DEFAULT_RULES)
  end

end 
