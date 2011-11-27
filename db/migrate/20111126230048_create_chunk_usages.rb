class CreateChunkUsages < ActiveRecord::Migration
  def change
    create_table :chunks_chunk_usages do |t|
      t.references :chunk, null: false
      t.references :page, null: false
      t.string :container_key, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
