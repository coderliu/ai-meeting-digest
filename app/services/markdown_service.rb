class MarkdownService
  class << self
    def render(text)
      return "" if text.blank?

      # 创建 Redcarpet 实例，启用常用扩展
      markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(
          hard_wrap: true,           # 将换行符转换为 <br>
          link_attributes: { target: "_blank" }  # 链接在新窗口打开
        ),
        extensions = {
          autolink: true,            # 自动链接
          tables: true,              # 表格支持
          fenced_code_blocks: true,  # 代码块
          strikethrough: true,       # 删除线
          superscript: true,         # 上标
          underline: true,           # 下划线
          highlight: true,           # 高亮
          quote: true,               # 引用
          footnotes: true            # 脚注
        }
      )

      # 渲染 Markdown 并确保安全
      markdown.render(text).html_safe
    end

    def render_plain_text(text)
      return "" if text.blank?

      # 移除 HTML 标签，保留纯文本
      ActionView::Base.full_sanitizer.sanitize(text)
    end

    def truncate_with_markdown(text, length: 300)
      return "" if text.blank?

      # 先渲染 Markdown，然后截断
      rendered = render(text)
      truncated = truncate_html(rendered, length: length)
      truncated
    end

    private

    def truncate_html(html, length: 300)
      # 简单的 HTML 截断，保持标签完整性
      if html.length <= length
        html
      else
        # 找到最后一个完整的单词边界
        truncated = html[0...length]
        last_space = truncated.rindex(' ')

        if last_space
          truncated = truncated[0...last_space]
        end

        truncated + "..."
      end
    end
  end
end
