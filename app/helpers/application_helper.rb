module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, { :sort => column, :direction => direction }, { :class => css_class }
  end

  #glyph(:share_alt) => <i class="icon-share-alt"></i> 
  #glyph(:lock, :white) => <i class="icon-lock icon-white"></i>
  def glyph(*names)
   content_tag :i, nil, class: names.map{|name| "icon-#{name.to_s.gsub('_','-')}" }
  end

  def raw_glyph(*names)
   raw(content_tag :i, nil, class: names.map{|name| "icon-#{name.to_s.gsub('_','-')}" })
  end

  def current_page(path)
    "active" if current_page?(path)
  end

  def current_section?(path)
    "active" if current_page?(path)
  end

  # Return true if user is on one of the pages
  def currently_on_page?(*pages)
    pages.each{ |p| return true if current_page?(p)}    
    false
  end

  #Code for each element on the slider
  def section_code(section, idea_id)
    completed = section.completed?(idea_id).to_s
    #TODO: Put code from slider for link generation
  end

  def paypal_currency
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency
  end

  def breaking_word_wrap(text, *args)
     options = args.extract_options!
     unless args.blank?
       options[:line_width] = args[0] || 80
     end
     options.reverse_merge!(:line_width => 80)
     text = text.split(" ").collect do |word|
       word.length > options[:line_width] ? word.gsub(/(.{1,#{options[:line_width]}})/, "\\1 ") : word
     end * " "
     text.split("\n").collect do |line|
       line.length > options[:line_width] ? line.gsub(/(.{1,#{options[:line_width]}})(\s+|$)/, "\\1\n").strip : line
     end * "\n"
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
