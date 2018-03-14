MY_APP = YAML.load(File.read "#{Rails.root}/config/my_app.yml")[Rails.env].symbolize_keys
