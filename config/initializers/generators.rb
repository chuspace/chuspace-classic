# frozen_string_literal: true

# Reduce generator noise
Rails.application.configure do
  config.generators do |generate|
    generate.orm :active_record, primary_key_type: :uuid
    generate.helper false
    generate.assets false
    generate.view_specs false
    generate.channel assets: false
  end
end
