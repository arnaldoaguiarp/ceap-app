# frozen_string_literal: true

# Job base para todos os jobs da API.
class ApplicationJob < ActiveJob::Base
  sidekiq_options retry: 3, backtrace: true

  sidekiq_retry_in do |count, exception|
    case exception
    when Net::TimeoutError, Redis::TimeoutError
      10 * (count + 1) # 10, 20, 30 segundos
    when ActiveRecord::Deadlocked
      5 * (count + 1)  # 5, 10, 15 segundos
    else
      :default
    end
  end

  protected

  def log_error(message, extra_data = {})
    Rails.logger.error({
      job: self.class.name,
      message: message,
      **extra_data
    }.to_json)
  end

  def log_info(message, extra_data = {})
    Rails.logger.info({
      job: self.class.name,
      message: message,
      **extra_data
    }.to_json)
  end
end
