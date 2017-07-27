class SubjectsController < ApplicationController
  # bug in fileupload fires get request for [object Object]
  before_action :set_type, except: [:new, :create]
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :view_file]

  load_and_authorize_resource
  skip_load_resource only: [:index, :show, :new, :create, :edit, :update, :update_multiple, :destroy, :view_file]
  skip_authorize_resource only: :index


  # GET /subjects
  # GET /subjects.json
  def index
    @filterrific = initialize_filterrific(
      type_class.visible_for(current_user),
      params[:filterrific],
      select_options: {
        sorted_by: Subject.options_for_sorted_by
      }
    ) or return
    @subjects =  @filterrific.find.page(params[:page]).per_page(session[:per_page])

  end


  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end
  
  # GET /subjects/1/edit
  def edit
  end


  # POST /subjects
  # POST /subjects.json
  def create
    file = subject_params[:file].class == Array ? subject_params[:file].first : subject_params[:file]
    media_type = media_type_for(content_type_for(file.tempfile), file.content_type)
    @subject = media_type.constantize.new
    if @subject.class.name.in?(Subject.types)
      @subject.file = file
      @subject.content_type = file.content_type 
    end

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
        format.js
      else
        error = {files: [{status: :unprocessable_entity, name: file.original_filename, size: 0, error: @subject.errors.messages.map{|k,v| "#{k} #{v.join}"}.join(', ')}]}
        format.html { render :new }
        format.json { render json: error }
        format.js
      end
    end
  end


  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    # should validate that content_type still is in @subject.class
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update_multiple
    @subjects = Subject.find(params[:subject_ids])
    @subjects.each do |subject|
      subject.update_attributes!(subject_params.reject { |k,v| v.blank? })
    end
    flash[:notice] = "Updated subjects!"
    redirect_to subjects_path
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


   def view_file
     uploaded_file = @subject.file.is_a?(Hash) ? @subject.file.fetch(params[:version].to_sym) : @subject.file
     # retrieve the Shrine::UploadedFile, assuming #file is the attachment name on Image model

     headers["Content-Length"] = uploaded_file.size
     headers["Content-Type"] = uploaded_file.mime_type
     headers["Content-Disposition"] = "inline; filename=\"#{uploaded_file.original_filename}\""

     self.response_body = Enumerator.new do |yielder|
       yielder << uploaded_file.read(16*1024) until uploaded_file.eof?
       uploaded_file.close
     end
   end


  private
    def set_type
      @type = type
    end
    
    def type
      Subject.types.include?(params[:type]) ? params[:type] : "Subject"
    end
    
    def type_class
      type.constantize
    end

    def media_type_for(content_type, fs=nil)
      mediatype = content_type.split('/').first.classify
      subtype = content_type.split('/').last
      if mediatype == 'Application' && subtype.in?(Document.application_subtypes)
        type = 'Document'
      elsif mediatype == 'Text' && subtype.in?(Document.text_subtypes)
        type = 'Document'
      elsif mediatype == 'Image' && subtype.in?(Image.subtypes)
        type = 'Image'
      elsif mediatype == 'Audio' && subtype.in?(Audio.subtypes)
        type = 'Audio'
      elsif mediatype == 'Video' && subtype.in?(Video.subtypes)
        type = 'Video'
      else
        type = fs.present? ? media_type_for(fs) : 'Subject'
      end
      type if Subject.types.include?(type) || type == 'Subject'
    end

    def content_type_for(tmpfile)
      require 'filemagic'
      require 'mimemagic'
      content_type = FileMagic.new(FileMagic::MAGIC_MIME).file(tmpfile.open.path).split(';').first
      if content_type == 'application/octet-stream'
        content_type = MimeMagic.by_path(File.open(tmpfile)).type
      end
      content_type
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = type_class.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(type.underscore.to_sym).permit(:name, :description, :file, :file_copyright, :file_copyright_details, :tag_list => [], :file => [], :tag_add_list => [], :tag_remove_list => [])
    end
end
