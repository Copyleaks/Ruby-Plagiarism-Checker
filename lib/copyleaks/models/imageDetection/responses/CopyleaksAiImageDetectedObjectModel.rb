#
#  The MIT License(MIT)
#
#  Copyright(c) 2016 Copyleaks LTD (https://copyleaks.com)
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
# =

module Copyleaks
  # One object located in the image, with its run-length encoded segmentation mask.
  class CopyleaksAiImageDetectedObjectModel
    # The object name from the request, for example "face".
    attr_accessor :object

    # The RLE mask (CopyleaksAiImageDetectionResultModel with starts and lengths), in the
    # coordinate space of imageInfo.shape.
    attr_accessor :mask

    def initialize(object: nil, mask: nil)
      @object = object
      @mask = mask
    end

    def self.from_json(json_hash)
      return nil unless json_hash.is_a?(Hash)

      new(
        object: json_hash['object'],
        mask: CopyleaksAiImageDetectionResultModel.from_json(json_hash['mask'])
      )
    end

    def to_json(*args)
      {
        'object' => @object,
        'mask' => @mask ? JSON.parse(@mask.to_json) : nil
      }.to_json(*args)
    end
  end
end
