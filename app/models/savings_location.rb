class SavingsLocation < ActiveRecord::Base

  def self.find_city_info(city_or_zip)
    selector = is_zip(city_or_zip) ? 'zipcode =' : 'city ilike'
    rest = "#{city_or_zip}"
    rest += '%' unless is_zip(city_or_zip)
    return self.select("id, city, state").where("#{selector} ?", rest)
  end

  def self.is_zip(zip)
    return zip.to_i.to_s.size == 5
  end
end
