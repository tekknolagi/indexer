class Torrent
  include DataMapper::Resource

  property :id,          Serial
  property :name,        String
  property :info_hash,   String
  property :magnet,      Text
  property :created_at,  DateTime
  property :votes,       Integer
  property :downloads,   Integer
  property :description, Text

  has n, :tags, :through => Resource

  def self.insert(rfile, name, magnet, tags)
    tag_objs = Tag.add_multiple tags
    hash = get_torrent_hash rfile
    t = first_or_new({:info_hash => hash}, {:name => name, :magnet => magnet, :created_at => Time.now, :info_hash => hash})
    tag_objs.each {|tag|
      t.tags << tag
    }
    t.save!
  end

  def self.latest(limit=50, per_page=10, pagenum=1)
    all(:order => [:created_at.desc], :limit => limit).page(pagenum, :per_page => per_page)
  end

  def self.sort_by_date(torrents)
    torrents.sort_by {|x| x[:created_at]}.reverse
  end

  def self.rating(t)
    #A la Reddit
    t = DateTime.now.to_i - t[:created_at].to_i
    x = t[:downloads]
    if x > 0
      y = 1
    elsif x == 0
      y = 0
    else
      y = -1
    end
    if Math.abs(x) >= 1
      z = Math.abs(x)
    else
      z = 1
    end
    (Math.log10(z.to_f)+y*t.to_f/45000.0).to_i
  end

  def self.by_id(id)
    first :id => id
  end
end

