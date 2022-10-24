# frozen_string_literal: true

require "test_helper"

class InlineErbTest < ViewComponent::TestCase
  class InlineErbComponent < ViewComponent::Base
    include ViewComponent::InlineTemplate

    attr_reader :name

    template! <<~ERB
      <h1>Hello, <%= name %>!</h1>
    ERB

    def initialize(name)
      @name = name
    end
  end

  class InlineRaiseErbComponent < ViewComponent::Base
    include ViewComponent::InlineTemplate

    attr_reader :name

    template! <<~ERB
      <h1>Hello, <%= raise ArgumentError, "oh no" %>!</h1>
    ERB

    def initialize(name)
      @name = name
    end
  end

  class InlineSlimComponent < ViewComponent::Base
    include ViewComponent::InlineTemplate

    attr_reader :name

    template_language! :slim
    template! <<~SLIM
      h1
        | Hello,
        = " " + name
        | !
    SLIM

    def initialize(name)
      @name = name
    end
  end

  class InheritedInlineSlimComponent < InlineSlimComponent
  end

  test "renders inline templates" do
    render_inline(InlineErbComponent.new("Fox Mulder"))

    assert_selector("h1", text: "Hello, Fox Mulder!")
  end

  test "caller locations work" do
    error = assert_raises ArgumentError do
      render_inline(InlineRaiseErbComponent.new("Fox Mulder"))
    end

    assert_match %r{test/sandbox/test/inline_template_test.rb:26}, error.backtrace[0]
  end

  test "renders inline slim templates" do
    render_inline(InlineSlimComponent.new("Fox Mulder"))

    assert_selector("h1", text: "Hello, Fox Mulder!")
  end

  test "inherits template_language" do
    assert_equal "slim", InheritedInlineSlimComponent.inline_template_language
  end
end
