class Visit < ApplicationRecord

  belongs_to :visitor
  belongs_to :employee
  belongs_to :unit, optional: true
  belongs_to :department, optional: true

  validates :entry_date, :entry_time, presence: true
  validates :employee_id,  :visitor_id, presence: true

  before_validation :set_formatted_date_and_time, on: :create

  scope :today, -> { where(date: Date.today) }
  scope :this_week, -> { where(date: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :this_month, -> { where(date: Date.today.beginning_of_month..Date.today.end_of_month) }

  def status
    exit_time.present? ? "Finalizada" : "Em andamento"
  end

  private

  def set_formatted_date_and_time
    self.entry_date = Date.current.strftime('%d/%m/%Y')
    self.entry_time = Time.current.strftime('%H:%M:%S')
  end

end
