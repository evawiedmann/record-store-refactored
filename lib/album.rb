class Album
  attr_accessor :name, :id
  # :release_year

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    # @release_year = attributes.fetch(:release_year)
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
    # @release_year = result.first().fetch("release_year")
  end

  def ==(album_to_compare)
    (self.name == album_to_compare.name)
     # && (self.release_year == album_to_compare.release_year)
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    Album.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
  DB.exec("DELETE FROM albums WHERE id = #{@id};")
  DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
end

  def songs
    Song.find_by_album(@id)
  end

  def sort_by_year()
    album_list = DB.exec("SELECT * FROM albums ORDER BY RELEASE_YEAR;")
  end
end
