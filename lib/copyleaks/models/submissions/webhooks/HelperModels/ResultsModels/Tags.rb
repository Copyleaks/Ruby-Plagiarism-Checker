module Copyleaks
  class Tags
    attr_reader :code, :title, :description

     # @param [String] code Identifies the tag type.
     def initialize(code: nil, title: nil, description: nil)
      @code = code
      @title = title
      @description = description
    end
  end
end
