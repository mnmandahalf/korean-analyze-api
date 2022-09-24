class ApplicationController < ActionController::API
  def health
    render plain: '', status: :ok
  end
end
