# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks, dependent: :destroy

  before_validation :set_short_url, on: :create

  validates :original_url, presence: true
  validates :short_url, uniqueness: true

  validate :original_url_is_valid?, if: -> { original_url.present? }

  scope :latest, -> { order(created_at: :desc).limit(10) }

  def visit!(browser, platform)
    transaction do
      clicks.create(browser: browser, platform: platform)

      update(clicks_count: clicks.count)
    end
  end

  def daily_clicks
    daily_clicks = []

    clicks.on_current_month.count_daily_clicks.each do |k, v|
      daily_clicks << [k.day, v]
    end

    daily_clicks
  end

  private

  def set_short_url
    self[:short_url] ||= SecureRandom.alphanumeric(5).upcase
  end

  def original_url_is_valid?
    uri = URI.parse(original_url)

    return if uri.is_a?(URI::HTTP)

    errors.add(:original_url, :invalid)
  end
end
