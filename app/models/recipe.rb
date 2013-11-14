class Recipe < ActiveRecord::Base
	belongs_to :collection
	
	def self.search_for(query)
		where('ingredient Like :query', query: "%#{query}%")
    end
end
