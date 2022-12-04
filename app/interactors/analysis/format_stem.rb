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
        token:,
        stem: stem(token, feature),
        feature:
      }
    end
  end

  def stem(token, feature)
    return token + '다' if feature.in?(STEM_TARGETS)
    return token + '하다' if feature == 'XR'
    nil
  end
end
