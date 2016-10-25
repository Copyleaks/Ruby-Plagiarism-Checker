## Copyleaks Ruby SDK

Copyleaks SDK is a simple framework that allows you to scan textual content for plagiarism and trace content distribution online, using the [Copyleaks plagiarism checker cloud](https://copyleaks.com/).

Detect plagiarism using Copyleaks SDK in:
- Online content and webpages
- Local and cloud files ([see supported files](https://api.copyleaks.com/GeneralDocumentation/TechnicalSpecifications#supportedfiletypes"))
- Free text
- OCR (Optical Character Recognition) - scanning pictures with textual content ([see supported files](https://api.copyleaks.com/GeneralDocumentation/TechnicalSpecifications#supportedfiletypes))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'copyleaks_api'
```

And then execute:
```
$ bundle
```

Or use the command:
```
$ gem install copyleaks_api
```

## Requirements

This gem is tested on `ruby-1.9.3-p551`, `jruby-9.0.5.0` and `ruby-2.3.0`.

## Usage

First, login with your api-key and email:
```ruby
cloud = CopyleaksApi::CopyleaksCloud.new(my_email, my_api_key)
```

Then you can start to scan content for plagiarism. For example, scan picture with textual content for plagirism:
```ruby
process = cloud.create_by_ocr(path_to_image, language: Copyleaks::Language.english)
```

Methods `create_by_url`, `create_by_file`, `create_by_text`, `status`, `result` and `list` returns `CopyleaksApi::CopyleaksProcess` objects. When you want to check your process status you reload and check:
```ruby
process.reload
process.finished?
```

You will get back the status `Finished` if the process finished running.
### Configuration

You can include all of the necessary configurations in one place:
```ruby
CopyleaksApi::Config do |config|
    config.sanbox_mode = true
    config.allow_partial_scan = true
    config.http_callback = 'http://yoursite.here'
    config.email_callback = 'your@email.com'
    config.custom_fields = { some_field: 'and its value' }
end
```

Or by calling specific methods:
```ruby
CopyleaksApi::Config.sandbox_mode = true
```

Also some parameters can be specified in method arguments. 

If you want to disable all callbacks you can add the header `no_callbak: true ` to any of the 'create' methods (`no_http_callback` or `no_email_callback` to disable only one). `no_custom_fields` works the same way.

### Errors

| Class | Description |
|-------|------------|
BasicError | Superclass error for all gem errors
BadCustomFieldError | Given custom fields didn't pass validation (key/value/overall size is too large)
BadFileError | Given file is too large
BadEmailError | Given call back email is invalid
BadUrlError | Given callback url is invalid
UnknownLanguageError | Given OCR language is invalid
BadResponseError | Response from API is not 200 code
ManagedError | Response contains Copyleaks managed error code (see list [here](https://api.copyleaks.com/Documentation/ErrorList))

##Examples

For a fast testing, launch the script `examples/main.rb` and just change the email and api_key values to your own.

## Read more

- [Copyleaks API guide](https://api.copyleaks.com/Guides/HowToUse)
