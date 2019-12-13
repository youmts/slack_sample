class CreateSlackEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_events do |t|
      t.string :user
      t.string :channel
      t.text :message
      t.datetime :ts

      t.timestamps
    end
  end
end
