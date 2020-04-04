# frozen_string_literal: true

class Analysis::FormatResponse
  include ::Interactor

  def call
    context.analysis = farmat_response(context.analysis)
  end

  private

  def farmat_response(analysis)
    analysis["detail"]["tokenizer"]["tokens"].map do |item|
      {
        token: item["token"],
        romanized: romanize(item["token"]),
        word_class: WORD_CLASS[item["leftPOS"]]
      }
    end
  end

  def romanize(token)
    Gimchi.romanize token
  end
end