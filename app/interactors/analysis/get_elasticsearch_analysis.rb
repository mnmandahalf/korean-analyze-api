# frozen_string_literal: true

class Analysis::GetElasticsearchAnalysis
  include ::Interactor

  def call
    context.analysis = get_es_analysis(context.text)
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