class Snippet < ActiveRecord::Base
  belongs_to :clone
  has_ancestry

  validates :name, presence: true,
            uniqueness: {scope: :clone,
                         message: "should only have one per clone"}
  before_save :set_key

  protected

  def generate_key
    (parent ? parent.generate_key + '-' : '') + name.downcase
  end

  private

  def set_key
    self.key = generate_key
  end
end
