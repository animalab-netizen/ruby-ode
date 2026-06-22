require "minitest/autorun"
require_relative "../lib/ruby_ode"

class RubyODERuntimeTest < Minitest::Test
  class DirectUseCase < RubyODE::UseCase
    def execute(param)
      "spotlight:#{param}"
    end
  end

  class GuardedUseCase < RubyODE::UseCase
    def guard(param)
      raise RubyODE::GuardRejectedError, "comparison requires distinct entries" if param[0] == param[1]
    end

    def execute(param)
      "#{param[0]} vs #{param[1]}"
    end
  end

  def test_direct_use_case
    output = DirectUseCase.new.process("pikachu")
    assert_instance_of RubyODE::ValueOutput, output
    assert_equal "spotlight:pikachu", output.value
  end

  def test_chain_use_case
    first = DirectUseCase.new
    chain = RubyODE::ChainUseCase.new(
      first: first,
      second: ->(result, _param) { "#{result} vs ivysaur" }
    )

    output = chain.process("bulbasaur")
    assert_instance_of RubyODE::ValueOutput, output
    assert_equal "spotlight:bulbasaur vs ivysaur", output.value
  end

  def test_sequence_use_case
    sequence = RubyODE::SequenceUseCase.new(step: ->(item) { item })
    output = sequence.process(%w[bulbasaur charmander squirtle])

    assert_instance_of RubyODE::ValueOutput, output
    assert_equal %w[bulbasaur charmander squirtle], output.value
  end

  def test_guard_use_case
    output = GuardedUseCase.new.process(%w[pikachu pikachu])
    assert_instance_of RubyODE::ErrorOutput, output
    assert_instance_of RubyODE::GuardRejectedError, output.error
  end
end
