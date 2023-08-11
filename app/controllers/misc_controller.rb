class MiscController < ApplicationController
  def info
    render html: Rails::Info.to_html.html_safe
  end
end
