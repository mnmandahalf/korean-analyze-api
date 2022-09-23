# frozen_string_literal: true

class Analysis::FormatStem
  include ::Interactor

  def call
    context.tokens = format_stem(context.tokens)
  end

  private

  def format_stem(tokens)
    tokens.map do |item|
      token = item[:token]
      feature = item[:feature]
      {
        token: token,
        stem: stem(token, feature),
        feature: feature
      }
    end
  end

  def stem(token, feature)
    feature == "VV" ? token + "다" : nil
  end
end