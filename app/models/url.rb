# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks, dependent: :destroy

  before_validation :set_short_url, on: :create

  validates :original_url, presence: true
  validates :short_url, uniqueness: true

  validate :original_url_is_valid?, if: -> { original_url.present? }

  scope :latest, -> { order(created_at: :desc).limit(10) }

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
