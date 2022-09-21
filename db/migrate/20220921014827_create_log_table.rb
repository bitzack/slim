class CreateLogTable < ActiveRecord::Migration[7.0]
  def up
    create_table :logs do |t|
      t.string :url
      t.text :headers
      t.text :request
      t.text :response  
      t.timestamps
    end
  end
  def down
    drop_table :logs
  end
end
