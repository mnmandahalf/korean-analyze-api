# frozen_string_literal: true
require 'net/http'

class Analysis::GetTranslation
  include ::Interactor
  GAS_URL = "https://script.google.com/macros/s/AKfycbyZOEOeTmftFoh4vO1hmLO7JNkiWOKOMarrACMS4YLz8Dnk2o0/exec"

  def call
    context.translation = get_translation(context.text)
    context.tokons_translation = get_tokens_translation(context.tokens)
  end

  private

  def get_tokens_translation(tokens)
    joind_tokens = tokens.map { |i| i[:stem] ? i[:stem] : i[:token] }.join(",")
    result = get_translation(joind_tokens)
    result.gsub("、",",").split(",")
  end

  def get_translation(text)
    uri = URI.parse(URI.encode("#{GAS_URL}?text=#{text}&source=ko&target=ja"))
    redirect_url = Net::HTTP.get_response(uri).response['location']
    res = Net::HTTP.get_response(URI.parse(redirect_url))
    str = res.body
    str.force_encoding("UTF-8")
    str
  end
end