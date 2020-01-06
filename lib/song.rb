class Song
  attr_reader :id
  attr_accessor :name, :album_id

  @@songs = {}
  @@total_rows = 0

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @album_id = attributes.fetch(:album_id)
    @id = attributes.fetch(:id) || @@total_rows += 1
  end

  def ==(song_to_compare)
    (self.name() == song_to_compare.name()) && (self.album_id() == song_to_compare.album_id())
  end

  def self.all
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do |song|
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      id = song.fetch("id").to_i
      songs.push(Song.new({:name => name, :album_id => album_id, :id => id}))
    end
    songs
  end

  def save
    @@songs[self.id] = Song.new({:name => self.name, :album_id => self.album_id, :id => self.id})
  end

  def self.find(id)
    @@songs[id]
  end

  def update(name, album_id)
    self.name = name
    self.album_id = album_id
    @@songs[self.id] = Song.new({:name => self.name, :album_id => self.album_id, :id => self.id})
  end

  def delete
    @@songs.delete(self.id)
  end

  def self.clear
    @@songs = {}
  end

  def self.find_by_album(alb_id)
    songs = []
    @@songs.values.each do |song|
      if song.album_id == alb_id
        songs.push(song)
      end
    end
    songs
  end

  def album
    Album.find(self.album_id)
  end
end
