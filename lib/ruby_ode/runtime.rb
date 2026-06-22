module RubyODE
  class ValueOutput
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end

  class ErrorOutput
    attr_reader :error

    def initialize(error)
      @error = error
    end
  end

  class EmptyOutput
  end

  module Outputs
    def self.value(value) = ValueOutput.new(value)
    def self.error(error) = ErrorOutput.new(error)
    def self.empty = EmptyOutput.new
  end

  class GuardRejectedError < StandardError; end
  class ConnectionError < StandardError; end
  class UnexpectedResponseError < StandardError; end

  class HttpError < StandardError
    attr_reader :status_code

    def initialize(status_code, message)
      @status_code = status_code
      super("http #{status_code}: #{message}")
    end
  end

  class UseCase
    def process(param)
      guard(param)
      on_result(execute(param))
    rescue StandardError => error
      on_error(error)
    end

    def guard(_param); end

    def execute(_param)
      raise NotImplementedError
    end

    def on_result(result)
      Outputs.value(result)
    end

    def on_error(error)
      Outputs.error(error)
    end
  end

  class ChainUseCase
    def initialize(first:, second:)
      @first = first
      @second = second
    end

    def process(param)
      first_output = @first.process(param)
      return Outputs.error(first_output.error) if first_output.is_a?(ErrorOutput)
      return Outputs.empty if first_output.is_a?(EmptyOutput)

      Outputs.value(@second.call(first_output.value, param))
    rescue StandardError => error
      Outputs.error(error)
    end
  end

  class SequenceUseCase
    def initialize(step:)
      @step = step
    end

    def process(values)
      return Outputs.empty if values.empty?

      Outputs.value(values.map { |value| @step.call(value) })
    rescue StandardError => error
      Outputs.error(error)
    end
  end

  class UseCaseDispatcher
    def dispatch(param, use_case)
      output = use_case.process(param)
      yield output if block_given?
      output
    end
  end
end
