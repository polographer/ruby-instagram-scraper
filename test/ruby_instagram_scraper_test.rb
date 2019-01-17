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
      assert_raises Exception do
        RubyInstagramScraper.get_user_media_by_id( "366457904" ).must_be_instance_of Array
      end
    end
  end

  describe "when request tag media nodes" do
    it "must raise an exeption" do
      assert_raises Exception do
        RubyInstagramScraper.get_tag_media_nodes( "academgorodok" )
      end
    end
  end

  describe "when request a media" do
    it "must has equal code in field" do
      RubyInstagramScraper.get_media( "BVNMDtOAu9l" )["shortcode"].must_equal "BVNMDtOAu9l"
    end
  end

  describe "when request user media comments" do
    it "must be an array" do
      assert_raises Exception do
        RubyInstagramScraper.get_media_comments( "6zVfmqAMkD", 2 )
      end
    end
  end

  # describe "when request user media comments before specified comment_id value" do
  #   it "must be an array" do
  #     RubyInstagramScraper.get_media_comments( "6zVfmqAMkD", 2, "17851999804000050" ).must_be_instance_of Array
  #   end
  # end

  describe "when request user media nodes by id " do
    it "response must be an value object RubyInstagramResponse" do
      assert_raises Exception do
        RubyInstagramScraper.normalized_user_media_by_uid( "366457904" ).must_be_instance_of RubyInstagramResponse
      end
    end
  end

  describe "when request normalized user media nodes by uid with count" do
    it "response must be an value object RubyInstagramResponse" do
      RubyInstagramScraper.normalized_media_by_code("BVNMDtOAu9l").must_be_instance_of RubyInstagramResponse
    end
  end
  # #I know its a generally a bad practice to test multiple things on one test
  # #------------------ BUT --------------------- its an api call to instagram and we don't want to get banned  

  describe "when request normalized media by code" do
    it "should have these fields" do
      result = RubyInstagramScraper.normalized_media_by_code("BhG_n9jHS3F")
      result.media["likes_count"].wont_be_nil
      result.media["comments_count"].wont_be_nil
      result.media["owner_id"].must_equal "366457904"
      result.media["tags"].must_equal "latergram filmborn panf"
      result.media["is_ad"].must_equal false
      result.media["shortcode"].must_equal "BhG_n9jHS3F"
      result.media["location"]['id'].must_equal "213690172"
      result.media["location"]['name'].must_equal "Reston, Virginia"
      result.media["dimensions"]['height'].must_equal 1350
      result.media["dimensions"]['width'].must_equal 1080
    end
  end

  describe "when request normalized likes by code with count" do
    it "should have these fields" do
      result = RubyInstagramScraper.normalized_likes_by_shortcode("BsmAA8ZhjiE")
      result.media["shortcode"].must_equal "BsmAA8ZhjiE"
      assert result.likes.count > 10
      pp result.likes.count
    end
  end

  # # deleted media : BTkyVWdgSwl

  describe "when request normalized user by name" do
    it "should have the virtual fields and basic fields" do
      result = RubyInstagramScraper.normalized_user_media_by_name("polographer")
      
      result.must_be_instance_of RubyInstagramResponse

      result.media[0]["title"].wont_be_nil
      result.media[0]["likes_count"].wont_be_nil
      result.media[0]["comments_count"].wont_be_nil
      result.media[0]["thumbnail_src"].wont_be_nil 
      result.media[0]["owner_id"].must_equal "366457904"
      result.userdata["id"].must_equal "366457904"
      result.userdata["full_name"].wont_be_nil
      result.userdata["username"].wont_be_nil
      result.userdata["profile_pic_url"].wont_be_nil



    end
  end

end
