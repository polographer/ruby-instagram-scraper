require 'open-uri'
require 'json'
require 'ruby-instagram-response'
require 'pp'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"

  #
  # Legacy methods
  #

  def self.search ( query )
    # return false unless query
    url = "#{BASE_URL}/web/search/topsearch/"
    params = "?query=#{ query }"
    JSON.parse( open( "#{url}#{params}" ).read )
  end

  #doesn't work anymore
  def self.get_user_media_nodes ( username, max_id = nil )
    raise Exception.new("Endpoint /media is no longer working, don't use this function anymore")
  end

  def self.get_user ( username, max_id = nil )
    warn "[DEPRECATION] `get_user` endpoint looks like it's going to be deprecated.  Please use `get_user_by_id` instead you need for pagination anyway."
    url = "#{BASE_URL}/#{ username }/?__a=1"
    params = ""
    params = "&max_id=#{ max_id }" if max_id

    JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["user"]
  end

  def self.get_tag_media_nodes ( tag, max_id = nil )
    result = self._march_2018_get_tag_media(tag, 12, max_id)
    { nodes: result["data"]["hashtag"]["edge_hashtag_to_media"]["edges"], page: result["data"]["hashtag"]["edge_hashtag_to_media"]["page_info"] }
  end

  def self.get_media ( code )
    url = "#{BASE_URL}/p/#{ code }/?__a=1"
    params = ""
    JSON.parse( open( "#{url}#{params}" ).read )["graphql"]["shortcode_media"]
  end

  def self.get_media_comments ( shortcode, count = 40, before = nil )
    result = self._march_2018_get_media_comments(shortcode, count, before)
    result["data"]["shortcode_media"]["edge_media_to_comment"]["edges"]
  end

  def self.get_user_media_by_id(id, count=12, end_cursor=nil)
    data = self._march_2018_get_user(id,count, end_cursor)
    data["data"]["user"]["edge_owner_to_timeline_media"]["edges"]
  end

  #
  # code to rewrite every time tom catchs jerry
  # https://stackoverflow.com/questions/49265339/instagram-a-1-url-doesnt-allow-max-id
  #

  def self._march_2018_get_user(id, count=12, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=472f257a40c653c64c666ce877d59d2b&variables={"id":"93024","first":12,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=472f257a40c653c64c666ce877d59d2b&variables="
    params = {'id'=> id, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}" ).read )
  end

  def self._march_2018_get_tag_media(tag, count=12, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=298b92c8d7cad703f7565aa892ede943&variables={"tag_name":"iphone","first":12,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=298b92c8d7cad703f7565aa892ede943&variables="
    params = {'tag_name'=> tag, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}" ).read )
  end

  def self._march_2018_get_media_comments(shortcode, count=12, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=33ba35852cb50da46f5b5e889df7d159&variables={"shortcode":"Bf-I2P6grhd","first":20,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=33ba35852cb50da46f5b5e889df7d159&variables="
    params = {'shortcode'=> shortcode, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}" ).read )
  end

  #
  # Normalized Methods
  # this will provide a normalized "as much as possible" output
  #

  def self.get_user_media_objects(parameters)
    data = self.get_user_by_id(params[:id], params[:count], params[:end_cursor])
  end

end
