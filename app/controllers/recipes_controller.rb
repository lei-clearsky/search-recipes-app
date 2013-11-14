class RecipesController < ApplicationController
	before_filter :authenticate_user!

	def index
	end

	def search
		@recipe = params[:ingredient]
		base_endpoint_url = "http://api.yummly.com/v1/api/recipes?_app_id=#{ENV['APP_ID']}&_app_key=#{ENV['APP_KEY']}&maxResult=50&"
		#base_endpoint_url = "http://api.yummly.com/v1/api/recipes?_app_id=bc196f8d&_app_key=959d599a14211e9c9afd49bd0f43cdcf&maxResult=50&"     
	    
	    if @recipe.include? ","
	    	ingredients = @recipe.split(",").map {|ingredient| ingredient.strip }
	    else
	    	ingredients = @recipe.split
	    end

	    url_safe_ingredients = ingredients.inject(String.new) { |safe_url, ingredient| safe_url << "allowedIngredient[]=#{ingredient}&" }
		compiled_url = base_endpoint_url + url_safe_ingredients
		formatted_url = compiled_url.gsub(/&$/, '')
		response = RestClient.get(formatted_url)

		parsed_response = JSON.parse(response)
		@recipes = parsed_response["matches"].sort_by { |response| response["ingredients"].count }
		@recipe_image = ""
	end

	def save_to_collection
		current_user.build_collection if current_user.collection.nil?
		current_user.save
		current_user.collection.recipes.create(name: params["name"], image_url: params["image_url"], ingredient: params["ingredient"], instruction_url: params["instruction_url"])
		current_user.save
		redirect_to collection_path
	end

	def remove_recipe
		@recipe = current_user.collection.recipes.find(params[:id])
		@recipe.destroy

		redirect_to collection_path
	end

	private

	def safe_recipe_params
	    params.require('recipe').permit(:ingredient)
	end
end

