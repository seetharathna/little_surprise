class CategoriesController < ApplicationController
 
  def index
     #params[:search] ||= {}
     #params[:search][:conditions] ||= {}
     #params[:search][:conditions][:id] = params[:id] unless params[:id].blank?
     
     @search = Category.new_search(params[:search])
     if !params[:category_id].blank?
       @search.conditions.parent_id = params[:category_id] if params[:category_id]
       #sub_categories = Category.find_all_by_parent_id(params[:category_id])
       
       #if sub_categories.blank?
         #redirect_to  category_path(params[:category_id])
       #end
     else
       @search.conditions.id = params[:id] if params[:id]
     end
     
     @categories = @search.all
     @parent = Category.find_all_by_parent_id(nil)
     
     
     respond_to do |format|
       format.html {@banners = Banner.find(:all)
                    @wish_list = current_user.wish_list unless current_user.nil?
                    unless @wish_list.blank?
                       @items = @wish_list.categories(:order => 'desc created_at')
                    end
                   }
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }
       format.fbml{ ensure_authenticated_to_facebook 
                    @current_user = user rescue nil
                    @wish_list = @current_user.wish_list unless @current_user.nil?
                    @category = Category.find(params[:category_id]) rescue nil
                   
                    if !params[:category_id].blank?
                  
                      @links = [Category.find(params[:category_id])]             
                      @fb_categories = Category.find_all_by_parent_id(params[:category_id])
                      sub_categories = Category.find_all_by_parent_id(params[:category_id])
                      if sub_categories.blank?
                        redirect_to  category_path(params[:category_id])
                      end
                    else
                      @fb_categories = Category.find_all_by_parent_id(nil)
                    end
                    @category_ids = []
                     @category_ids = @wish_list.categories.collect { | h|  h.id } unless @wish_list.nil?
                   }
     end
  end


  def show
    @category = Category.find(params[:id])
    @child = Category.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
      format.fbml {ensure_authenticated_to_facebook 
                    @current_user = user rescue nil
                    @wish_list = @current_user.wish_list unless @current_user.nil?
                    #@category = Category.find(params[:category_id]) rescue nil
                   


                    if !params[:id].blank?
                       @links = [] 
                       if @category.parent_id.blank?
                          @links += params[:links] if params[:links]                  
                          @links << Category.find(params[:id]).id if params[:id]
                          puts "sssssssssssssssssssssssssssssssssssssssssssssss"
                       else
                          puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr #{@child.parent_id}"
                        while !@child.parent_id.blank?
                          parent = Category.find_by_parent_id(@child.parent_id)
                          @links += parent if params[parent]
                          @child = parent
                         end
                       end  
                     
                      @fb_categories = Category.find_all_by_parent_id(params[:id])
                      #sub_categories = Category.find_all_by_parent_id(params[:category_id])
                      #if sub_categories.blank?
                        #redirect_to  category_path(params[:category_id])
                      #end
                     #else
                      #@fb_categories = Category.find_all_by_parent_id(nil)
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
      end
    end
end
