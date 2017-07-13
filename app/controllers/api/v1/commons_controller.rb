class Api::V1::CommonsController < ActionController::API
  require 'rest-client'
  require 'json'

  before_action :set_user

  def index
    render json: Subject.visible_for(@user).all, each_serializer: CommonSerializer
  end

  def show
    render json: Subject.visible_for(@user).friendly.find(params[:id]), serializer: CommonSerializer
  end
  
  def search
    render json: Subject.visible_for(@user).search(params[:q]), each_serializer: CommonSerializer
  end

  private
    def set_user
      token = request.headers['Authorization'] ? request.headers['Authorization'].split(' ').last : params[:access_token]
      @user = token.present? ? User.find_by_token(token) : nil
    end

end