class CategoriesController < ApplicationController
 
#before_filter :check_logged_in
#helper_attr :current_user
#attr_accessor :current_user
before_filter :check_admin,:except => :index #:set_current_user,
  
   #def set_current_user
    #set_facebook_session
    # if the session isn't secured, we don't have a good user id
    #if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
     # self.current_user = User.for(facebook_session.user.to_i,facebook_session) 
    #end
  #end
  # END:CURRENT_USER
 



  # GET /categories
  # GET /categories.xml


 
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
       format.fbml { ensure_authenticated_to_facebook 
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

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(categories_path) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end


 #def subcategory_new
  #@category = Category.new
  #@parent = Category.find_all_by_parent_id(nil)
 #end

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
      User.find_or_create_by_facebook_id(facebook_session.user.to_i)
    else
      current_user
    end
  end
 
  
end
