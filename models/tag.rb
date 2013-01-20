class Tag
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String
  property :hits,    Integer

  has n, :torrents, :through => Resource
end
