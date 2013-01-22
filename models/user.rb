class User
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :email,        String
  property :pass_hash,     String
  property :created_at,   DateTime

  has n, :torrents, :through => Resource
  has 2, :invite, :through => Resource
end
