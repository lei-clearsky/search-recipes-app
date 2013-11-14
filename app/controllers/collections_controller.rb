class CollectionsController < ApplicationController
	def index
		@collection = current_user.collection
	end
end