class JobsController < ApplicationController
  before_action :require_login
  before_action :set_job, only: %i[ show edit update destroy ]

  # GET /jobs or /jobs.json
  def index
    @jobs = current_user.jobs.not_archived.order(order: :desc)
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    @job = current_user.jobs.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to job_url(@job), notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    if params[:up]
      @job.reorder_up!
      redirect_to jobs_url
    elsif params[:down]
      @job.reorder_down!
      redirect_to jobs_url
    elsif params[:archive]
      @job.update(status: 'archived', order: 0)
      redirect_to job_url(@job), notice: "Job was successfully archived."
    elsif @job.update(job_params)
      redirect_to jobs_url, notice: "Job was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy!

    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = current_user.jobs.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:entity, :title, :url, :description, :status, :order, :source_id, :salary, :primary_contact_email, :primary_contact_phone, :primary_contact_name)
    end
end
