# Songs eines Albums
def searchMBrainz(art, alb)
query = Webservice::Query.new
filter = Webservice::ReleaseFilter.new(:title => alb, :artist => art)
release = query.get_releases(filter)
if (!release.empty?)
  # get mbid of first
  mbid = release.entities[0].id.to_s;
  
  entities = release.entities
  asin = ""
  year = nil
  tracks = nil
  
  entities.each { |e|
    logger.debug "next entity"
    mbid = e.id.to_s
    r = query.get_release_by_id(mbid, :artist=>true, :tracks=>true, :release_events => true)
    if (!r.asin.nil?)
      asin = r.asin.to_s
      if year.nil?
        year = r.release_events[0].date.year
      end
      if tracks.nil?
        tracks = r.tracks
      end
      break
    end
  }

  cover_url = nil
  unless asin.nil?
    cover_url = generate_cover_url(asin)
  else
    cover_url = ""
  end
  
  results_from_rbrainz = {
      :tracks => tracks.to_a,
      :cover_url => cover_url,
      :year => year
  }

  return results_from_rbrainz
end
  return nil
end