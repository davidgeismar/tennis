module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages
    sentence = I18n.t(
      'errors.messages.not_saved',
      count:    resource.errors.count,
      resource: resource.class.model_name.human.downcase
    )

    render 'devise/errors', sentence: sentence, messages: messages
  end
end
