require 'yaml'

raw_config = File.read("#{Rails.root}/config/mail.yml")
MAIL_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

Weightbot::Application.configure do
  config.action_mailer.smtp_settings = {
    address:              MAIL_CONFIG[:address],
    port:                 MAIL_CONFIG[:port],
    domain:               MAIL_CONFIG[:domain],
    user_name:            MAIL_CONFIG[:user_name],
    password:             MAIL_CONFIG[:password],
    authentication:       MAIL_CONFIG[:authentication],
    enable_starttls_auto: MAIL_CONFIG[:enable_starttls_auto]
  }
end
