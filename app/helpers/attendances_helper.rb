module AttendancesHelper
  
  def attendance_started_at(attendance)
    if Date.current == attendance.worked_on
      return "出社" if attendance.started_at.nil?
    else
      false
    end
  end
  
  def attendance_finished_at(attendance)
    if Date.current == attendance.worked_on
      return "退社" if attendance.started_at.present? && attendance.finished_at.nil?
    else
      false
    end
  end
  
  def working_time(finish, start)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def total_working_time(str_times)
    format("%.2f",total_working_time = total_working_time.to_f + str_times.to_f)
  end
  
  def worked_on_sum
    @worked_on_sum = @attendances.where.not(started_at: nil).count
  end
  
  def wday_color(wday)
    if wday == 0
      @color = "text-danger"
    elsif wday == 6
      @color = "text-primary"
    else
      @color = "text-default"
    end
  end

end
