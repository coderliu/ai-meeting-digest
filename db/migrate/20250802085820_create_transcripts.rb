class CreateTranscripts < ActiveRecord::Migration[8.0]
  def change
    create_table :transcripts do |t|
      t.string :input
      t.string :output
      t.uuid :uuid, default: -> { "gen_random_uuid()" }
      t.integer :status

      t.timestamps
    end
    add_index :transcripts, :uuid
  end
end
