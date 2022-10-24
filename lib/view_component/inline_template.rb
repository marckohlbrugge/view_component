# frozen_string_literal: true

module ViewComponent # :nodoc:
  module InlineTemplate
    extend ActiveSupport::Concern
    Template = Struct.new(:source, :language, :path, :lineno)

    class_methods do
      def template!(template)
        caller = caller_locations(1..1)
        @__vc_inline_template = Template.new(
          template,
          inline_template_language,
          caller.absolute_path || caller.path,
          caller.lineno
        )
      end

      def template_language!(language)
        @__vc_inline_template_language = language.to_s
      end

      def inline_template
        @__vc_inline_template
      end

      def inline_template_language
        return @__vc_inline_template_language if defined?(@__vc_inline_template_language)
        "erb"
      end

      def inherited(subclass)
        super
        subclass.template_language!(self.inline_template_language)
      end
    end
  end
end
