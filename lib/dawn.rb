require 'dawn/version'
require 'dawn/container'
require 'dawn/namespace/request'

module Dawn
  class Error < StandardError
  end

  class NamespaceNotRegisteredError < Error
  end

  class NamespaceAlreadyRegisteredError < Error
  end

  class InstanceNotRegisteredError < Error
  end

  class InstanceAlreadyRegisteredError < Error
  end
end
