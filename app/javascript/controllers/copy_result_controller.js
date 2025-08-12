import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    // Controller 连接时的初始化
  }

  copyResult() {
    // 获取 AI 输出内容
    const outputElement = document.getElementById('transcript-output')
    if (!outputElement) {
      this.showCopyError('未找到输出内容')
      return
    }

    // 获取纯文本内容（去除 HTML 标签）
    const textContent = this.getTextContent(outputElement)

    if (!textContent || textContent.trim() === '') {
      this.showCopyError('没有可复制的内容')
      return
    }

    // 尝试使用现代浏览器的 Clipboard API
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(textContent).then(() => {
        this.showCopySuccess()
      }).catch((err) => {
        console.error('复制失败:', err)
        this.fallbackCopy(textContent)
      })
    } else {
      // 降级方案：使用传统的 document.execCommand
      this.fallbackCopy(textContent)
    }
  }

  fallbackCopy(text) {
    const textArea = document.createElement('textarea')
    textArea.value = text
    textArea.style.position = 'fixed'
    textArea.style.left = '-999999px'
    textArea.style.top = '-999999px'
    document.body.appendChild(textArea)
    textArea.focus()
    textArea.select()

    try {
      const successful = document.execCommand('copy')
      if (successful) {
        this.showCopySuccess()
      } else {
        this.showCopyError('复制失败')
      }
    } catch (err) {
      console.error('复制失败:', err)
      this.showCopyError('复制失败')
    }

    document.body.removeChild(textArea)
  }

  getTextContent(element) {
    // 如果是初始状态（等待输入），返回空字符串
    const waitingElement = element.querySelector('.flex.flex-col.items-center.justify-center')
    if (waitingElement) {
      return ''
    }

    // 获取纯文本内容，保留换行符
    let text = ''
    const walker = document.createTreeWalker(
      element,
      NodeFilter.SHOW_TEXT,
      null,
      false
    )

    let node
    while (node = walker.nextNode()) {
      text += node.textContent
    }

    return text.trim()
  }

  showCopySuccess() {
    const originalText = this.buttonTarget.innerHTML
    const originalClasses = this.buttonTarget.className

    this.buttonTarget.innerHTML = `
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      已复制
    `

    // 更新按钮样式为成功状态
    this.buttonTarget.classList.remove('border-gray-200', 'text-gray-700', 'hover:border-gray-300', 'hover:bg-gray-50')
    this.buttonTarget.classList.add('border-green-300', 'text-green-700', 'bg-green-50')

    setTimeout(() => {
      this.buttonTarget.innerHTML = originalText
      this.buttonTarget.className = originalClasses
    }, 2000)
  }

  showCopyError(message) {
    const originalText = this.buttonTarget.innerHTML
    const originalClasses = this.buttonTarget.className

    this.buttonTarget.innerHTML = `
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
      </svg>
      ${message}
    `

    // 更新按钮样式为错误状态
    this.buttonTarget.classList.remove('border-gray-200', 'text-gray-700', 'hover:border-gray-300', 'hover:bg-gray-50')
    this.buttonTarget.classList.add('border-red-300', 'text-red-700', 'bg-red-50')

    setTimeout(() => {
      this.buttonTarget.innerHTML = originalText
      this.buttonTarget.className = originalClasses
    }, 2000)
  }
}
