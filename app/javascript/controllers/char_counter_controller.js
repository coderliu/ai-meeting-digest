import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "counter"]

  connect() {
    // 初始化时更新字符计数
    this.updateCount()
  }

  updateCount() {
    if (this.hasTextareaTarget && this.hasCounterTarget) {
      const count = this.textareaTarget.value.length
      this.counterTarget.textContent = count
    }
  }
}
