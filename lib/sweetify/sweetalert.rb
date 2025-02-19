module Sweetify
  module SweetAlert
    # Display an alert with a text and an optional title
    # Default without an specific type
    #
    # @param [String] text Body of the alert (gets automatically the title if no title is specified)
    # @param [String] title Title of the alert
    # @param [Hash] opts Optional Parameters
    def sweetalert(text, title = '', opts = {})
      opts = {
        showConfirmButton: false,
        timer:             2000,
        allowOutsideClick: true,
        confirmButtonText: 'OK'
      }.merge(opts)

      opts[:text]  = text
      opts[:title] = title

      if opts[:button]
        opts[:showConfirmButton] = true
        opts[:confirmButtonText] = opts[:button] if opts[:button].is_a?(String)

        opts.delete(:button)
      end

      if opts[:persistent]
        opts[:showConfirmButton] = true
        opts[:allowOutsideClick] = false
        opts[:timer]             = nil
        opts[:confirmButtonText] = opts[:persistent] if opts[:persistent].is_a?(String)

        opts.delete(:persistent)
      end

      # sweetalert changes
      if Sweetify.sweetalert_library == 'sweetalert'
        opts[:icon] = opts.delete(:type)
        opts[:closeOnClickOutside] = opts.delete(:allowOutsideClick)

        if opts.delete(:showConfirmButton)
          opts[:button] = opts[:confirmButtonText]
        else
          opts[:button] = false
        end
      end

      flash_config(opts)
    end

    # Information Alert
    #
    # @param [String] text Body of the alert (gets automatically the title if no title is specified)
    # @param [String] title Title of the alert
    # @param [Hash] opts Optional Parameters
    def sweetalert_info(text, title = '', opts = {})
      opts[:type] = :info
      sweetalert(text, title, opts)
    end

    # Success Alert
    #
    # @param [String] text Body of the alert (gets automatically the title if no title is specified)
    # @param [String] title Title of the alert
    # @param [Hash] opts Optional Parameters
    def sweetalert_success(text, title = '', opts = {})
      opts[:type] = :success
      sweetalert(text, title, opts)
    end

    # Error Alert
    #
    # @param [String] text Body of the alert (gets automatically the title if no title is specified)
    # @param [String] title Title of the alert
    # @param [Hash] opts Optional Parameters
    def sweetalert_error(text, title = '', opts = {})
      opts[:type] = :error
      sweetalert(text, title, opts)
    end

    # Warning Alert
    #
    # @param [String] text Body of the alert (gets automatically the title if no title is specified)
    # @param [String] title Title of the alert
    # @param [Hash] opts Optional Parameters
    def sweetalert_warning(text, title = '', opts = {})
      opts[:type] = :warning
      sweetalert(text, title, opts)
    end

    private

    # Flash the configuration as json
    # If no title is specified, use the text as the title
    #
    # @param [Hash] opts
    # @return [Void]
    def flash_config(opts)
      if opts[:title].blank?
        opts[:title] = opts[:text]
        opts.delete(:text)
      end
      
      flash[:sweetify] = opts.to_json
      flash[:alert_id] = SecureRandom.hex
    end
  end
end

ActionController::Base.send :include, Sweetify::SweetAlert
