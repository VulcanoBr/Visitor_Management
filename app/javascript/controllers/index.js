// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from './application'

import HelloController from './hello_controller'
application.register('hello', HelloController)

import VisitorSearchController from './visitor_search_controller'
application.register('visitor-search', VisitorSearchController)

import WebcamController from './webcam_controller'
application.register('webcam', WebcamController)

import UnitSelectController from './unit_select_controller'
application.register('unit-select', UnitSelectController)

import { Autocomplete } from 'stimulus-autocomplete'
application.register('autocomplete', Autocomplete)

import EmployeeSearchController from './employee_search_controller'
application.register('employee-search', EmployeeSearchController)

import VisitorFormController from './visitor_form_controller'
application.register('visitor-form', VisitorFormController)

import MaskphoneController from './maskphone_controller'
application.register('maskphone', MaskphoneController)
