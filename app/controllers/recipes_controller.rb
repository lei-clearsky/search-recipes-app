require 'json'
require 'rest-client'

class RecipesController < ApplicationController
	def index
	end

	def create
	    @recipe = Recipe.new(safe_recipe_params)
	    if @recipe.save
	      redirect_to @recipe
	    else
	      render :new
	    end
	end

	def new
	    @recipe = Recipe.new
	end

	def show
		@recipe = Recipe.find(params[:id])
		base_endpoint_url = "http://api.yummly.com/v1/api/recipes?_app_id=&_app_key=&maxResult=100&"     
		#base_endpoint_url = "http://api.yummly.com/v1/api/recipes?_app_id=#{ENV["APPLICATION_ID"]}&_app_key=#{ENV["APPLICATION_KEY"]}&"
	    
	    ingredients = @recipe.ingredent.split(",").map {|ingredient| ingredient.strip }
	    url_safe_ingredients = ingredients.inject(String.new) { |safe_url, ingredient| safe_url << "allowedIngredient[]=#{ingredient}&" }
		compiled_url = base_endpoint_url + url_safe_ingredients
		formatted_url = compiled_url.gsub(/&$/, '')
		response = RestClient.get(formatted_url)

		#escaped_jsonp = response.match(/(bq\.\ .*\(.*\);)(.*)/).catches[1]
		parsed_response = JSON.parse(response)
		@recipes = parsed_response["matches"].sort_by { |response| response["ingredients"].count }
	end

	private

	def safe_recipe_params
	    params.require('recipe').permit(:ingredent)
	end
end

