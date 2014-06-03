class Admin::SettingsController < Admin::BaseController

  def index
  end

  def update
    settings = params[:settings]
    settings.keys.each do |key|
      Setting[key] = settings[key]
    end
    redirect_to admin_settings_path
  end

end
