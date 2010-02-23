class FbCategoriesController < ApplicationController
#ensure_authenticated_to_facebook  


# Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_attr :current_user
  # END:HELPER_ATTR

  attr_accessor :current_user
  before_filter :set_current_user

  # START:CURRENT_USER
  def set_current_user
    set_facebook_session
    # if the session isn't secured, we don't have a good user id
    #if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
     # self.current_user = User.for(facebook_session.user.to_i,facebook_session) 
    #end
  end
  # END:CURRENT_USER
 
 


 def index
  @wish_list = WishList.find(:first,:conditions => ["facebook_id =?",facebook_session.user.to_i])
  if !params[:category_id].blank?
     @categories = Category.find_all_by_parent_id(params[:category_id])
  else
     @categories = Category.find_all_by_parent_id(nil)
  end
  @category_ids = []
  @category_ids = @wish_list.categories.collect { | h|  h.id } unless @wish_list.nil?
 end

 

end
