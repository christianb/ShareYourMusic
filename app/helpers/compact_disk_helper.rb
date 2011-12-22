module CompactDiskHelper
  def getSongs(cd)
    logger.debug "cd title: "+cd.title
    logger.debug "songs:"
    songs_array = Song.where(:compact_disk_id => cd.id)
    if (!songs_array.empty?)
      logger.debug songs_array
      logger.debug "length: "+songs_array.size.to_s
      logger.debug "song id: "+songs_array[0].id.to_s
      logger.debug "song title: "+songs_array[0].title
      #logger.debug "songs array: "+songs_array
      string = ""
      songs_array.each do |s|
        logger.debug "#title: "+s.title
        string = string + s.title + "<br>"
      end
      return string
    end
    return ""
  end
end
