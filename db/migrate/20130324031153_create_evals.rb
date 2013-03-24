class CreateEvals < ActiveRecord::Migration
  def change
    create_table :evals do |t|
      t.string :name
      t.text :code

      t.timestamps
    end
  end
end
