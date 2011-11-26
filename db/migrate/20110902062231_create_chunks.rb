class CreateChunks < ActiveRecord::Migration
  def change
    create_table :chunks_chunks do |t|
      t.string  :type
      t.integer :page_id
      t.string  :container_key
      t.string  :title
      t.text    :content
      t.text    :extra_attributes
      t.integer :position
      t.timestamps
    end
  end
end
