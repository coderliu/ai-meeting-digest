# AI Meeting Digest

A full-stack Rails web application with Hotwire that allows a user to submit a raw meeting transcript and, in return, receive a concise, AI-generated summary.

---

# Features
#### Shareable Digest Links
    1. Add another route(`/s/:uuid`) for sharing link, reuse the same controller(`TranscriptsController`), hide action buttons in page when rendering page for sharing link.
    2. Let AI add button for sharing and add Stimulus controller for it.

#### Real-time Streaming Response

To provide a real-time user experience as the AI generates its response, I leveraged **Turbo Streams**.

My initial implementation used the `append` Turbo Stream action to add incoming Markdown text chunks to the page. However, I switched to the `update` action for the following reasons:
1. **Handling Incomplete Fragments**: A single data chunk from the AI might be a syntactically incomplete Markdown fragment. Appending these directly could lead to broken formatting.
2. **Ensuring Correct Final Rendering**: Using update, I can concatenate all received fragments and render them into HTML in a single, coherent block. This ensures the final display is always correctly formatted.
3. **Immediate Correction**: If a previous stream event resulted in a rendering error, the next update action immediately corrects it by replacing the entire content, preventing a broken state from persisting on the page.

---

# Setup

* Ruby version

    3.4.5

* System dependencies

    PostgreSQL installed

* Configuration

    GEMINI_API_KEY="YOUR_API_KEY"

* Database creation & initialization

    ```
    bin/rails db:setup
    ```
