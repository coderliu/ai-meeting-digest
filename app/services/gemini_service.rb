class GeminiService
  PROMPT_PREFIX = <<~STR
    Create a well-structured markdown summary of the meeting transcript below.

    Summary format:
      1. A brief, one-paragraph overview of the meeting.
      2. A bulleted list of the key decisions made.
      3. A bulleted list of the action items assigned, and to whom.

    Rules:
      - Return only the summary content, no greetings or closings
      - Use proper markdown formatting
      - Maintain professional tone
      - Be concise but comprehensive

    Meeting transcript to summarize:

  STR

  SYSTEM_INSTRUCTION = <<~STR
    You are a language-aware meeting summarizer. \
    CRITICAL: You MUST detect the language of the input transcript and respond in EXACTLY the same language. \
    If the input contains English text, respond in English. If the input contains Chinese text, respond in Chinese. \
    If the input contains Japanese text, respond in Japanese. If the input contains Korean text, respond in Korean. \
    NEVER default to Chinese when the input is in English. The language of your response MUST match the language of \
    the input transcript.
  STR

  def generate_output(input, &block)
    client.stream_generate_content(
      {
        contents: { role: 'user', parts: { text: PROMPT_PREFIX + input } },
        system_instruction: {
          role: 'user',
          parts: { text: SYSTEM_INSTRUCTION }
        }
      }
    ) do |event, parsed, raw|
      yield(event, parsed, raw)
    end
  end

  private

  def client
    @client ||= Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV["GEMINI_API_KEY"].presence || Rails.application.credentials.gemini_api_key,
        version: 'v1beta'
      },
      options: { model: 'gemini-2.0-flash', server_sent_events: true }
    )
  end
end
