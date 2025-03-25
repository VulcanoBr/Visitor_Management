import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    console.log('Departamento conectado !!!')
    this.element.addEventListener('change', this.updatedepartments.bind(this))
  }

  updatedepartments() {
    const unidadeId = this.element.value
    const departmentSelect = document.getElementById('employee_department_id')

    if (!unidadeId || unidadeId === '') {
      this.cleardepartments(departmentSelect)
      return
    }

    fetch(`/employees/departments_por_unit?unit_id=${unidadeId}`, {
      headers: {
        Accept: 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        this.populatedepartments(departmentSelect, data)
      })
  }

  cleardepartments(select) {
    select.innerHTML =
      '<option value="">Selecione uma unidade primeiro</option>'
    select.disabled = true
  }

  populatedepartments(select, departments) {
    select.innerHTML = '<option value="">Selecione um department</option>'

    departments.forEach(department => {
      const option = document.createElement('option')
      option.value = department.id
      option.textContent = department.name
      select.appendChild(option)
    })

    select.disabled = false
  }
}
