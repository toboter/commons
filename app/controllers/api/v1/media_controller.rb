class Api::V1::MediaController < ActionController::API

  def index
    render json: Subject.all, each_serializer: SubjectSerializer
  end

  def show
    render json: Subject.friendly.find(params[:id]), serializer: SubjectSerializer
  end
  
  def search
    render json: Subject.filter_by(params[:q]), each_serializer: SubjectSerializer
  end
end