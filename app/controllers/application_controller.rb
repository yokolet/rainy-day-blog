class ApplicationController < ActionController::Base
  attr_accessor :redis

  def initialize
    super
    @redis = Redis.new(Rails.application.config.redis_db)
  end
end
