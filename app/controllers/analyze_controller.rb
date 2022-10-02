# frozen_string_literal: true

class AnalyzeController < ApplicationController
  def index
    result = Analysis::Organizer.call(params:)
    render json: result.analysis
  end
end
