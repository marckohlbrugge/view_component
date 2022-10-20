# frozen_string_literal: true

module ViewComponent # :nodoc:
  module InlineTemplate
    extend ActiveSupport::Concern

    class_methods do
      def template!(template)
        @__vc_inline_template = template
      end

      def template_language!(language)
        @__vc_inline_template_language = language
      end

      def inline_template
        @__vc_inline_template
      end

      def inline_template_language
        return @__vc_inline_template_language if defined?(@__vc_inline_template_language)
        "erb"
      end
    end
  end
end
