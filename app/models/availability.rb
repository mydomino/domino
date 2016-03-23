class Availability < ActiveRecord::Base
  belongs_to :profile

  def to_s
    "#{'M' if self.monday}" \
    " #{'Tu' if self.tuesday}" \
    " #{'W' if self.wednesday}" \
    " #{'Th' if self.thursday}" \
    " #{'F' if self.friday}" \
    " #{'Sa' if self.saturday}" \
    " #{'Su' if self.sunday}" \
    " #{'Mornings' if self.morning}" \
    " #{'Afternoons' if self.afternoon}" \
    " #{'Evenings' if self.evening}"
  end
end
