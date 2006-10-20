class TranslateFormatText < ActiveRecord::Migration
  # Need to disable the Page's acts_as_versioned and acts_as_ferret method
  def self.up
    transaction do
      pages=Page.find :all
      pages.each do |page|
        page.content.gsub!( "{{{", "<pre>") 
        page.content.gsub!( "}}}", "</pre>") 
        page.content.gsub!( "\\\\", "\n")
        page.update
      end
    end
  end

  def self.down
    pages=Page.find :all
    transaction do
      pages.each do |page|
        puts "id: "+page.id.to_s
        page.content.gsub!( "<pre>", "{{{") 
        page.content.gsub!( "</pre>", "}}}") 
        page.update
      end
    end
  end
end
