module CopyleaksApi
  module Language
    ALLOWED = ['Afrikaans',
               'Albanian',
               'Basque',
               'Brazilian',
               'Bulgarian',
               'Byelorussian',
               'Catalan',
               'Chinese_Simplified',
               'Chinese_Traditional',
               'Croatian',
               'Czech',
               'Danish',
               'Dutch',
               'English',
               'Esperanto',
               'Estonian',
               'Finnish',
               'French',
               'Galician',
               'German',
               'Greek',
               'Hungarian',
               'Icelandic',
               'Indonesian',
               'Italian',
               'Japanese',
               'Korean',
               'Latin',
               'Latvian',
               'Lithuanian',
               'Macedonian',
               'Malay',
               'Moldavian',
               'Norwegian',
               'Polish',
               'Portuguese',
               'Romanian',
               'Russian',
               'Serbian',
               'Slovak',
               'Slovenian',
               'Spanish',
               'Swedish',
               'Tagalog',
               'Turkish',
               'Ukrainian'].freeze

    ALLOWED.each_with_index do |lang, index|
      method = lang.downcase

      # returns appropriate language name based on method name
      define_method(method) do
        ALLOWED[index]
      end

      module_function method
    end
  end
end
