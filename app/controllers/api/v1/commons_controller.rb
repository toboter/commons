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

  # +cors
  def view_file
    @subject = Subject.visible_for(@user).friendly.find(params[:id])
    uploaded_file = @subject.file.is_a?(Hash) ? @subject.file.fetch(params[:version].to_sym) : @subject.file
    headers["Content-Length"] = uploaded_file.size
    headers["Content-Type"] = uploaded_file.mime_type
    headers["Content-Disposition"] = "inline; filename=\"#{uploaded_file.original_filename}\""
    self.response_body = Enumerator.new do |yielder|
      yielder << uploaded_file.read(16*1024) until uploaded_file.eof?
      uploaded_file.close
    end
  end

  private
    def set_user
      token = request.headers['Authorization'] ? request.headers['Authorization'].split(' ').last : params[:access_token]
      @user = token.present? ? User.find_by_token(token) : nil
    end

end