class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :image_url
      t.string :ingredient
      t.string :instruction_url
      t.integer :collection_id
      t.integer :user_id

      t.timestamps
    end
  end
end
