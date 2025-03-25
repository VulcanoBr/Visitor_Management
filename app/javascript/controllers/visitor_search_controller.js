import { Controller } from '@hotwired/stimulus'
import { Turbo } from '@hotwired/turbo-rails'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static targets = [
    'cpf',
    'visitorInfo',
    'visitorId',
    'visitorCpf',
    'visitorName',
    'visitorPhone',
    'visitorCompany',
    'visitorPhoto',
    'visitorModal',
    'employeeSearchSection'
  ]

  connect() {
    console.log('Web search conectado !!!')
  }

  maskCPF() {
    let cpf = this.cpfTarget.value
    cpf = cpf.replace(/\D/g, '') // Remove caracteres não numéricos
    cpf = cpf.replace(/(\d{3})(\d)/, '$1.$2') // Adiciona o primeiro ponto
    cpf = cpf.replace(/(\d{3})(\d)/, '$1.$2') // Adiciona o segundo ponto
    cpf = cpf.replace(/(\d{3})(\d{1,2})/, '$1-$2') // Adiciona o traço
    this.cpfTarget.value = cpf
  }

  // Validação do CPF
  validateCPF(cpf) {
    cpf = cpf.replace(/[^\d]/g, '')

    if (cpf.length !== 11) return false
    if (/^(\d)\1{10}$/.test(cpf)) return false

    let sum = 0
    let remainder

    for (let i = 1; i <= 9; i++) {
      sum = sum + parseInt(cpf.substring(i - 1, i)) * (11 - i)
    }
    remainder = (sum * 10) % 11
    if (remainder === 10 || remainder === 11) remainder = 0
    if (remainder !== parseInt(cpf.substring(9, 10))) return false

    sum = 0
    for (let i = 1; i <= 10; i++) {
      sum = sum + parseInt(cpf.substring(i - 1, i)) * (12 - i)
    }
    remainder = (sum * 10) % 11
    if (remainder === 10 || remainder === 11) remainder = 0
    if (remainder !== parseInt(cpf.substring(10, 11))) return false

    return true
  }

  // Opção 1: Usando Alert Bootstrap
  showBootstrapAlert() {
    // Remove alert anterior se existir
    const existingAlert = document.querySelector('.alert')
    if (existingAlert) {
      existingAlert.remove()
    }

    // Cria novo alert
    const alertDiv = document.createElement('div')
    alertDiv.className = 'alert alert-danger alert-dismissible fade show'
    alertDiv.role = 'alert'
    alertDiv.innerHTML = `
      CPF inválido. Por favor, verifique o número informado.
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `

    // Insere o alert no topo do container ou form
    const container = this.element.closest('.container') || this.element
    container.insertBefore(alertDiv, container.firstChild)

    // Remove o alert após 5 segundos
    setTimeout(() => {
      alertDiv.remove()
    }, 5000)
  }

  search() {
    const cpf = this.cpfTarget.value

    if (!this.validateCPF(cpf)) {
      this.showBootstrapAlert() // Para usar alert do Bootstrap
      return
    }

    fetch(`/visitors/search?cpf=${cpf}`, {
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute('content') // Adiciona o token CSRF
      }
    })
      .then(response => {
        if (response.status === 404) {
          // Abre o modal para cadastrar o visitante
          const modal = new bootstrap.Modal(
            document.getElementById('visitorModal')
          )

          const modalCpfInput = document.querySelector(
            '#visitorModal input[name="visitor[cpf]"]'
          )
          if (modalCpfInput) {
            modalCpfInput.value = cpf
          }

          modal.show()
          return
        }
        return response.json()
      })
      .then(data => {
        if (data) {
          this.visitorIdTarget.value = data.id
          this.visitorCpfTarget.innerText = data.cpf
          this.visitorNameTarget.innerText = data.name
          this.visitorPhoneTarget.innerText = data.phone
          this.visitorCompanyTarget.innerText = data.company
          this.visitorPhotoTarget.src = data.photo_url
          this.visitorInfoTarget.style.display = 'block'
          // Show employee search section
          this.employeeSearchSectionTarget.style.display = 'block'
        }
      })
      .catch(error => {
        console.error('Erro na requisição:', error)
      })
  }
}
