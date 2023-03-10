class YoteisController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @yotei = Yotei.find(params[:id])
    teigi
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @yotei = Yotei.find(params[:id])
    @yotei.destroy
    redirect_to user_path(@user), notice: "予定を削除しました"
  end
  
  def update
    @user = User.find(params[:user_id])
    @yotei = @user.yoteis.find(params[:id])
    if params[:yotei][:yoteikaishi_u] != '' && params[:yotei][:yoteikaishi_time_u] != '' && params[:yotei][:yoteiowari_u] != '' && params[:yotei][:yoteiowari_time_u] != ''
      ykdatetime_str = "#{params[:yotei][:yoteikaishi_u]} #{params[:yotei][:yoteikaishi_time_u]}:00"
      ykdatetime = Time.zone.parse(ykdatetime_str)
      yodatetime_str = "#{params[:yotei][:yoteiowari_u].to_date} #{params[:yotei][:yoteiowari_time_u]}"
      yodatetime = Time.zone.parse(yodatetime_str)
      if yodatetime < ykdatetime
        flash.now[:alert] = "終了時刻は開始時刻より後にしてください"
        render :show
      else
        @yotei.yoteikaishi = ykdatetime
        @yotei.yoteiowari = yodatetime
        @yotei.update(yotei_params)
        redirect_to user_yotei_path(@user, @yotei), notice: "変更しました"
      end
    else
      flash.now[:alert] = "全ての情報を入力してください"
        render :show
    end
  end
  
  def new
    @user = User.find(params[:user_id])
    @yotei = @user.yoteis.new
    teigi
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'ユーザーが見つかりませんでした'
  end

  def create
    @user = User.find(params[:user_id])
    if params[:yotei][:yoteikaishi] != '' && params[:yotei][:yoteikaishi_time] != '' && params[:yotei][:yoteiowari] != '' && params[:yotei][:yoteiowari_time] != ''
      ykdatetime_str = "#{params[:yotei][:yoteikaishi].to_date} #{params[:yotei][:yoteikaishi_time]}"
      ykdatetime = Time.zone.parse(ykdatetime_str)
      yodatetime_str = "#{params[:yotei][:yoteiowari].to_date} #{params[:yotei][:yoteiowari_time]}"
      yodatetime = Time.zone.parse(yodatetime_str)
      @yotei = @user.yoteis.new(yoteikaishi: ykdatetime, yoteiowari: yodatetime, user_id: @user.id)
      if @yotei.yoteiowari < @yotei.yoteikaishi
        flash.now[:alert] = "終了時刻は開始時刻より後にしてください"
        render :new
      elsif @yotei.save
        redirect_to user_yotei_path(@user, @yotei), notice: "作成しました"
      end
    else
      flash.now[:alert] = "全ての情報を入力してください"
      render :new
    end
  end
  
  private
  
  def teigi
    @yoteikaishi = Time.zone.today
    @yoteikaishi_time = Time.zone.now
    @yoteiowari = Time.zone.today
    @yoteiowari_time = Time.zone.now
  end
  
  def yotei_params
    params.require(:yotei).permit(:yoteikaishi, :yoteikaishi_time, :yoteiowari, :yoteiowari_time)
  end

end