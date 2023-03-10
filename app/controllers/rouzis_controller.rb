class RouzisController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    @yoteis = @user.yoteis.all
    @rouzis = @user.rouzis.where.not(zitsukaishi: nil).where.not(zitsuowari: nil)
    
    # 絞り込み範囲の指定
    @kensakukaishi = params.dig(:kensakukaishi)&.to_date || Time.zone.today
    @kensakuowari = params.dig(:kensakuowari)&.to_date || 30.days.from_now.to_date
    @kk = @kensakukaishi.to_datetime.beginning_of_day
    @ko = @kensakuowari.to_datetime.end_of_day
    
    if @kensakuowari < @kensakukaishi
        flash.now[:alert] = "終了日は開始日より後にしてください"
        @data = {}
        @yotei_total = 0
        @rouzi_total = 0
        @diff = 0
        render :index
    end
    
    # 範囲内の予定と労働時間の取得
    yoteis = @yoteis.select { |y| y.yoteikaishi >= @kk && y.yoteikaishi <= @ko }
    rouzis = @rouzis.select { |r| r.zitsukaishi >= @kk && r.zitsukaishi <= @ko }
    @yoteide = yoteis
    
    
    # 日付ごとに予定と労働時間をグループ化
    @data = {}
    (@kensakukaishi..@kensakuowari).each do |date|
      # dateと日付が同じ予定を取得
      yotei_data = yoteis.select { |y| y.yoteikaishi.to_date == date }
      yotei = yotei_data.map { |y| { id: y.id, time: "#{y.yoteikaishi.strftime('%-H:%M')}~#{y.yoteiowari.strftime('%-H:%M')}" } }
    
      # dateと日付が同じ労働を取得
      rouzi_data = rouzis.select { |r| r.zitsukaishi.to_date == date }
      rouzi = rouzi_data.map { |r| { id: r.id, time: "#{r.zitsukaishi.strftime('%-H:%M')}~#{r.zitsuowari.strftime('%-H:%M')}" } }
    
      # データの格納
      @data[date] = { yotei: yotei, rouzi: rouzi }
    end
  
    # 合計時間の計算
    @yotei_total = yoteis.sum { |y| y.yoteiowari - y.yoteikaishi }
    @rouzi_total = rouzis.sum { |r| r.zitsuowari - r.zitsukaishi }
    diff_minutes = (@rouzi_total - @yotei_total) / 60
    diff_hours = diff_minutes / 60
    diff_minutes = diff_minutes % 60
    @diff = sprintf("%02d時間%02d分", diff_hours, diff_minutes)
    y_minutes = @yotei_total / 60
    y_hours = y_minutes / 60
    y_minutes = y_minutes % 60
    @yotei_total = sprintf("%02d時間%02d分", y_hours, y_minutes)
    r_minutes = @rouzi_total / 60
    r_hours = r_minutes / 60
    r_minutes = r_minutes % 60
    @rouzi_total = sprintf("%02d時間%02d分", r_hours, r_minutes)
    
  end

  def show
    @user = User.find(params[:user_id])
    @rouzi = Rouzi.find(params[:id])
    teigi
  end
    
  def destroy
    @user = User.find(params[:user_id])
    @rouzi = Rouzi.find(params[:id])
    @rouzi.destroy
    redirect_to user_path(@user), notice: "実績を削除しました"
  end
  
  def update
    @user = User.find(params[:user_id])
    @rouzi = @user.rouzis.find(params[:id])
    if params[:rouzi][:zitsukaishi_u] != '' && params[:rouzi][:zitsukaishi_time_u] != '' && params[:rouzi][:zitsuowari_u] != '' && params[:rouzi][:zitsuowari_time_u] != ''
      zkdatetime_str = "#{params[:rouzi][:zitsukaishi_u]} #{params[:rouzi][:zitsukaishi_time_u]}:00"
      zkdatetime = Time.zone.parse(zkdatetime_str)
      zodatetime_str = "#{params[:rouzi][:zitsuowari_u].to_date} #{params[:rouzi][:zitsuowari_time_u]}"
      zodatetime = Time.zone.parse(zodatetime_str)
      if zodatetime < zkdatetime
        flash.now[:alert] = "終了時刻は開始時刻より後にしてください"
        render :show
      else
        @rouzi.zitsukaishi = zkdatetime
        @rouzi.zitsuowari = zodatetime
        @rouzi.update(rouzi_params)
        redirect_to user_rouzi_path(@user, @rouzi), notice: "変更しました"
      end
    else
      flash.now[:alert] = "全ての情報を入力してください"
      render :show
    end
  end
  
  def new
    @user = User.find(params[:user_id])
    #teigi
    @rouzi = @user.rouzis.new
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'ユーザーが見つかりませんでした'
  end

  def create
    @user = User.find(params[:user_id])
    if params[:rouzi][:zitsukaishi].present? && params[:rouzi][:zitsukaishi_time].present? && params[:rouzi][:zitsuowari].present? && params[:rouzi][:zitsuowari_time].present?
      #zkt = Time.zone.parse(params.dig(:zitsukaishi_time))
      #zot = Time.zone.parse(params.dig(:zitsuowari_time))
      zkdate_str = params[:rouzi][:zitsukaishi].strftime('%Y-%m-%d')
      zktime_str = params[:rouzi][:zitsukaishi_time].strftime('%H:%M')
      zkdatetime_str = "#{ zkdate_str } #{ zktime_str }"
      zkdatetime = DateTime.parse(zkdatetime_str)
      
      zodate_str = params[:rouzi][:zitsuowari].strftime('%Y-%m-%d')
      zotime_str = params[:rouzi][:zitsuowari_time].strftime('%H:%M')
      zodatetime_str = "#{ zodate_str } #{ zotime_str }"
      zodatetime = DateTime.parse(zodatetime_str)

      if zodatetime < zkdatetime
        flash.now[:alert] = "終了時刻は開始時刻より後にしてください"
        render :new
      else
        @rouzi = @user.rouzis.new(zitsukaishi: zkdatetime, zitsuowari: zodatetime, user_id: @user.id)
        @rouzi.save
        redirect_to user_rouzi_path(@user, @rouzi), notice: "作成しました"
      end
    else
      flash.now[:alert] = "全ての情報を入力してください"
      render :new
    end
  end
  
  private
  
  def teigi
    @zitsukaishi = Time.zone.today
    @zitsukaishi_time = Time.zone.now
    @zitsuowari = Time.zone.today
    @zitsuowari_time = Time.zone.now
  end
  
  def rouzi_params
    params.require(:rouzi).permit(:zitsukaishi, :zitsukaishi_time, :zitsuowari, :zitsuowari_time)
  end
  
end
