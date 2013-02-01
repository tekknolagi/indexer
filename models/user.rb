class User
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :email,        String
  property :pass_hash,    String
  property :created_at,   DateTime

  has n, :torrents, :through => Resource
  has 2, :invite, :through => Resource

  def self.new(email, username, password)
    pass_hash = BCrypt::Password.create password
    create :email => email, :name => username, :pass_hash => pass_hash, :created_at => Time.now
  end

  def authenticate(password_attempt)
    return self[:pass_hash] == BCrypt::Password.new(password_attempt)
  end

  def self.logged_in?
    
  end
 
  def sign_in(password_attempt)
    if authenticate password_attempt
      t = UserCookie.new :user_id => self[:id], :value => randomize(username, 128)
      t.save!
      session[:brightswipe_auth] = t[:value]
    end
  end

  def sign_out
    t = UserCookie.first :value => session[:brightswipe_auth]
    t.destroy! if t
  end
end
