class TimersController < ApplicationController
  def show
    @tasks = Task.all
    @current_task = TimeEntry.current_task_for(current_user.id)
    @recent_entries = TimeEntry.recent_for(current_user.id)
  end

  def start_task
    TimeEntry.start_task(current_user.id, params[:task_id])
    redirect_to action: :show
  end

  def stop_task
    TimeEntry.stop_task(current_user.id)
    redirect_to action: :show
  end
end
