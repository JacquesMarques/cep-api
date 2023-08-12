class CreateAccessTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :access_tokens do |t|
      t.string :token_digest
      t.references :user, null: false, foreign_key: true
      t.references :api_key, null: true, foreign_key: true
      t.timestamp :accessed_at

      t.timestamps
    end
  end
end
