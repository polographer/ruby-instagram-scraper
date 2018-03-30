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
      RubyInstagramScraper.normalized_user_media_by_uid( "366457904", 3 ).media.size.must_equal 3
    end
  end

  #I know its a generally a bad practice to test multiple things on one test
  #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  
  describe "when request normalized user media nodes by uid with count" do
    it "should have title virtual fields" do
      result = RubyInstagramScraper.normalized_user_media_by_uid( "366457904", 1)
      result.media[0]["title"].wont_be_nil
      result.media[0]["likes_count"].wont_be_nil
      result.media[0]["comments_count"].wont_be_nil
      result.media[0]["thumbnail_src"].wont_be_nil
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
    end
  end

  describe "when request normalized user media nodes by uid with count" do
    it "response must be an value object RubyInstagramResponse" do
      RubyInstagramScraper.normalized_media_by_code( "BVNMDtOAu9l", 3).must_be_instance_of RubyInstagramResponse
    end
  end
  #I know its a generally a bad practice to test multiple things on one test
  #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  

  describe "when request normalized  media by code with count" do
    it "should have likes count virtual field" do
      result = RubyInstagramScraper.normalized_media_by_code( "BVNMDtOAu9l", 3)
      result.media["likes_count"].wont_be_nil
      result.media["comments_count"].wont_be_nil
    end
  end



end
