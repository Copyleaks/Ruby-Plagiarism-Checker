## Copyleaks Ruby SDK

Copyleaks SDK is a simple framework that allows you to scan textual content for plagiarism and trace content distribution online, using the [Copyleaks plagiarism checker cloud](https://copyleaks.com/).

Detect plagiarism using Copyleaks SDK in:
- Online content and webpages
- Local and cloud files ([see supported files](https://api.copyleaks.com/Documentation/TechnicalSpecifications/#non-textual-formats")
- Free text
- OCR (Optical Character Recognition) - scanning pictures with textual content ([see supported files](https://api.copyleaks.com/Documentation/TechnicalSpecifications/#ocr-formats))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'copyleaks_api'
```

And then execute:
```
$ bundle
```

Or jsut using command:
```
$ gem install copyleaks_api
```

## Requirements

This gem tested on `ruby-1.9.3-p551`, `jruby-9.0.5.0` and `ruby-2.3.0`.

## Usage

Firstly you need to crate connection with your api-key and email:
```ruby
cloud = CopyleaksApi::CopyleaksCloud.new(my_email, my_api_key)
```

After this you can scan you image:
```ruby
process = cloud.create_by_ocr(path_to_image, language: Copyleaks::Language.english)
```

Methods `create_by_url`, `create_by_file`, `create_by_text`, `status`, `result` and `list` returns `CopyleaksApi::CopyleaksProcess` objects. When you want to check changes of it's status you can just reload it:
```ruby
process.reload
process.finished?
```

This firstly get new data from Copyleaks and return true if this process now has status `Finished`.
### Configuration

You can specify all necessary configuration in one place just using:
```ruby
CopyleaksApi::Config do |config|
    config.sanbox_mode = true
    config.allow_partial_scan = true
    config.http_callback = 'http://yoursite.here'
    config.email_callback = 'your@email.com'
    config.custom_fields = { some_field: 'and its value' }
end
```

Or just call methods:
```ruby
CopyleaksApi::Config.sandbox_mode = true
```

Also some parameters can be specified in method arguments. 

If you want to disable all callbacks you can pass `no_callbak: true ` optoin to any create method (`no_http_callback` or `no_email_callback` to disable only one). `no_custom_fields` works the same way.

### Errors

| Class | Description |
|-------|------------|
BasicError | Superclass error for all gem errors
BadCustomFieldError | Given custom fields didnt pass validation (key/value/overall size is to large)
BadFileError | Given file is too large
BadEmailError | Given email for callback is invalid
BadUrlError | Given callback url is invalid
UnknownLanguageError | Given language for OCR is invalid
BadResponseError | Reponse fro API has not 200 code
ManagedError | Reponse contains manages Copyleaks error code (all list are given [here](https://api.copyleaks.com/Documentation/ErrorList))

##Examples

For fast test you could launch `examples/main.rb` script. It has a lot of comments so there is no need in additional descriptions. You just need to change email and api_key values.

## Read more

- [Copyleaks API guide](https://api.copyleaks.com/Guides/HowToUse)
- [Copyleaks API documentation](https://api.copyleaks.com/Documentation)
