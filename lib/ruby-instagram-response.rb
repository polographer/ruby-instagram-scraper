class RubyInstagramResponse
    attr_reader :media, :page, :raw, :likes, :comments, :userdata, :deleted
    def initialize(options = {})
        @media  = options[:media]
        @page = options[:page]
        @raw = options[:raw]
        @likes = options[:likes]
        @comments = options[:comments]
        @userdata = options[:userdata]
        @deleted = options[:deleted].nil? ? false : true
    end
end