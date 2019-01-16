require 'open-uri'
require 'json'
require 'ruby-instagram-response'
require 'pp'
require 'nokogiri'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"
  DEFAULT_COUNT = 10
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

  #
  # Legacy methods
  #

  def self.search ( query )
    url = "#{BASE_URL}/web/search/topsearch/"
    params = "?query=#{ query }"
    JSON.parse( open( "#{url}#{params}" , 'User-Agent' => USER_AGENT ).read )
  end

  #doesn't work anymore
  def self.get_user_media_nodes ( username, max_id = nil )
    raise Exception.new("Endpoint /media is no longer working, you can get similar data with `get_user_media_by_id`, don't use this function anymore")
  end

  def self.get_user ( username )
    self._get_media_user_by_name_proxy(username)["graphql"]["user"]
  end

  def self.get_tag_media_nodes ( tag, max_id = nil )
    raise Exception.new("Endpoint /media is no longer working, don't use this function anymore")
  end

  def self.get_media ( code )
    url = "#{BASE_URL}/p/#{ code }/?__a=1"
    params = ""
    JSON.parse( open( "#{url}#{params}", 'User-Agent' => USER_AGENT ).read )["graphql"]["shortcode_media"]
  end

  def self.get_media_comments ( shortcode, count = DEFAULT_COUNT, before = nil )
    raise Exception.new("Endpoint /media is no longer working, don't use this function anymore")
  end

  def self.get_user_media_by_id(id, count=DEFAULT_COUNT, end_cursor=nil)
    raise Exception.new("Endpoint /media is no longer working, don't use this function anymore")
  end

  #
  # Normalized Methods
  # this will provide a normalized "as much as possible" (simple hashes) output
  #

  def self.normalized_user_media_by_name(name)
    raw = self._get_media_user_by_name_proxy(name)
    #pp raw
    data = raw["entry_data"]["ProfilePage"][0]
    result = RubyInstagramResponse.new(
      :userdata => data["graphql"]["user"], 
      :media => self.flatten_media_edge_array(data["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]), 
      :page => data["graphql"]["user"]["edge_owner_to_timeline_media"]["page_info"],
      :raw => data )
  end

  def self.normalized_user_media_by_uid(id, count=DEFAULT_COUNT, end_cursor=nil)
    raise Exception.new("Endpoint /media is no longer working, don't use this function anymore")
  end

  def self.normalized_media_by_code(code)
    url = "#{BASE_URL}/p/#{ code }/?__a=1"
    params = ""
    data = JSON.parse( open( "#{url}#{params}" ).read )
    result = RubyInstagramResponse.new(
      :media => self.add_virtual_fields(data["graphql"]["shortcode_media"]),
      :likes => data["graphql"]["shortcode_media"]["edge_media_preview_like"]["edges"].map{|n| n["node"]},
      :comments => data["graphql"]["shortcode_media"]["edge_media_to_comment"]["edges"].map{|n| n["node"]},
      :raw => data)
    #pp result
    result
  end

  def self.normalized_likes_by_shortcode(shortcode)
    raw = self._get_media_likes_by_shortcode(shortcode)
    #pp raw
    result = RubyInstagramResponse.new(
      :media => self.add_virtual_fields(raw["data"]["shortcode_media"]),
      :likes => raw["data"]["shortcode_media"]["edge_liked_by"]["edges"].map{|n| n["node"]},
      :raw => raw)
  end

  private
  #proxy calls
  
  def self._get_media_user_by_id_proxy(id, count, end_cursor)
    self._march_2018_get_user_by_id(id, count, end_cursor)
  end

  def self._get_media_comments_proxy(id, count, end_cursor)
    self._march_2018_get_media_comments(id, count, end_cursor)
  end
  #_march_2018_get_tag_media
  def self._get_tag_media_proxy(id, count, end_cursor)
    self._march_2018_get_tag_media(id, count, end_cursor)
  end

  def self._get_media_user_by_name_proxy(name)
    #self._march_2018_get_user_by_name(name)
    self._jun_2018_get_user_by_name(name)
  end

  def self._get_media_likes_by_shortcode(shortcode)
    self._jan_2019_get_media_likes(shortcode)
  end

  #
  # Utilities
  #

  # def self.add_virtual_fields_for_media_details(data)
  #   result = data["graphql"]["shortcode_media"]
  #   result['likes_count'] = result['edge_media_preview_like']['count']
  #   result['comments_count'] = result['edge_media_to_comment']['count']
  #   result["owner_id"] = result["owner"]["id"]
  #   result
  # end

  def self.flatten_media_edge_array(data)
    data.map {|n| self.add_virtual_fields(n["node"]) }
  end

  def self.tags_from_string (title)
    tags = title.scan(/(?:^|\s)#(\w+)/i)
    if not tags.nil?
      tags = tags.join(" ")
    end
    tags
  end

  def self.add_virtual_fields(item)
    if item['edge_media_to_caption'] and item['edge_media_to_caption']["edges"] and item['edge_media_to_caption']["edges"].length > 0 
      item["title"] = item['edge_media_to_caption']["edges"][0]["node"]["text"]
      item['tags'] = tags_from_string(item['title'])
    end
    if not item['thumbnail_src'] and item['display_resources']
      item['thumbnail_src'] = item['display_resources'][0]["src"]
    end
    if item['edge_media_preview_like']
      item['likes_count'] = item['edge_media_preview_like']['count']
    end
    if item['edge_media_to_comment']
      item['comments_count'] = item['edge_media_to_comment']['count']
    end
    if item["owner"] && item["owner"]["id"]
      item["owner_id"] = item["owner"]["id"]
    end
    item
  end

  def self.getDataBlobFromPage(page)
    scripts = page.search("script")
    found = ""
    scripts.each do |script_tag|
      tag_text = script_tag.text
      if tag_text.include? "_sharedData" and tag_text.include? "locale"
        found = tag_text[ tag_text.index("{"), (tag_text.rindex("}") - tag_text.index("{") + 1)  ]
      end
    end
    found
  end

  def self.get_ig_gis(params, rhx_gis)
    vals = rhx_gis + ":" + params.to_json
    Digest::MD5.hexdigest vals
  end

  #
  # code to rewrite every time tom catches jerry
  # https://stackoverflow.com/questions/49265339/instagram-a-1-url-doesnt-allow-max-id
  #

  def self._march_2018_get_user_by_name(name)
    url = "#{BASE_URL}/#{ name }/?__a=1"
    params = ""
    JSON.parse( open( "#{url}#{params}", 'User-Agent' => USER_AGENT ).read )
  end

  def self._jun_2018_get_user_by_name(name)
    url = "#{BASE_URL}/#{ name }/"
    params = ""
    doc = Nokogiri::HTML(open( "#{url}#{params}", 'User-Agent' => USER_AGENT ) )

    JSON.parse ( self.getDataBlobFromPage(doc) )
  end

  def self._march_2018_get_user_by_id(id, count=DEFAULT_COUNT, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=472f257a40c653c64c666ce877d59d2b&variables={"id":"93024","first":12,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=472f257a40c653c64c666ce877d59d2b&variables="
    params = {'id'=> id, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}", 'User-Agent' => USER_AGENT ).read )
  end

  def self._march_2018_get_tag_media(tag, count=DEFAULT_COUNT, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=298b92c8d7cad703f7565aa892ede943&variables={"tag_name":"iphone","first":12,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=298b92c8d7cad703f7565aa892ede943&variables="
    params = {'tag_name'=> tag, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}", 'User-Agent' => USER_AGENT ).read )
  end

  def self._march_2018_get_media_comments(shortcode, count=DEFAULT_COUNT, end_cursor=nil)
    #https://www.instagram.com/graphql/query/?query_hash=33ba35852cb50da46f5b5e889df7d159&variables={"shortcode":"Bf-I2P6grhd","first":20,"after":"XXXXXXXX"}
    url = "#{BASE_URL}/graphql/query/?query_hash=33ba35852cb50da46f5b5e889df7d159&variables="
    params = {'shortcode'=> shortcode, 'first' => count, 'after'=> end_cursor }
    JSON.parse( open( "#{url}#{params.to_json}", 'User-Agent' => USER_AGENT ).read )
  end

  def self._jan_2019_get_media_likes(shortcode)
    url = "#{BASE_URL}/graphql/query/?query_hash=e0f59e4a1c8d78d0161873bc2ee7ec44&variables="
    #https://www.instagram.com/graphql/query/?query_hash=e0f59e4a1c8d78d0161873bc2ee7ec44&variables=%7B%22shortcode%22%3A%22BrMiUYWh-iU%22%2C%22include_reel%22%3Atrue%2C%22first%22%3A24%7D
    params = {'shortcode'=> shortcode, 'include_reel' => true, 'first'=> 24 }
    # Open the initial page to grab the cookie from it
    p1 = open("https://www.instagram.com/p/#{shortcode}/", 'User-Agent' => USER_AGENT )
    cookie = p1.meta['set-cookie']
    doc = Nokogiri::HTML(p1)
    json = JSON.parse ( self.getDataBlobFromPage(doc) )
    rhx_gis = json["rhx_gis"]
    JSON.parse( open( "#{url}#{params.to_json}", 'x-instagram-gis'=> self.get_ig_gis(params, rhx_gis), 'Cookie' => cookie, "x-requested-with" => "XMLHttpRequest", 'User-Agent' => USER_AGENT ).read )
  end

end
