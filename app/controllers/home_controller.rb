class HomeController < ApplicationController
  def index
    @tags = Subject.tag_counts_on(:tags)
  end

  def api
  end

  def help
  end
end
