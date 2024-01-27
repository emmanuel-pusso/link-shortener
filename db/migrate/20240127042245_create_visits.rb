class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.belongs_to :link, null: false, foreign_key: { on_delete: :cascade }
      t.date :visited_at
      t.string :ip_address

      t.timestamps
    end
  end
end
