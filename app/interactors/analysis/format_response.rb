# frozen_string_literal: true

class Analysis::FormatResponse
  include ::Interactor

  def call
    context.analysis = format_response
  end

  private

  def format_response
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
        translation: translation(item, trans),
        word_class: WORD_CLASS[item["leftPOS"]]
      }
    end
  end

  def romanize(text)
    Gimchi.romanize text
  end

  def translation(item, trans)
    if item["leftPOS"] == "J(Ending Particle)"
      return "も" if item["token"] == "도"
    end
    return trans
  end
end