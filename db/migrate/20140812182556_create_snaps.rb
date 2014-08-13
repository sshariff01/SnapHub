class CreateSnaps < ActiveRecord::Migration
  def change
    create_table :snaps do |t|
      t.string :media_id
      t.string :media_type
      t.string :media_url
      t.string :caption, limit: 50

      t.timestamps
    end
  end
end
