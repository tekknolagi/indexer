class UserCookie
  include DataMapper::Resource
  
  property :user_id,      Integer
  property :value,        String
  property :created_at,   DateTime

  belongs_to :user, :required => false

  def self.new(id, value)
    create :user_id => id, :value => value, :created_at => Time.now
  end
end
