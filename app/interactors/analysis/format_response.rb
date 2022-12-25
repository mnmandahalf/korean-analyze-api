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
        translation: substitute_translation(item, trans),
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

  def substitute_translation(item, trans)
    case item[:feature]
    when 'J'
      return 'も' if item[:token] == '도'
      return 'が' if item[:token] == '이'
    when 'JKS'
      return 'が'
    when 'JKO'
      return 'を、に'
    when 'JKG'
      return 'の'
    when 'JKB'
      return 'で、から' if item[:token].in?(%w[에서 서])
      return 'から' if item[:token].in?(%w[에게서 한테서])
      return 'で、に、として' if item[:token].in?(%w[으로 로])
      return 'に' if item[:token].in?(%w[에 에게 한테 께])
      return 'くらい' if item[:token] == '만큼'
      return 'と' if item[:token] == '와'
    when 'JX'
      return 'は' if item[:token] == '는'
      return 'は' if item[:token] == '은'
      return '〜だけ、〜さえ' if item[:token] == '만'
      return '〜しか' if item[:token] == '밖에'
      return '〜だけ、〜のみ' if item[:token] == '뿐'
      return 'も' if item[:token].in?(%w[도 이나 나])
      return '〜まで' if item[:token] == '까지'
      return '〜から' if item[:token] == '부터'
    when 'JC'
      return 'と' if item[:token].in?(%w[이랑 랑 과 와])
    when 'XSN'
      return 'たち' if item[:token] == '들'
      return 'くらい' if item[:token].in?(%w[쯤 정도])
    when 'NNB'
      return 'くらい' if item[:token] == '만큼'
      return '〜すること' if item[:token] == '수'
    when 'EC'
      return 'なので' if item[:token].in?(%w[어서 아서 라서])
      return 'だから' if item[:token].in?(%w[으니까 아니까])
    when 'E'
      return '〜てから' if item[:token] == '어서'
      return '〜れば' if item[:token] == '면'
    when 'XSA+ETN'
      return '〜であること、〜さ'
    when 'XSA+ETM'
      return '〜な、〜である'
    when 'VCP+EC'
      return 'でも'
    end

    return trans if TRANSLATE_TARGETS.find { |target| item[:feature].include? target }
  end
end
