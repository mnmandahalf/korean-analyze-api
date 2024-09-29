class AnalysisResource
  include Alba::Resource

  root_key :analysis
  
  attributes :text, :romanized, :translation, :tokens
end
