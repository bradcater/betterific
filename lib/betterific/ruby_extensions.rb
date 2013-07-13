class Object
  unless nil.respond_to?(:present?)
    # Return true if self is not nil, false otherwise.
    #
    # This is defined only if it is not yet defined.
    #
    def present?
      !self.nil?
    end
  end
end

class String

  unless ''.respond_to?(:blank?)
    # Return true if self has length 0 or is only whitespace, false otherwise.
    #
    # This is defined only if it is not yet defined.
    #
    def blank?
      self.strip.size == 0
    end
  end

  #Adapted from
  #https://www.ruby-forum.com/topic/4411006
  unless ''.respond_to?(:camelize)
    # Return a camel-case version of self, in contrast to underscore.
    #
    # This is defined only if it is not yet defined.
    #
    def camelize
      self.split('_').each(&:capitalize!).join
    end
  end
  unless ''.respond_to?(:underscore)
    # Return an underscore version of self, in contrast to camel-case.
    #
    # This is defined only if it is not yet defined.
    #
    def underscore
      self.scan(/[A-Z][a-z]*/).join('_').downcase
    end
  end

end
