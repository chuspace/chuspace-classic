class EnableUuidExtension < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'uuid-ossp'
  end

  def down
    disable_extension 'uuid-ossp'
  end
end
