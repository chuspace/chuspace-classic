# frozen_string_literal: true

# Reduce generator noise
Rails.application.configure do
  config.generators do |generate|
    generate.orm :active_record
    generate.helper false
    generate.assets false
    generate.view_specs false
    generate.controller_specs false
    generate.channel assets: false
  end
end
