module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(attribute, type, *parameters)
      validations << { type: type, attribute: "@#{attribute}".to_sym, parameters: parameters }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        send(validation[:type], instance_variable_get(validation[:attribute]), validation[:parameters])
      end
    end

    def presence(attribute, _parameters)
      raise "'Presence' validation failed: value can't be nil. " if attribute.nil?
      raise "'Presence' validation failed: value shouldn't be empty." if attribute.empty?
    end

    def non_negativity(attribute, _parameters)
      raise "'Non_negativity' validation failed: value can't be nil" if attribute.nil?
      raise "'Non_negativity' validation failed: value must be greater than or equal to 0" if attribute.negative?
    end

    def format(attribute, regexp)
      raise "'Format' validation failed: value has invalid format" if attribute !~ regexp[0]
    end

    def type(attribute, attr_type)
      raise "'Type' validation failed: value type is not the same as expected. Must be 'String'" if attribute.class != attr_type[0]
    end
    
    def word_match(attribute, regexp)
      raise "'Word match' validation failed: word isn't of the expected value" if attribute !~ regexp[0]
    end

    def word_length(attribute, word_length)
      raise "Incorrect name length. Must be exactly #{word_length[0]} characters long." if attribute.length != word_length[0]
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end