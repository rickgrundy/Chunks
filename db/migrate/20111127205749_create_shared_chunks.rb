class CreateSharedChunks < ActiveRecord::Migration
  def change
    create_table :chunks_shared_chunks do |t|
      t.references :chunk, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
