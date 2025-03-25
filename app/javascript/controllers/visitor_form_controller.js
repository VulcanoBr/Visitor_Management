import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'
import { Modal } from 'bootstrap'

export default class extends Controller {
  static targets = ['visitorModal', 'form']

  connect() {
    console.log('visitor_form conectado !!!')

    if (this.hasVisitorModalTarget) {
      this.visitorModalTarget.addEventListener(
        'hidden.bs.modal',
        this.resetForm.bind(this)
      )
    }
  }

  cancel() {
    console.log('cancel')
    this.resetForm()
  }

  resetForm() {
    if (this.hasFormTarget) {
      // Reseta o formulário HTML
      this.formTarget.reset()

      // Limpa a imagem capturada da webcam
      const capturedPhoto = document.querySelector(
        '[data-webcam-target="capturedPhoto"]'
      )
      if (capturedPhoto) {
        capturedPhoto.style.display = 'none'
        capturedPhoto.src = '#'
      }

      // Limpa o input de arquivo
      const photoInput = document.querySelector(
        '[data-webcam-target="photoInput"]'
      )
      if (photoInput) {
        photoInput.value = ''
      }
    }
  }

  populateVisitorData(data) {
    document.getElementById('visitor_id').value = data.id
    document.getElementById('visitor_cpf').innerText = data.cpf
    document.getElementById('visitor_name').innerText = data.name
    document.getElementById('visitor_phone').innerText = data.phone
    document.getElementById('visitor_company').innerText = data.company
    document.getElementById('visitor_photo').src = data.photo_url
  }
}
