require "minitest/autorun"
require "ruby-instagram-scraper"

describe RubyInstagramScraper do

  describe "when search" do
    it "users must be an array" do
      RubyInstagramScraper.search( "polographer" )["users"].must_be_instance_of Array
    end
  end

  describe "when request user media nodes by name" do
    it "must raise an exeption" do
      assert_raises Exception do
        RubyInstagramScraper.get_user_media_nodes( "polographer" )
      end
    end
  end
  describe "when request user media nodes by id" do
    it "users must be an array" do
      RubyInstagramScraper.get_user_media_by_id( "366457904" ).must_be_instance_of Array
    end
  end

  describe "when request tag media nodes" do
    it "must be an array" do
      RubyInstagramScraper.get_tag_media_nodes( "academgorodok" ).must_be_instance_of Hash
    end
  end

  describe "when request a media" do
    it "must has equal code in field" do
      RubyInstagramScraper.get_media( "BVNMDtOAu9l" )["shortcode"].must_equal "BVNMDtOAu9l"
    end
  end

  describe "when request user media comments" do
    it "must be an array" do
      RubyInstagramScraper.get_media_comments( "6zVfmqAMkD", 2 ).must_be_instance_of Array
    end
  end

  describe "when request user media comments before specified comment_id value" do
    it "must be an array" do
      RubyInstagramScraper.get_media_comments( "6zVfmqAMkD", 2, "17851999804000050" ).must_be_instance_of Array
    end
  end

  describe "when request user media nodes by id " do
    it "response must be an value object RubyInstagramResponse" do
      RubyInstagramScraper.normalized_user_media_by_uid( "366457904" ).must_be_instance_of RubyInstagramResponse
    end
  end

  describe "when request user media nodes by id with count" do
    it "should match counts" do
      RubyInstagramScraper.normalized_user_media_by_uid( "366457904", 15 ).media.size.must_equal 15
    end
  end

  # deleted user 5768

  #I know its a generally a bad practice to test multiple things on one test
  #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  
  describe "when request normalized user media nodes by uid with count" do
    it "should have virtual fields" do
      result = RubyInstagramScraper.normalized_user_media_by_uid( "366457904", 1)
      result.media[0]["title"].wont_be_nil
      result.media[0]["likes_count"].wont_be_nil
      result.media[0]["comments_count"].wont_be_nil
      result.media[0]["thumbnail_src"].wont_be_nil 
      result.media[0]["owner_id"].must_equal "366457904"
    end
  end

    # has basic fields
  # this is important, if any of this fails we need to rewrite
  #I know its a generally a bad practice to test multiple things on one test
  #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  
  describe "when user request normalized media nodes by id with count" do
    it "should have the basic requiered fields" do
      result = RubyInstagramScraper.normalized_user_media_by_uid( "366457904", 3)
      result.media[0]["id"].wont_be_nil
      result.media[0]["taken_at_timestamp"].wont_be_nil
      result.media[0]["display_url"].wont_be_nil
      result.media[0]["shortcode"].wont_be_nil
      result.media[0]['edge_media_to_comment']['count'].wont_be_nil  
      result.media[0]['edge_media_to_caption']["edges"].wont_be_nil
    end
  end

  describe "when request normalized user media nodes by uid with count" do
    it "response must be an value object RubyInstagramResponse" do
      RubyInstagramScraper.normalized_media_by_code("BVNMDtOAu9l").must_be_instance_of RubyInstagramResponse
    end
  end
  #I know its a generally a bad practice to test multiple things on one test
  #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  

  describe "when request normalized  media by code with count" do
    it "should have virtual fields" do
      result = RubyInstagramScraper.normalized_media_by_code("BhG_n9jHS3F")
      result.media["likes_count"].wont_be_nil
      result.media["comments_count"].wont_be_nil
    end
  end

  describe "when request normalized  media by code with count" do
    it "should have required fields" do
      result = RubyInstagramScraper.normalized_media_by_code("BhG_n9jHS3F")
      result.media["is_ad"].must_equal false
      result.media["shortcode"].must_equal "BhG_n9jHS3F"
      result.media["location"]['id'].must_equal "213690172"
      result.media["location"]['name'].must_equal "Reston, Virginia"
      result.media["dimensions"]['height'].must_equal 1350
      result.media["dimensions"]['width'].must_equal 1080
    end
  end

  describe "when request normalized user by name" do
    it "should be an instance of ruby instagram response" do
      result = RubyInstagramScraper.normalized_user_media_by_name("polographer").must_be_instance_of RubyInstagramResponse
    end
  end

  describe "when request normalized user by name" do
    it "should have the virtual fields" do
      result = RubyInstagramScraper.normalized_user_media_by_name("polographer")
      result.media[0]["title"].wont_be_nil
      result.media[0]["likes_count"].wont_be_nil
      result.media[0]["comments_count"].wont_be_nil
      result.media[0]["thumbnail_src"].wont_be_nil 
      result.media[0]["owner_id"].must_equal "366457904"
    end
  end

  describe "when request normalized user by name" do
    it "should have the basic requiered fields" do
      result = RubyInstagramScraper.normalized_user_media_by_name("polographer")
      result.userdata["id"].must_equal "366457904"
      result.userdata["full_name"].wont_be_nil
      result.userdata["username"].wont_be_nil
      result.userdata["profile_pic_url"].wont_be_nil
    end
  end
end
