# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end

 ActionMailer::Base.smtp_settings = {

    :address => 'smtp.sendgrid.net',
    :port => '2525',
    :authentication => :plain,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => '35.242.177.24',
    :enable_starttls_auto => true
}