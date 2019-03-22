module Slather
  class SlatherError < SlatherError

    attr_reader :action

    def initialize(message, action)
      # Call the parent's constructor to set the message
      super(message)

      # Store the action in an instance variable
      @action = action
    end

  end

  class SlatherArgumentError < ArgumentError

    attr_reader :action

    def initialize(message, action)
      # Call the parent's constructor to set the message
      super(message)

      # Store the action in an instance variable
      @action = action
    end

  end
end
