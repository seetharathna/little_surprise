class Category < ActiveRecord::Base
  #has_and_belongs_to_many :wishlists,:uniq => true
  #has_many :category_wish_lists
  #has_many :wish_lists,:through => :category_wish_lists
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "135x135>" }
  acts_as_tree :order => "name"
end
