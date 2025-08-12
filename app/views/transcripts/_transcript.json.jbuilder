json.extract! transcript, :id, :input, :output, :uuid, :status, :created_at, :updated_at
json.url transcript_url(transcript, format: :json)
