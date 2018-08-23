require'SQL'
class PreferencesController < ApplicationController

  def transfer_reward
    flash[:danger] = "Not impelemented yet"
    redirect_to user_preferences_path
  end

  def generate_code
    if params[:package].to_i > 8 || params[:package].to_i < 1
      flash[:danger] = "invalid Package !"
      redirect_to user_preferences_path
    end
    # preparing values
    indx = params[:package].to_i
    silks = [0, 500, 1000, 2200, 3300, 5500, 11500, 18000, 25000]
    prices = [0, 5, 10, 20, 30, 50, 100, 150, 200]
    code = CouponCode.generate
    value = silks[indx]
    price = prices[indx]
    acc = SQL.connect_account
    user_info = acc[:TB_User].where(:StrUserID => current_user.username).all.last
    game_user_id = user_info[:jid]
    if current_user.pins < price
      flash[:danger] = "Insufficient Credits please recharge your account"
    else
      current_user.pins = current_user.pins - price
      current_user.save
      # inserting code
      acc[:_EPINS].insert(CreatorJID: game_user_id, Code15: code, PackageID: indx, SilkAmount: value, Cost: price, Date: DateTime.now)
      flash[:success] = "Code generated successfuly check history to see all your generated codes"
    end
    redirect_to user_preferences_path
  end

  def charge_code
    acc = SQL.connect_account
    user_info = acc[:TB_User].where(:StrUserID => current_user.username).all.last
    code = params[:code1] + "-" + params[:code2] + "-" + params[:code3]
    code = code.upcase
    game_user_id = user_info[:jid]

    exec = acc.call_mssql_sproc(:_AddSilkASYNCByWebEPIN, args: {:UserJID => game_user_id, :Code15 =>  code})

    returned_code = exec[:result]

    if returned_code == 1
      flash[:success] = "Code charged successfully"
    elsif returned_code == -1
      flash[:danger] = "User Does not exist ! please contact support"
    elsif returned_code == -2
      flash[:danger] = "Code Does not exist, make sure you have entered the correct code"
    elsif returned_code == -3
      flash[:danger] = "Charging code is already used, make sure you have entered the correct code"
    else
      flash[:danger] = "Unknown error occured please try again later"
    end

    redirect_to user_preferences_path

  end

end