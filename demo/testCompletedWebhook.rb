require_relative '../lib/index'
require 'json'
require 'date'
require_relative 'base64logo.rb'
require_relative '../lib/copyleaks//models/submissions/webhooks/CompletedWebhook'  
# this is an example how to read payload from json file "data.json" ande desrialize it into the correct model.
# you would recive the payload at webhook and for desrializng it into the model you would use the map_data_to_class(payload,"webhook class")
# this example is for the completed webhook. (Same code wroks for all other webhook responses)

def map_data_to_class(data, klass)
  return nil if data.nil?
  return data unless data.is_a?(Hash) || data.is_a?(Array)

  if data.is_a?(Array)
    return data.map { |item| map_data_to_class(item, klass) }
  end

  instance = klass.allocate

  data.each do |key, value|
    attr = key.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym
    if instance.respond_to?("#{attr}=")
      # Determine if value is nested object or array and map accordingly
      current_val = instance.instance_variable_get("@#{attr}")

      if value.is_a?(Hash) && !current_val.nil? && ![String, Integer, Float, TrueClass, FalseClass].include?(current_val.class)
        nested_obj = map_data_to_class(value, current_val.class)
        instance.instance_variable_set("@#{attr}", nested_obj)
      elsif value.is_a?(Array) && !current_val.nil? && current_val.is_a?(Array) && !current_val.empty?
        element_class = current_val.first.class
        nested_array = value.map { |item| map_data_to_class(item, element_class) }
        instance.instance_variable_set("@#{attr}", nested_array)
      else
        instance.send("#{attr}=", value)
      end
    else
      # Fallback: set instance variable directly if no setter
      instance.instance_variable_set("@#{attr}", value)
    end
  end

  instance
end

def from_json(json_str, klass)
  data = JSON.parse(json_str)
  map_data_to_class(data, klass)
end

def from_json_file(filepath, klass)
  raise "File not found or not readable: #{filepath}" unless File.readable?(filepath)

  json_str = File.read(filepath)
  from_json(json_str, klass)
end

completed_webhook = from_json_file(File.join(__dir__, 'data.json'), Copyleaks::CompletedWebhook)

puts "Deserialized CompletedWebhook object:"
puts JSON.pretty_generate(completed_webhook.as_json)
