class AudioConverter
  @queue = :audio_queue
  
  def self.perform(cd_id)
    cd = CompactDisk.find(cd_id)
    path = cd.audio.path
    filename = File.basename(cd.audio_file_name, File.extname(cd.audio_file_name).downcase)
    filename = filename.gsub( /[^a-zA-Z0-9_\.]/, '_')
    filename_with_ext = cd.audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')
    path = path.chomp(filename_with_ext)

    #logger.debug "path: "+path
    #logger.debug "cd.audio.path = "+cd.audio.path
    #logger.debug "filename: "+filename
    #logger.debug "filename_with_ext: "+filename_with_ext


    # wenn nicht ogg, dann erstelle ogg
    if (cd.audio_content_type != "audio/ogg")
      system("ffmpeg -i #{cd.audio.path} -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 -y #{path+filename}.ogg")
      # entferne alte datei
    end

    # wenn nicht mp3 dann erstelle mp3
    if (cd.audio_content_type != "audio/mp3")
      #logger.debug "convert to mp3: ffmpeg -i #{cd.audio.path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3"
      system("ffmpeg -i #{cd.audio.path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3")


    end

    if (cd.audio_content_type != "audio/ogg" && cd.audio_content_type != "audio/mp3")
      system("rm #{cd.audio.path}")
    end

    cd.audio_file_name = filename+".ogg"
    cd.audio_content_type = "audio/ogg"
    cd.save
  end
end

