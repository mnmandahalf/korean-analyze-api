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
      tokens: format_tokens(context.tokens, context.tokons_translation)
    }
  end

  def format_tokens(tokens, translated_tokens)
    tokens.zip(translated_tokens).map do |item, trans|
      next if item[:feature] == 'BOS/EOS'

      {
        token: item[:token],
        stem: item[:stem],
        romanized: romanize(item[:token]),
        translation: translation(item, trans),
        word_class: word_class_ja(item[:feature])
      }
    end.compact
  end

  def word_class_ja(feature)
    feature.split('+').map do |f|
      WORD_CLASS[f]
    end.join('+')
  end

  def romanize(text)
    Gimchi.romanize text
  end

  def translation(item, trans)
    if item[:feature] == 'J'
      return 'も' if item[:token] == '도'
      return 'が' if item[:token] == '이'
    end
    return 'たち' if item[:feature] == 'XSN' && (item[:token] == '들')

    if item[:feature] == 'E'
      return '〜てから' if item[:token] == '어서'
      return '〜れば' if item[:token] == '면'

      return nil
    end

    return trans if item[:feature].in?(TRANSLATE_TARGETS)
  end
end
