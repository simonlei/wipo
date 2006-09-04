# CalendarHelper allows you to draw a databound calendar with fine-grained CSS formatting
#
# Screw the license.
class Date
  def week
    return self.next.cweek
  end
end

module CalendarHelper
  # Returns an HTML calendar. In its simplest form, this method generates a plain
  # calendar (which can then be customized using CSS) for a given month and year.
  # However, this may be customized in a variety of ways -- changing the default CSS
  # classes, generating the individual day entries yourself, and so on.
  # 
  # The following options are required:
  #  :year  # The  year number to show the calendar for.
  #  :month # The month number to show the calendar for.
  # 
  # The following are optional, available for customizing the default behaviour:
  #   :table_class       => "calendar"        # The class for the <table> tag.
  #   :month_name_class  => "monthName"       # The class for the name of the month, at the top of the table.
  #   :other_month_class => "otherMonthClass" # Not implemented yet.
  #   :day_name_class    => "dayName"         # The class is for the names of the weekdays, at the top.
  #   :day_class         => "day"             # The class for the individual day number cells.
  #                                             This may or may not be used if you specify a block (see below).
  #   :abbrev            => (0..2)            # This option specifies how the day names should be abbreviated.
  #                                             Use (0..2) for the first three letters, (0..0) for the first, and
  #                                             (0..-1) for the entire name.
  # 
  # For more customization, you can pass a code block to this method, that will get one argument, a Date object,
  # and return a values for the individual table cells. The block can return an array, [cell_text, cell_attrs],
  # cell_text being the text that is displayed and cell_attrs a hash containing the attributes for the <td> tag
  # (this can be used to change the <td>'s class for customization with CSS).
  # This block can also return the cell_text only, in which case the <td>'s class defaults to the value given in
  # +:day_class+. If the block returns nil, the default options are used.
  # 
  # Example usage:
  #   calendar(:year => 2005, :month => 6) # This generates the simplest possible calendar.
  #   calendar({:year => 2005, :month => 6, :table_class => "calendar_helper"}) # This generates a calendar, as
  #                                                                             # before, but the <table>'s class
  #                                                                             # is set to "calendar_helper".
  #   calendar(:year => 2005, :month => 6, :abbrev => (0..-1)) # This generates a simple calendar but shows the
  #                                                            # entire day name ("Sunday", "Monday", etc.) instead
  #                                                            # of only the first three letters.
  #   calendar(:year => 2005, :month => 5) do |d| # This generates a simple calendar, but gives special days
  #     if listOfSpecialDays.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
  #       [d.mday, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
  #     else                                      # "normalDay". You can also use this highlight today differently
  #       [d.mday, {:class => "normalDay"}]       # from the rest of the days, etc.
  #   end
  def calendar(options = {}, &block)
    raise ArgumentError, "No year given"  unless defined? options[:year]
    raise ArgumentError, "No month given" unless defined? options[:month]

    block                        ||= Proc.new {|d| nil}
    options[:table_class       ] ||= "Calendar"
    options[:month_name_class  ] ||= "monthName"
    options[:other_month_class ] ||= "otherMonth"
    options[:day_name_class    ] ||= "dayName"
    options[:day_class         ] ||= "day"
    options[:abbrev            ] ||= (0..2)
    options[:show_week_link    ] ||= false

    first = Date.civil(options[:year], options[:month], 1)
    last = Date.civil(options[:year], options[:month], -1)
    @year = options[:year]
    @month = options[:month]
    case @month
    when 1 
      prev_year, next_year = @year-1, @year
      prev_month, next_month = 12, 2
    when 12
      prev_year, next_year = @year, @year+1
      prev_month, next_month = 11, 1
    else
      prev_year=next_year = @year
      prev_month, next_month = @month-1, @month+1
    end
    prev_month_link = link_to( "<",:controller => controller.controller_name, 
			     :action => controller.action_name, 
			     :year => prev_year,
			     :month => prev_month)
    next_month_link = link_to( ">",:controller => controller.controller_name, 
			     :action => controller.action_name, 
			     :year => next_year,
			     :month => next_month)
    show_month_link = link_to( Date::ABBR_MONTHNAMES[@month], 
			      :controller => controller.controller_name, 
			     :action => controller.action_name, 
			     :year => @year,
			     :month => @month)
    show_year_link = link_to( @year, 
			      :controller => controller.controller_name, 
			     :action => controller.action_name, 
			     :year => @year)

    cal = <<EOF
<table class="#{options[:table_class]}">
	<thead>
		<tr class="#{options[:month_name_class]}">
			<th>#{prev_month_link}</th>
			<th colspan="6">#{show_month_link}.#{show_year_link}</th>
			<th>#{next_month_link}</th>
		</tr>
		<tr class="#{options[:day_name_class]}">
	          <th>WEEK</th>
EOF
    Date::DAYNAMES.each {|d| cal << "			<th>#{d[options[:abbrev]]}</th>"}
    cal << "		</tr>
	</thead>
	<tbody>
		<tr>"
    show_week_link = show_week_link(first, options[:show_week_link])
    cal << "<td>#{show_week_link}</td>" 
    0.upto(first.wday - 1) {|d| cal << "			<td class='#{options[:other_month_class]}'></td>"} unless first.wday == 0
    first.upto(last) do |cur|
      cell_text, cell_attrs = block.call(cur)
      cell_text  ||= cur.mday
      cell_attrs ||= {:class => options[:day_class]}
      cell_attrs = cell_attrs.map {|k, v| "#{k}='#{v}'"}.join(' ')
      cal << "			<td #{cell_attrs}>#{cell_text}</td>"
      cal << "		</tr>\n		<tr>" if cur.wday == 6
      show_week_link = show_week_link(cur+1, options[:show_week_link])
      cal << "<td>#{show_week_link}</td>" if cur.wday == 6 and cur!=last
    end
    last.wday.upto(5) {|d| cal << "			<td class='#{options[:other_month_class]}'></td>"} unless last.wday == 6
    cal << "		</tr>\n	</tbody>\n</table>"
  end

  def show_week_link(day, show_link)
    return "W" + day.week.to_s if !show_link
    return link_to( "W" + day.week.to_s, 
		      :controller => controller.controller_name, 
		      :action => controller.action_name, 
		      :year => @year,
		      :week => day.week)
  end
end

