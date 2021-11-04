# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :set_urls, only: :index
  before_action :set_url, only: %i[show visit]

  def create
    @url = Url.new(url_params)

    if @url.save
      redirect_to url_path(@url.short_url)
    else
      redirect_to urls_path, notice: @url.errors.full_messages.to_s
    end
  end

  def index
    @url = Url.new
  end

  def show
    @daily_clicks = @url.daily_clicks
    @browsers_clicks = @url.clicks.on_current_month.count_by_browser.to_a
    @platform_clicks = @url.clicks.on_current_month.count_by_platform.to_a
  end

  def visit
    if @url.visit!(browser.name, browser.platform.name)
      redirect_to @url.original_url
    else
      redirect_to urls_path, notice: "Couldn't redirect to original url"
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def set_urls
    @urls = Url.latest
  end

  def set_url
    short_url = params[:short_url] || params[:url]

    @url = Url.find_by!(short_url: short_url)
  rescue ActiveRecord::RecordNotFound
    render file: 'public/404.html', status: :not_found
  end
end
