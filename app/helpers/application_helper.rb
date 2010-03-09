# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def admin?
     current_user && current_user.has_role?(:admin)
  end

  def find_category(name)
    category = Category.find_by_name(name) rescue nil
    return  category
  end

end
