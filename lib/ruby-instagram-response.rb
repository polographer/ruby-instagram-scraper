class RubyInstagramResponse
    attr_reader :media, :page, :raw, :likes, :comments
    def initialize(options = {})
        @media  = options[:media]
        @page = options[:page]
        @raw = options[:raw]
        @likes = options[:likes]
        @comments = options[:comments]
    end
end