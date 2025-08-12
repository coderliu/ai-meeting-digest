class HomesController < ApplicationController
  def index
    @new_transcript = Transcript.new
    @new_transcript.set_uuid
  end
end
