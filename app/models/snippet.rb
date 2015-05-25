class Snippet < ActiveRecord::Base
  belongs_to :clone
  has_ancestry

  validates :name, presence: true
  validates :name,
    uniqueness: {scope: :clone,
      if: :name_exists_in_siblings?,
      message: "name already exists for this node and clone"}

  before_save :set_key

  def name_exists_in_siblings?
    return false unless parent
    siblings_excluding_self = parent.children.select { |s| s != self }
    siblings_excluding_self.map(&:name).include?(name)
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
