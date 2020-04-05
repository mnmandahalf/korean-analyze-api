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
      translation: context.translation,
      tokens: format_tokens(context.tokens, context.tokons_translation),
    }
  end

  def format_tokens(tokens, translated_tokens)
    tokens.zip(translated_tokens).map do |item, trans|
      {
        token: item["token"],
        romanized: romanize(item["token"]),
        translation: trans,
        word_class: WORD_CLASS[item["leftPOS"]]
      }
    end
  end

  def romanize(text)
    Gimchi.romanize text
  end
end