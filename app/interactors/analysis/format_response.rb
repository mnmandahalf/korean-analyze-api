# frozen_string_literal: true

class Analysis::FormatResponse
  include ::Interactor

  def call
    context.analysis = format_response(context.analysis)
  end

  private

  def format_response(analysis)
    {
      text: context.text,
      romanized: romanize(context.text),
      tokens: format_tokens(analysis["detail"]["tokenizer"]["tokens"])
    }
  end

  def format_tokens(tokens)
    tokens.map do |item|
      {
        token: item["token"],
        romanized: romanize(item["token"]),
        word_class: WORD_CLASS[item["leftPOS"]]
      }
    end
  end

  def romanize(text)
    Gimchi.romanize text
  end
end