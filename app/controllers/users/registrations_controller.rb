class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      # ユーザーが新規作成された後に呼ばれる処理
      if User.count == 1 || User.where(roll: 2).count.zero?
        resource.roll = 2
        resource.save
      end
    end
  end
end