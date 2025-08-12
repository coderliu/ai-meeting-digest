module ApplicationHelper
  def render_markdown(text)
    MarkdownService.render(text)
  end

  def render_markdown_plain_text(text)
    MarkdownService.render_plain_text(text)
  end

  def truncate_markdown(text, length: 300)
    MarkdownService.truncate_with_markdown(text, length: length)
  end
end
