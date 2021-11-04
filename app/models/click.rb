# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  validates :browser, presence: true
  validates :platform, presence: true

  scope :on_current_month, lambda {
    where(
      created_at: Time.current.beginning_of_month..Time.current.end_of_month
    )
  }
  scope :count_daily_clicks, -> { group('date(created_at)').count }
  scope :count_by_browser, -> { group(:browser).count }
  scope :count_by_platform, -> { group(:platform).count }
end
