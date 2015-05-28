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
      snippets = JSON.parse(file.read)
      parse(snippets)
  end

  def self.export
    roots.map { |root| encode root }.to_json
  end

  protected

  def generate_key
    (parent ? parent.generate_key + '-' : '') + name.downcase
  end

  private

  def set_key
    self.key ||= generate_key
  end

  def self.parse(snippets, parent = nil)
    snippets.each do |node|
      params =
        {name: node['name'],
         content: node['content'],
         key: node['key'],
         clone: Clone.find_by_name(node['clone']),
         parent: parent}
      snippet = Snippet.new(params)
      snippet.save
      parse(node['children'], snippet)
    end
  end

  def self.encode(node)
    {name: node.name,
     key: node.key,
     content: node.content,
     clone: (node.clone.name if node.clone),
     children: node.children.map { |child| encode child }}
  end
end
