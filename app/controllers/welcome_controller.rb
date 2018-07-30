class WelcomeController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index,:unconfirmed , :confirmed]
  def index

  end
  def confirmed

  end
  def unconfirmed

  end
  def admin

  end
end
