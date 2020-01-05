require 'csv'
require 'date'

CSV.generate do |csv|
  column_names = %w(worked_on started_at finished_at)
  csv << column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.worked_on,
      csv_type(attendance.started_at),
      csv_type(attendance.finished_at)
    ]
    csv << column_values
  end
end