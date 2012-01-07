class AudioConverter
  @queue = :audio_queue
  
  def self.perform(path, audio_file_name, audio_content_type, filename, last_audio_file_name)
    filename_with_ext = audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')
    complete_path = path
    path = path.chomp(filename_with_ext)

    #logger.debug "path: "+path
    #logger.debug "cd.audio.path = "+cd.audio.path
    #logger.debug "filename: "+filename
    #logger.debug "filename_with_ext: "+filename_with_ext


    # wenn nicht ogg, dann erstelle ogg
    if (audio_content_type != "audio/ogg")
      system("ffmpeg -i #{complete_path} -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 -y #{path+filename}.ogg")
      # entferne alte datei
    end

    # wenn nicht mp3 dann erstelle mp3
    if (audio_content_type != "audio/mp3")
      #logger.debug "convert to mp3: ffmpeg -i #{cd.audio.path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3"
      system("ffmpeg -i #{complete_path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3")
    end

    if (audio_content_type != "audio/ogg" && audio_content_type != "audio/mp3")
      system("rm #{complete_path}")
      delete = path+last_audio_file_name+".mp3"
      system("rm #{delete}")
    end
  end
end

