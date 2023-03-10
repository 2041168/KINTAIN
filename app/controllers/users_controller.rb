class UsersController < ApplicationController
  
  def index
    #全てのユーザーのデータを持ってくる
    @users = User.all
  end

  def show
    #一人のユーザーのデータを持ってくる
    @user = User.find(params[:id])
  end

  def edit
    #一人のユーザーのデータを持ってくる
    @user = User.find(params[:id])
    #全てのユーザーのデータを持ってくる
    @users = User.all
  end
  
  def update
    #一人のユーザーのデータを持ってくる
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_back fallback_location: root_path, notice: "更新しました"
  end
  
  #データ保護
  private
  def user_params
    params.require(:user).permit(:username,:email,:roll,:kinmu)
  end
end
