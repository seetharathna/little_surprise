class WishListsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :set_current_user,:only => [:delete, :edit]
  #before_filter :wish_list_exists,:only => [:new]

   def index
    @wish_lists =  WishList.find(:all, :conditions => { :user_id => user.id })
   end

  def show
    @wish_list = WishList.find(params[:id]) rescue nil
    unless @wish_list.blank?
      #@categories = @wish_list.categories(:order => 'desc created_at')
      #items = @wish_list.categories.map{|c| c.category_id}
     # @category =  items.last
    end

    @current_user = user rescue nil
  end

  def new
    @user = facebook_user
    @wish_list = WishList.new
    @current_user = user rescue nil
  end


  def edit
    @wish_list = WishList.find(params[:id])
    @current_user = user
    @wishlist_items = @wish_list.category_wish_lists.map{|c| c.category_id} rescue nil
    @parent = Category.find_all_by_parent_id(nil)

     respond_to do |format|
       format.html {
                   }
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }

     end

  end

  def create
    @user = facebook_user
    @wish_list = WishList.new(params[:wish_list])
    @wish_list.user = user

    if @wish_list.save
      flash.now[:notice] = "Wish list has been created successfully."
      redirect_to(wish_lists_path)
    else
      flash.now[:error] = "Make sure that all required fields are entered."
      @wish_list = nil
      render :action => 'new'
    end

  end


  def update
    @wish_list = WishList.find(params[:id])
    if @wish_list.update_attributes(params[:wish_list])
       CategoryWishList.delete_all(["wish_list_id = ?", @wish_list.id]) # delete CategoryWishList all records of wish_list using single step
       unless params[:categories].blank?
         params[:categories].each do |category_id|
           CategoryWishList.create({ :category_id => category_id ,:wish_list_id => @wish_list.id , :custom_description => params["category_#{category_id}_custom_description"] })
         end

       end
       flash[:notice] = 'Wish list was successfully updated.'
       redirect_to(wish_lists_path)
    else
       render :action => 'edit'
    end
  end


  def destroy
    @wish_list = WishList.find(params[:id])
    @wish_list.destroy
    redirect_to(wish_lists_path)
  end

  def add_to_wishlist
    @wish_list = user.wish_list
    category = Category.find(params[:category_id])

    unless @wish_list.blank?
      @wish_list.categories << category
      redirect_to(wish_list_path(@wish_list))
    else
      flash[:notice] = 'Please create wish list first.'
      redirect_to(new_wish_list_path)
    end
  end

  def publish_to_friends
    @wish_list = WishList.find(params[:id])
    @category = Category.find(params[:category])

    user = facebook_user
    if user.has_permissions?('publish_stream')
      user.publish_to(user, :message => 'has added new product categories to wishlist.',
      :action_links => [ :text => "#{user.name}'s wishlist",
                         :href => "http://apps.facebook.com/littlesurprizes/wish_lists/#{@wish_list.id}"
                       ],
       :attachment =>  { :name => "#{@category.name}",
                         :description => "#{@category.description}",
                         :media => [{ :type => 'image',
                               :src => "http://69.164.192.249:3012/#{@category.avatar.url(:thumb)}",
                               :href => "http://apps.facebook.com/littlesurprizes"}]
                       }
      )

      redirect_to(wish_list_path(@wish_list))
    else
      render :action => 'grant_permission'
    end
  end


  def grant_permission
  end

  def remove_category
    @wish_list =  user.wish_list
    @wish_list.categories.delete(Category.find(params[:id]))
    redirect_to(wish_list_path(@wish_list))
  end

  def category_list
  @categories = Category.all
  end


  def update_wishlist
   wish_list = WishList.find(params[:wish_list])
   @wishlist_items = CategoryWishList.find(:all, :conditions => { :wish_list_id => params[:wish_list] }) rescue nil
     categories = Category.find(params[:categories])
   if @wishlist_items
     @wishlist_items.each do |wish_list_item|
       wish_list_item.destroy
     end
   end

   categories.each do |category|
     categories_wishlist = CategoryWishList.find_or_create_by_wish_list_id_and_category_id(wish_list,category)
     categories_wishlist.wish_list_id = wish_list.id
     categories_wishlist.category_id = category.id
     categories_wishlist.custom_description = "desc"
     categories_wishlist.save
    end
     redirect_to (wish_list_categories_path(wish_list))
  end

private

  def owner_of_the_profile
    @wish_list = WishList.find(params[:id])
    if @wish_list.user == facebook_session.user.to_i
      return true
    else
      redirect_to(wish_list_path(@wish_list))
      flash[:error] = "you are not authorised to acess this page"
    end
  end

   def user
    user = User.find_by_facebook_id(facebook_session.user.to_i)
    user ||= set_current_user
   end

  def facebook_user
    facebook_session.user
  end

  def wish_list_exists
      if !user.wish_list.nil?
        flash[:notice] = "You can have only one wish list"
        redirect_to root_url
       end
    end


end

