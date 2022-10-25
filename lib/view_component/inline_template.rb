# frozen_string_literal: true

module ViewComponent # :nodoc:
  module InlineTemplate
    extend ActiveSupport::Concern
    Template = Struct.new(:source, :language, :path, :lineno)

    class_methods do
      def template!(template)
        if defined?(@__vc_inline_template_defined) && @__vc_inline_template_defined
          raise ViewComponent::ComponentError, "template! can only be called once per-component"
        end

        caller = caller_locations(1..1)[0]
        @__vc_inline_template = Template.new(
          template,
          inline_template_language,
          caller.absolute_path || caller.path,
          caller.lineno
        )

        # Set template as being set for this instance, this should not be
        # inherited so subclasses can still override templates.
        @__vc_inline_template_defined = true
      end

      def template_language!(language)
        if defined?(@__vc_inline_template_language_defined) && @__vc_inline_template_language_defined
          raise ViewComponent::ComponentError, "template_language! can only be called once per-component"
        end

        @__vc_inline_template_language = language.to_s

        # Set template as being set for this instance, this should not be
        # inherited so subclasses can still override templates.
        @__vc_inline_template_language_defined = true
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
        subclass.instance_variable_set(:@__vc_inline_template_language, inline_template_language)
      end
    end
  end
end
