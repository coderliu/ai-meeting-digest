import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    // Controller 连接时的初始化
  }

  share() {
    const shareUrl = this.urlValue

    // 尝试使用现代浏览器的 Clipboard API
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(shareUrl).then(() => {
        this.showCopySuccess()
      }).catch((err) => {
        console.error('复制失败:', err)
        this.fallbackCopy(shareUrl)
      })
    } else {
      // 降级方案：使用传统的 document.execCommand
      this.fallbackCopy(shareUrl)
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
        this.showCopyError()
      }
    } catch (err) {
      console.error('复制失败:', err)
      this.showCopyError()
    }

    document.body.removeChild(textArea)
  }

  showCopySuccess() {
    const originalText = this.element.innerHTML
    const originalClasses = this.element.className

    this.element.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      已复制
    `

    // 根据按钮类型调整样式
    if (this.element.classList.contains('bg-green-600')) {
      // 主要分享按钮（绿色）
      this.element.classList.remove('bg-green-600', 'hover:bg-green-500')
      this.element.classList.add('bg-green-500')
    } else {
      // 次要分享按钮（灰色）
      this.element.classList.remove('text-gray-700', 'bg-white', 'hover:bg-gray-50')
      this.element.classList.add('text-green-700', 'bg-green-50', 'border-green-300')
    }

    setTimeout(() => {
      this.element.innerHTML = originalText
      this.element.className = originalClasses
    }, 2000)
  }

  showCopyError() {
    const originalText = this.element.innerHTML
    const originalClasses = this.element.className

    this.element.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
      </svg>
      复制失败
    `

    // 根据按钮类型调整样式
    if (this.element.classList.contains('bg-green-600')) {
      // 主要分享按钮（绿色）
      this.element.classList.remove('bg-green-600', 'hover:bg-green-500')
      this.element.classList.add('bg-red-500')
    } else {
      // 次要分享按钮（灰色）
      this.element.classList.remove('text-gray-700', 'bg-white', 'hover:bg-gray-50')
      this.element.classList.add('text-red-700', 'bg-red-50', 'border-red-300')
    }

    setTimeout(() => {
      this.element.innerHTML = originalText
      this.element.className = originalClasses
    }, 2000)
  }
}
