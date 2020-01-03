require 'csv'

CSV.generate do |csv|
  column_names = %w(started_at finished_at)
  csv << column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.started_at,
      attendance.finished_at
    ]
    csv << column_values
  end
end