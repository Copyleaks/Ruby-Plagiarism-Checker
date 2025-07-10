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

require_relative 'exceptions/index.rb'
require_relative 'exports/index.rb'
require_relative 'submissions/index.rb'
require_relative 'auth_token.rb'

require_relative 'id_object.rb'
require_relative 'delete_request_model.rb'
require_relative 'start_request_model.rb'

require_relative 'textModeration/requests/CopyleaksTextModerationRequestModel.rb'
require_relative 'textModeration/responses/submodules/ModerationsModel.rb'
require_relative 'textModeration/responses/submodules/Text.rb'
require_relative 'textModeration/responses/submodules/TextModerationChars.rb'
require_relative 'textModeration/responses/submodules/TextModerationScannedDocument.rb'
require_relative 'textModeration/responses/submodules/TextModerationsLegend.rb'
require_relative 'textModeration/responses/CopyleaksTextModerationResponseModel.rb'

module Copyleaks
end
