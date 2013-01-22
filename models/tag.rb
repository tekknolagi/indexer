class Tag
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String
  property :hits,    Integer

  has n, :torrents, :through => Resource

  def self.exists?(tag)
    count(:name => tag) != 0
  end

  def self.add(tag)
    first_or_new :name => tag
  end

  def self.add_multiple(list)
    objs = []
    list.each {|tag|
      objs.push(add_tag tag)
    }
    objs
  end
  
  def self.torrents(tags, limit=20)
    torrents = []
    tags.each {|tag|
      tago = all :name => tag
      tagn = Torrent.all :name.like => "%#{tag}%"
      torrents.push tago.torrents
      torrents.push *tagn
    }
    return torrents.flatten.uniq
  end
end
