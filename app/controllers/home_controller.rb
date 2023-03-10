class HomeController < ApplicationController
  
  def index
    if user_signed_in?
      @user = current_user
    end
  end
  
  def custom_method
    if user_signed_in?
      @user = current_user
      if @user.kinmu == 2 # 出勤状態から退勤
        @rouzi = @user.rouzis.order("created_at DESC").where(zitsuowari: nil).first
        nowday = Time.zone.today
        nowtime = Time.zone.now
        nowdatetime_str = "#{nowday.to_date} #{nowtime}"
        nowdatetime = Time.zone.parse(nowdatetime_str)
        @rouzi.update(zitsuowari: nowdatetime)
        @user.update_attribute(:kinmu, 1)
        redirect_back fallback_location: root_path, notice: "退勤しました"
      else # 退勤状態から出勤
        nowday = Time.zone.today
        nowtime = Time.zone.now
        nowdatetime_str = "#{nowday.to_date} #{nowtime}"
        nowdatetime = Time.zone.parse(nowdatetime_str)
        @user.rouzis.create(zitsukaishi: nowdatetime, user_id: @user.id)
        @user.update_attribute(:kinmu, 2)
        redirect_back fallback_location: root_path, notice: "出勤しました"
      end
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username,:email,:roll,:kinmu)
  end
end