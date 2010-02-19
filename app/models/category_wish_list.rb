class CategoryWishList < ActiveRecord::Base
belongs_to :categories
belongs_to :wish_lists
end
