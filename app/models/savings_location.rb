class SavingsLocation < ActiveRecord::Base

  def self.find_city_info(city_or_zip)
    selector = is_zip(city_or_zip) ? 'zipcode =' : 'city ilike'
    rest = "#{city_or_zip}"
    rest += '%' unless is_zip(city_or_zip)
    self.select("id, city, state").where("#{selector} ?", rest)
  end

  def self.is_zip(zip)
    zip.to_i.to_s.size == 5
  end

  def self.find_by_params(params)
    if params[:id]
      result = self.where('id = ?', params[:id])
    elsif params[:zip]
      result = self.where('zipcode = ?', params[:zip])
    elsif params[:city] && params[:state]
      result = self.where('city = ? and state = ?', params[:city].downcase,
                          params[:state].downcase)
    end

    result.first if result
  end
end
