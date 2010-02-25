class UserSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    
    @user_session = UserSession.new(params[:user_session])
    

    if @user_session.save

      if current_user.has_role?(:admin)
         redirect_to  admin_categories_path   
      else
          #puts "ppppppppppppppppppppppp #{current_user.wish_list}"
         if current_user.wish_list.blank?
           redirect_to  categories_path   
         else
            redirect_to  wish_list_path(current_user.wish_list)
         end
      end
     
    
      #if facebook_session
         #flash[:notice] = "Facebook login successful!"
         #if WishList.wishlist(facebook_session.user.uid)
           #redirect_to  wish_list_path(WishList.wishlist(facebook_session.user.uid))
         #else
           # redirect_to  categories_path
        # end
      #else
         #flash[:notice] = "Login successful!"
        # redirect_to  wish_list_path(WishList.wishlist(facebook_session.user.uid))
     # end

     
      #flash[:notice] = "Login successful!"
      #redirect_to  categories_path
      #redirect_back_or_default account_url
    else
      render :action => :new
    end
  
  end
  
  def destroy
    current_user_session.destroy
    clear_facebook_session_information
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end

  def logout
    clear_facebook_session_information
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
