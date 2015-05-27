class Snippet < ActiveRecord::Base
  belongs_to :clone
  has_ancestry

  validates :name, presence: true
  validates :name,
    uniqueness: {message: 'name already exists for this node and clone'},
    if: :name_exists_in_siblings_and_clone?


  attr_readonly :key

  before_save :set_key, on: :create

  def name_exists_in_siblings_and_clone?
    siblings.select do |s|
        s != self && s.name == self.name && s.clone == self.clone
    end.any?
  end

  def self.import(file)
      read_file = file.read
      file_hash = JSON.parse(read_file)
      parse(file_hash)
  end

  protected

  def generate_key
    (parent ? parent.generate_key + '-' : '') + name.downcase
  end

  private

  def self.parse(snippet_hash, parent = nil)
    snippet_hash.each do |key, value|
      params = {name: key, parent: parent}
      params[:content] = value unless value.class == Hash
      snippet = Snippet.new(params)
      snippet.save
      parse(value, snippet) if value.class == Hash
    end

  end

  def set_key
    self.key = generate_key
  end
end
