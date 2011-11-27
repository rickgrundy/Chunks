class CreatePages < ActiveRecord::Migration
  def change
    create_table :chunks_pages do |t|
       t.string   :template, null: false
       t.string   :title, null: false
       t.boolean  :public, default: false
       t.timestamps
     end
  end
end
