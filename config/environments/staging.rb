Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'http://staging-enigmatic-crag-3918.herokuapp.com' }
  config.action_mailer.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'http://enigmatic-crag-3918.heroku.com',
  :authentication => :plain
  }

  ENV["DATABASE_URL"] = 'postgres://ipbfpwyadsofia:HGTB26cSgbIwJYKbp_xfnT8dGf@ec2-54-197-245-93.compute-1.amazonaws.com:5432/delq2l6p630gq7'
end