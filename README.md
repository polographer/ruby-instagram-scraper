Lets be straight, if you reach this you know that the official api endpoint license is so restrictive that you cannot work with that, this gem don't try to "impersonate" an android client, but instead it consumes an unnoficial endpoint used for the web page, it will change (it has changed before) I will try to keep up with the changes as time permits.

It's based on the original work of Sergey Borodanov, https://github.com/sborod/ruby-instagram-scraper

### Installation

I haven't publish the gem, so right now is github only

```ruby
gem 'ruby-instagram-scraper-ng', github: 'polographer/ruby-instagram-scraper'
```

### Normalized Methods

There is a new set of methods that try to maintain a common response structure. They are called normalized methods, they return a object RubyInstagramResponse that contains the relevant information

```ruby
# Search by tag or username , returns an object containing , media , page and raw, you can also send the nnumber of records as well as end_cursor
RubyInstagramScraper.normalized_user_media_by_uid( "366457904")

# Get user media nodes returns an object containing , media , likes, comments and raw, you can also send the nnumber of records as well as end_cursor
RubyInstagramScraper.normalized_media_by_code( "BVNMDtOAu9l")

```

### Legacy Methods

After installation you can do following requests to Instagram:

```ruby
# Search by tag or username:
RubyInstagramScraper.search( "gopro" )

# Get user media nodes:
RubyInstagramScraper.get_user( "gopro" )

# Get user media by id
RubyInstagramScraper.get_user_media_by_id("366457904")

# Get media nodes by tag:
nodes = RubyInstagramScraper.get_tag_media_nodes( "gopro" )

# Get next portion of nodes of same tag by passing last node "id":
RubyInstagramScraper.get_tag_media_nodes( "gopro", nodes.last["id"] )

# Get media info:
RubyInstagramScraper.get_media( nodes.first["code"] )
RubyInstagramScraper.get_media( "BGGnlHDBV3N" )

```

