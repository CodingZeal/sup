class TeamController < ApplicationController
  http_basic_authenticate_with name: ENV["USERNAME"], password: ENV["PASSWORD"]

  def index
    @groups = Group.includes(:members)
  end
end
