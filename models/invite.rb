class Invite
  include DataMapper::Resource

  property :id,           Serial
  property :code,         String
  property :email,        String
  property :used?,        Boolean, :default => false

  belongs_to :user, :required => false
end
