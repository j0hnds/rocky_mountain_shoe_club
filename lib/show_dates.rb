module ShowDates
  # The next show after the specified date.
  def next_show_date(from_date=Date.today)
   from_month = from_date.month
   if from_month < 3
     march_show_date(from_date.year)
   elsif from_month == 3
     march_show = march_show_date(from_date.year)
     (from_date.day < march_show.day) ? march_show : september_show_date(from_date.year)
   elsif from_month < 9
     september_show_date(from_date.year)
   elsif from_month == 9
     september_show = september_show_date(from_date.year)
     (from_date.day < september_show.day) ? september_show : march_show_date(from_date.year + 1)
   else
     march_show_date(from_date.year + 1)
   end
  end

  # First saturday in march for the specified year
  def march_show_date(year=Date.today.year)
   d = Date.parse("#{year}-03-01")
   d + (6 - d.wday).days
  end

  # First saturday after labor day of the specified year
  def september_show_date(year=Date.today.year)
   labor_day_date(year) + 5.days
  end

  # First monday in september of the specified year.
  def labor_day_date(year=Date.today.year)
   d = Date.parse("#{year}-09-01")
   d + ((d.wday <= 1) ? (1 - d.wday).days : (8 - d.wday).days)
  end
end