class Availability < ActiveRecord::Base
  belongs_to :profile

  def days_to_s
    "#{'M' if self.monday}" \
    " #{'Tu' if self.tuesday}" \
    " #{'W' if self.wednesday}" \
    " #{'Th' if self.thursday}" \
    " #{'F' if self.friday}" \
    " #{'Sa' if self.saturday}" \
    " #{'Su' if self.sunday}" 
  end

  def times_to_s
    "#{'Mornings' if self.morning}" \
    " #{'Afternoons' if self.afternoon}" \
    " #{'Evenings' if self.evening}"
  end
end
