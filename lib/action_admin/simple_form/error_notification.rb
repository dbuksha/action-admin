module ActionAdmin
  module SimpleForm
    class ErrorNotification < ::SimpleForm::ErrorNotification
      def html_options
        @options[:class] = "callout alert #{@options[:class]}".strip
        @options
      end
    end
  end
end
