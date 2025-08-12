class TranscriptsController < ApplicationController
  before_action :set_transcript, only: %i[ show edit update destroy ]

  # GET /transcripts or /transcripts.json
  def index
    @transcripts = Transcript.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html {
        render "history_list"
      }
      format.json { render json: @transcripts }
    end
  end

  # GET /transcripts/1 or /transcripts/1.json
  def show
    @share_mode = request.path.start_with?("/s/")
  end

  # GET /transcripts/new
  def new
    @transcript = Transcript.new
  end

  # GET /transcripts/1/edit
  def edit
  end

  # POST /transcripts or /transcripts.json
  def create
    @transcript = Transcript.new(transcript_params)

    respond_to do |format|
      if @transcript.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("transcript-input", partial: "homes/input_forms/processing", locals: { transcript: @transcript })
        }
        format.html { redirect_to @transcript, notice: "Transcript was successfully created." }
        format.json { render :show, status: :created, location: @transcript }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("transcript-input", partial: "homes/input_forms/new", locals: { transcript: @transcript })
        }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transcript.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transcripts/1 or /transcripts/1.json
  def update
    respond_to do |format|
      if @transcript.update(transcript_params)
        format.html { redirect_to @transcript, notice: "Transcript was successfully updated." }
        format.json { render :show, status: :ok, location: @transcript }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transcript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transcripts/1 or /transcripts/1.json
  def destroy
    @transcript.destroy!

    respond_to do |format|
      format.html { redirect_to transcripts_path, status: :see_other, notice: "Transcript was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transcript
      @transcript = Transcript.find_by!(uuid: params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def transcript_params
      params.expect(transcript: [ :input, :uuid ])
    end
end
