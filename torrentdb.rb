require 'data_mapper'
require 'dm-mysql-adapter'
require 'dm-pager'

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

class Invite
  include DataMapper::Resource

  property :id,           Serial
  property :code,         String
  property :email,        String
  property :used?,        Boolean, :default => false

  belongs_to :user, :required => false
end

class User
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :email,        String
  property :pass_hash,     String
  property :created_at,   DateTime

  has n, :torrents, :through => Resource
  has 1, :invite, :through => Resource

  #returns self if user pass is correct, else returns false.
  def authenticate(password_attempt)
    if BCrypt::Password.new(pass_hash) == password_attempt
      return self
    else
      false
    end
  end
  
end

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
