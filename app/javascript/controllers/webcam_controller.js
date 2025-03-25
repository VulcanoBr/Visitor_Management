import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['camera', 'capturedPhoto', 'photoInput']

  connect() {
    console.log('Webcam conectada !!!')
    if (typeof Webcam === 'undefined') {
      console.error('Webcam.js não está carregado')
      return
    }

    Webcam.set({
      width: 320,
      height: 240,
      image_format: 'jpeg',
      jpeg_quality: 90
    })

    Webcam.attach(this.cameraTarget)
  }

  cancela() {
    console.log('cancel')
  }

  open() {
    Webcam.attach(this.element)
    this.modalTarget.classList.remove('d-none')
  }

  takeSnapshot() {
    Webcam.snap(dataUri => {
      this.capturedPhotoTarget.src = dataUri
      this.capturedPhotoTarget.style.display = 'block'

      const blob = this.dataURItoBlob(dataUri)

      let cpf = document.querySelector(
        '#visitorModal input[name="visitor[cpf]"]'
      ).value

      if (!cpf) {
        cpf = document.getElementById('visitor_cpf').value
      }
      cpf = cpf.replace(/[^0-9]/g, '')
      const filename = cpf ? `${cpf}.jpg` : 'visitor_photo.jpg'
      const file = new File([blob], filename, { type: 'image/jpeg' })
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      this.photoInputTarget.files = dataTransfer.files
    })
  }

  dataURItoBlob(dataURI) {
    const byteString = atob(dataURI.split(',')[1])
    const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
    const ab = new ArrayBuffer(byteString.length)
    const ia = new Uint8Array(ab)

    for (let i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i)
    }

    return new Blob([ab], { type: mimeString })
  }

  disconnect() {
    console.log('webcam desconnectada !!!')
    Webcam.reset()
  }
}
