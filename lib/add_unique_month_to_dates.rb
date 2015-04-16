class Date
  def unique_month
    return self.year*12+self.month
  end
end

class DateTime
  def unique_month
    return self.year*12+self.month
  end
end

class Time
  def unique_month
    return self.year*12+self.month
  end
end

class ActiveRecord::Base
  def self.unique_month field
    case self.connection.adapter_name
      when 'SQLite' then "strftime('%Y', #{field})*12+strftime('%m', #{field})"
      when 'PostgreSQL' then "extract(year from #{field})*12+extract(month from #{field})"
      else "year(#{field})*12+month(#{field})" # MySQL, SQL Server, ...
    end
  end
end