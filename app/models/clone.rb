class Clone < ActiveRecord::Base
  has_many :snippets

  validates :name, presence: true, uniqueness: {case_sensitive: false}

end
