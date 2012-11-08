load 'dbconfig.rb'

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

class Tag
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String
  property :hits,    Integer

  has n, :torrents, :through => Resource
end

=begin
class User
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String
  property :email,        String
  property :created_at,   DateTime
  property :pass_hash     String

end
=end

DataMapper.finalize
DataMapper.auto_upgrade!

=begin

# create two resources
torrent = Torrent.create
tag     = Tag.create

# link them by adding to the relationship
torrent.tags << tag
torrent.save

# link them by creating the join resource directly
TorrentTag.create(:torrent => torrent, :tag => tag)

# unlink them by destroying the related join resource
link = torrent.torrent_tags.first(:tag => tag)
link.destroy

# unlink them by destroying the join resource directly
link = TorrentTag.get(torrent.id, tag.id)
link.destroy

=end
