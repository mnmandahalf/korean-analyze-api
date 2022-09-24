# frozen_string_literal: true

class Analysis::ParseText
  include ::Interactor

  def call
    context.tokens = parse_text(context.text)
  end

  private

  def parse_text(text)
    nm = Natto::MeCab.new
    nodes = nm.enum_parse(text)
    nodes.map do |node|
      {
        token: node.surface,
        feature: node.feature.split(',').first
      }
    end
  end
end
