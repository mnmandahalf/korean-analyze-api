# frozen_string_literal: true

class Analysis::GetElasticsearchAnalysis
  include ::Interactor

  def call
    analysis = get_es_analysis(context.text)
    context.analysis = analysis
    context.tokens = analysis["detail"]["tokenizer"]["tokens"]
  end

  private

  def get_es_analysis(text)
    client = Elasticsearch::Client.new host: 'host.docker.internal', log: true
    client.indices.analyze body: {
      tokenizer: 'nori_tokenizer',
      text: text,
      explain: true
    } 
  end
end