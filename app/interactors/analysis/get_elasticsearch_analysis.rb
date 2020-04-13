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
    client = Elasticsearch::Client.new host: [{
        log: true,
        host: "381c69ad66864ad9809e0c3805015ea9.us-east-1.aws.found.io",
        port: 9243,
        scheme: "https",
        user: "nori_analyzer",
        password: ENV.fetch("ES_PASSWORD")
    }]

    client.indices.analyze body: {
      tokenizer: 'nori_tokenizer',
      text: text,
      explain: true
    } 
  end
end