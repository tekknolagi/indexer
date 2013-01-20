class Torrent
  include DataMapper::Resource

  property :id,          Serial
  property :name,        String
  property :info_hash,   String
  property :magnet,      Text
  property :created_at,  DateTime
  property :votes,       Integer
  property :downloads,   Integer

  has n, :tags, :through => Resource
end

