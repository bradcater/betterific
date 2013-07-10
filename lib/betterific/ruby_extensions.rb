class Object
  unless nil.respond_to?(:present?)
    def present?
      !self.nil?
    end
  end
end

# Adapted from
#   https://www.ruby-forum.com/topic/4411006
class String

  unless ''.respond_to?(:camelize)
    def camelize
      self.split("_").each {|s| s.capitalize! }.join("")
    end
  end

  unless ''.respond_to?(:underscore)
    def underscore
      self.scan(/[A-Z][a-z]*/).join("_").downcase
    end
  end

end
