SimpleForm.setup do |config|
  config.wrappers tag: :div, class: :input_field,
                error_class: :field_with_errors do |b|

  # Form extensions
    b.use :html5
    b.optional :pattern
    b.use :maxlength
    b.use :placeholder
    b.use :readonly

    # Form components
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :span, class: :hint }
    b.use :error, wrap_with: { tag: :span, class: :error }
  end
  # config.error_notification_class = ''
  # config.button_class = ''
  # config.boolean_label_class = nil

  # config.wrappers :vertical_form, tag: 'div', class: '', error_class: 'error' do |b|
  #   b.use :html5
  #   b.use :placeholder
  #   b.optional :maxlength
  #   b.optional :pattern
  #   b.optional :min_max
  #   b.optional :readonly
  #   b.use :label, class: ''

  #   b.use :input, class: ''
  #   b.use :error, wrap_with: { tag: 'span', class: 'error' }
  #   b.use :hint,  wrap_with: { tag: 'p', class: '' }
  # end

  # config.wrappers :inline_checkbox, :tag => 'div', :class => 'clearfix', :error_class => 'error' do |b|
  #   b.use :html5
  #   b.wrapper :tag => 'div' do |ba|
  #     ba.use :label, class: 'block', :wrap_with => { :tag => 'div', :class => 'clearfix' }
  #     ba.use :input, class: 'field mr1'
  #     ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
  #     ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
  #   end
  # end

  # config.default_wrapper = :vertical_form
  # config.wrapper_mappings = {
  #   radio_buttons: :inline_checkbox
  # }
end
