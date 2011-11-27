class CreateChunks < ActiveRecord::Migration
  def change
    create_table :chunks_chunks do |t|
      t.string  :type, null: false
      t.string  :title
      t.text    :content
      t.text    :extra_attributes
      t.timestamps
    end
  end
end
