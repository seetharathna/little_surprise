class CategoriesController < ApplicationController
 
  def index
     params[:search] ||= {}
     params[:search][:conditions] ||= {}
     params[:search][:conditions][:id] = params[:id] unless params[:id].blank?
     @search = Category.new_search(params[:search])
     @categories = @search.all
     @parent = Category.find_all_by_parent_id(nil)
     respond_to do |format|
       format.html # index.html.erb 
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }
       format.fbml{ ensure_authenticated_to_facebook 
                    set_current_user
                    @wish_list = user.wish_list
                    if !params[:category_id].blank?
                      @fb_categories = Category.find_all_by_parent_id(params[:category_id])
                    else
                      @fb_categories = Category.find_all_by_parent_id(nil)
                    end
                    @category_ids = []
                     @category_ids = @wish_list.categories.collect { | h|  h.id } unless @wish_list.nil?
                   }
     end
  end

  private
    def set_current_user
      set_facebook_session
      #if the session isn't secured, we don't have a good user id
      if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
        User.for(facebook_session.user.to_i,facebook_session) 
      end
    end


    def user
      unless facebook_session.blank?
        User.find_or_create_by_facebook_id(facebook_session.user.to_i) rescue nil?
      #else
        #current_user
      #end
    end
end
