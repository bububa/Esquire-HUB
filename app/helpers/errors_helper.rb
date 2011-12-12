module ErrorsHelper

  # see: lib/action_view/helpers/active_model_helper.rb
  def error_messages_for(*params)
        options = params.extract_options!.symbolize_keys

        objects = Array.wrap(options.delete(:object) || params).map do |object|
          object = instance_variable_get("@#{object}") unless object.respond_to?(:to_model)
          object = convert_to_model(object)

          if object.class.respond_to?(:model_name)
            options[:object_name] ||= object.class.model_name.human.downcase
          end

          object
        end

        objects.compact!
        count = objects.inject(0) {|sum, object| sum + object.errors.count }

        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end
          options[:object_name] ||= params.first

          I18n.with_options :locale => options[:locale], :scope => [:errors, :template] do |locale|
            header_message = if options.include?(:header_message)
              options[:header_message]
            else
              locale.t :header, :count => count, :model => options[:object_name].to_s.gsub('_', ' ')
            end

            message = options.include?(:message) ? options[:message] : locale.t(:body)

            error_messages = objects.sum do |object|
              object.errors.on(:name)
              full_flat_messages(object).map do |msg|
                content_tag(:li, ERB::Util.html_escape(msg))
              end
            end.join.html_safe

            contents = ''
            contents << content_tag(options[:header_tag] || :h2, header_message) unless header_message.blank?
            contents << content_tag(:p, message) unless message.blank?
            contents << content_tag(:ul, error_messages)

            content_tag(:div, contents.html_safe, html)
          end
        else
          ''
        end
  end

  ####################
  #
  # added to make the errors display in a single line per field
  #
  ####################
  def full_flat_messages(object)
    full_messages = []

    object.errors.each_key do |attr|
      msg_part=msg=''
      object.errors[attr].each do |message|
        next unless message
        if attr == "base"
          full_messages << message
        else
          msg=object.class.human_attribute_name(attr)
          msg_part+= I18n.t('activerecord.errors.format.separator', :default => ' ') + (msg_part=="" ? '': ' & ' ) + message
        end
      end
      full_messages << "#{msg} #{msg_part}" if msg!=""
    end
    full_messages
  end

end