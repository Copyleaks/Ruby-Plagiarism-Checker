## Copyleaks Ruby SDK

Copyleaks SDK is a simple framework that allows you to scan textual content for plagiarism and trace content distribution online, using the [Copyleaks plagiarism checker cloud](https://copyleaks.com/).

Detect plagiarism using Copyleaks SDK in:
- Online content and webpages
- Local and cloud files ([see supported files](https://api.copyleaks.com/GeneralDocumentation/TechnicalSpecifications#supportedfiletypes))
- Free text
- OCR (Optical Character Recognition) - scanning pictures with textual content ([see supported files](https://api.copyleaks.com/GeneralDocumentation/TechnicalSpecifications#supportedfiletypes))

## Installation

We recommend to install this SDK using the [RubyGems](https://rubygems.org/gems/plagiarism-checker) package.

Add this line to your application's Gemfile:

```ruby
gem 'plagiarism-checker'
```

And then execute:
```
$ bundle
```

Or use the command:
```
$ gem install plagiarism-checker
```

Or git clone this repository and install the required dependency:
```
$ git clone https://github.com/Copyleaks/Ruby-Plagiarism-Checker.git
$ gem install mimemagic
```

## Requirements

This gem is tested on `ruby-1.9.3-p551`, `jruby-9.0.5.0` and `ruby-2.3.0`.

## Examples

For a fast testing use the usage example files. Update you credentials and launch the script [`example_asynchronous.rb`](https://github.com/Copyleaks/Ruby-Plagiarism-Checker/blob/master/example_asynchronous.rb) for an example usage using callbacks. Try [`example_syncronized.rb`](https://github.com/Copyleaks/Ruby-Plagiarism-Checker/blob/master/example_synchronous.rb) to see an example usage of creating a process and recieving the results programmatically.

You can also watch the [Get Started YouTube video](https://www.youtube.com/watch?v=ShPltkKf9QA).

## Usage

First, import the Copyleaks API module:
```ruby
require 'copyleaks_api'
```
Register to Copyleaks and get an api-key at: https://copyleaks.com/account/register.

Your api-key is available at your dashboard on https://api.copyleaks.com/

Login to Copyleaks API with your api-key and email:
```ruby
cloud = CopyleaksApi::CopyleaksCloud.new(my_email, my_api_key, :businesses)
```
Notice that the 3rd argument is the product that you wish to use. The available products are:

[For Businesses](https://api.copyleaks.com/businessesdocumentation) - :businesses - Media Publishers, Consulting Firms, Law Firms, Scientific Journals, SMBs etc.

[For Education](https://api.copyleaks.com/academicdocumentation) - :education - Universities, Schools, LMS etc.

[For Websites](https://api.copyleaks.com/websitesdocumentation) - :websites - Website Owners, SEO Agencies, Bloggers, Online Magazines and Journals etc.

Then you can start to scan your content for plagiarism:
```ruby
process = cloud.create_by_file(file_path)
```

Methods `create_by_url`, `create_by_file`, `create_by_files`, `create_by_text` and `create_by_ocr` returns `CopyleaksApi::CopyleaksProcess` objects.

We highly recommend you to use the `http_callback` header in order to get a callback once the process is finished with its results:
```ruby
CopyleaksApi::Config.http_callback = 'http://yoursite.here/callback'
```
For more information about callbacks take a look at [`example_asynchronous.rb`](https://github.com/Copyleaks/Ruby-Plagiarism-Checker/blob/master/example_asynchronous.rb) file.

If you want to check the status of the process programatically use `process.update_status`:
```ruby
while process.processing?
    sleep(1)
    process.update_status
    puts "#"*(process.progress/2) + "-"*(50 - process.progress/2) + "#{process.progress}%"
end
```

And get the results programatically:
```ruby
results = process.get_results

puts "#{results.size} Results: "
results.each do |res|
  puts res.to_s
end
```

### Configuration

You can set a specific header:
```ruby
CopyleaksApi::Config.sandbox_mode = true
```

Or can include all of the necessary configurations in one place:
```ruby
CopyleaksApi::Config do |config|
    config.sanbox_mode = true
    config.allow_partial_scan = true
    config.http_callback = 'http://yoursite.here/callback'
    config.in_progress_result = 'http://yoursite.here/callback/results'
    config.email_callback = 'your@email.com'
    config.custom_fields = { some_field: 'and its value' }
    config.compare_only = true  # Only while using create-by-files
    config.import_to_database_only = true  # To only upload your file to our database, will not consume any credits.
#end
```

Also some parameters can be specified in method arguments. 

If you want to disable all callbacks you can add the header `no_callback: true ` to any of the 'create' methods (`no_http_callback` or `no_email_callback` to disable only one). `no_custom_fields` works the same way.

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

## Read more
- [API Homepage](https://api.copyleaks.com/)
- [API Documentation](https://api.copyleaks.com/documentation)
- [Copyleaks API guide](https://api.copyleaks.com/Guides/HowToUse)
- [Copyleaks Plagiarism Checker Homepage](https://copyleaks.com/)
