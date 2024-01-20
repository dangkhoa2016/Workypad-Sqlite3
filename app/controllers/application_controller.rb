class ApplicationController < ActionController::Base
  # skip_before_action :verify_authenticity_token
  include Clearance::Controller

  before_action :require_login
end
