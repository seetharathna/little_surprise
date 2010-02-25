class Admin::CategoriesController < ApplicationController
 
before_filter :check_logged_in
before_filter :check_admin,:except => :index
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
        format.html { redirect_to(admin_categories_path) }
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
        format.html { redirect_to(admin_categories_path) }
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
      format.html { redirect_to(admin_categories_url) }
      format.xml  { head :ok }
    end
  end


 def subcategory_new
  @category = Category.new
  @parent = Category.find_all_by_parent_id(nil)
 end

 

 

 
  
end
