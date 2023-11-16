class AddIndexToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_index :api_keys, :access_token
  end
end
