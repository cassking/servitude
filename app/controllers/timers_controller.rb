class TimersController < ApplicationController
  def show
    @tasks = Task.all
  end

  def start_task
    Task.find!(params[:task_id])
    current_user.start_task(params[:task_id])
    redirect_to action: :show
  end

  def stop_task
    #TimeKeeper.stop_task_for(current_user)
    redirect_to action: :show
  end
end
