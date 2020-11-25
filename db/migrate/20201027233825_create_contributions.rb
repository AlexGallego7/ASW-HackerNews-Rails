class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.string :text
      t.integer :user_id
      
      t.timestamps
    end
  end
end
