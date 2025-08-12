class GenerateOutputJob < ApplicationJob
  queue_as :default

  def perform(transcript)
    stream_key = "transcript:#{transcript.uuid}"
    ::GeminiService.new.generate_output(transcript.input) do |event, _, _|
      text = event.dig("candidates", 0, "content", "parts", 0, "text")
      if transcript.output.blank?
        transcript.output = text
      else
        transcript.output += text
      end

      transcript.broadcast_action_to stream_key, action: :update,
          target: "transcript-output",
          html: render_markdown(transcript.output)
    end

    transcript.status = :done
    transcript.save!
    transcript.broadcast_action_to stream_key, action: :update,
      target: "transcript-input",
      partial: "homes/input_forms/done",
      locals: { transcript: transcript }
  end

  private

  def render_markdown(text)
    MarkdownService.render(text)
  end
end
