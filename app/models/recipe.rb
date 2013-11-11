class Recipe < ActiveRecord::Base
	def self.search_for(query)
		where('ingredient Like :query', query: "%#{query}%")
    end
end
