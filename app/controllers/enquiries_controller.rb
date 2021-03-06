class EnquiriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy, :report]

  # GET /enquiries
  # GET /enquiries.json
  def index
    if current_user.admin?
      @enquiries = Enquiry.all
    else
      @enquiries = Enquiry.where(user_id: current_user.id)
    end
  end

  # GET /enquiries/1
  # GET /enquiries/1.json
  def show
    @replies = @enquiry.replies
  end

  # GET /enquiries/new
  def new
    @enquiry = Enquiry.new
    @categories = Category.all
  end

  # GET /enquiries/1/edit
  def edit
  end

  # POST /enquiries
  # POST /enquiries.json
  def create
    @enquiry = Enquiry.new(enquiry_params)
    @enquiry.user_id = current_user.id
    respond_to do |format|
      if @enquiry.save
        format.html { redirect_to @enquiry, notice: 'Enquiry was successfully created.' }
        format.json { render :show, status: :created, location: @enquiry }
      else
        format.html { render :new }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enquiries/1
  # PATCH/PUT /enquiries/1.json
  def update
    respond_to do |format|
      if @enquiry.update(enquiry_params)
        format.html { redirect_to @enquiry, notice: 'Enquiry was successfully updated.' }
        format.json { render :show, status: :ok, location: @enquiry }
      else
        format.html { render :edit }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enquiries/1
  # DELETE /enquiries/1.json
  def destroy
    @enquiry.destroy
    respond_to do |format|
      format.html { redirect_to enquiries_url, notice: 'Enquiry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	def report
		redirect_to :back, notice: 'Enquiry was successfully reported.'
	end

  def looking_for_work
    @enquiries = !current_user.provider.nil? ? Enquiry.where(category_id: current_user.provider.category.id) : []
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enquiry
      @enquiry = Enquiry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enquiry_params
      params.fetch(:enquiry, {}).permit(:title, :description, :deadline, :category_id, :budget ,:max_applications ,:email ,:mobile ,:contact_details ,:job_description, :deleted_at)
    end
end
