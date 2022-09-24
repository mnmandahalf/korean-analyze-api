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
        feature: node.feature.split(',').first,
        split_feature: parse_composed_feature(node.feature.split(',').last)
      }
    end
  end

  # text: 깨우/VV/*+어/EC/*
  # returns [{:token=>"깨우", :feature=>"VV"}, {:token=>"어", :feature=>"EC"}]
  def parse_composed_feature(text)
    text.split('+').map do |t|
      items = t.split('/')
      return if items.size < 2

      {
        token: items[0],
        feature: items[1]
      }
    end.compact
  end
end
