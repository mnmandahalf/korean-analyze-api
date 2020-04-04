# frozen_string_literal: true

class Analysis::CheckParameter
  include ::Interactor

  def call
    text = context.params.permit(:text)[:text]
    context.fail! if text.nil?
    context.text = text 
  end
end