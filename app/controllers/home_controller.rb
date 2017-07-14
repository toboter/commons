class HomeController < ApplicationController
  def index
    @data = access_token.get("/api/me").parsed if current_user && access_token
    @tags = Subject.tag_counts_on(:tags)
  end

  def api
  end

  def help
  end
end
