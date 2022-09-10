# frozen_string_literal: true

class Analysis::FormatStem
  include ::Interactor

  def call
    context.tokens = format_stem(context.tokens)
  end

  private

  def format_stem(tokens)
    tokens = [{
      "token": {},
      "leftPOS": {}
    }]
    tokens.map do |item|
      token = item["token"]
      leftPOS = item["leftPOS"]
      {
        token: token,
        stem: stem(token, leftPOS),
        leftPOS: leftPOS
      }
    end
  end

  def stem(token, pos)
    pos == "VV(Verb)" ? token + "다" : nil
  end
end