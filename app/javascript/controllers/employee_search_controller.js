import { Autocomplete } from 'stimulus-autocomplete'

export default class extends Autocomplete {
  static targets = [
    ...Autocomplete.targets,
    'unitName',
    'departmentName',
    'unitId',
    'departmentId'
  ]

  connect() {
    super.connect()
    console.log('Employee search  conectado!')
  }

  selectResult(event) {
    const item = event.currentTarget
    this.updateEmployeeDetails(item)
  }

  // Método auxiliar para atualizar os detalhes do funcionário
  updateEmployeeDetails(item) {
    const unitName = item.getAttribute('data-unit-name')
    const departmentName = item.getAttribute('data-department-name')
    const unitId = item.getAttribute('data-unit-id')
    const departmentId = item.getAttribute('data-department-id')

    if (this.hasUnitNameTarget) {
      this.unitNameTarget.value = unitName
    }

    if (this.hasDepartmentNameTarget) {
      this.departmentNameTarget.value = departmentName
    }

    if (this.hasUnitIdTarget) {
      this.unitIdTarget.value = unitId
    }

    if (this.hasDepartmentIdTarget) {
      this.departmentIdTarget.value = departmentId
    }
  }
}
