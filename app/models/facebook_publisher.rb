class FacebookPublisher < Facebooker::Rails::Publisher

def publish_battle_template

 one_line_story_template "{*actor*} {*result*} {*category*}" +
                        "  {*defender*}  ."


 end

def publish_battle(category,facebook_session)
 send_as :user_action
 from facebook_session
 data:images=>[image(image_path("#{category.avatar.url(:thumb)}"),fb_categories_url)],
     :result=>"has added" ,
     :category=>category.name,
     :defender=> "to wishlist"
     
end

 def publish_stream(user_with_session_to_use, user_to_update)
      send_as :publish_stream
      from  user_with_session_to_use
      target user_to_update
      message "has updated the  wishlist"
         
end
 
 def profile_update(user)
  send_as :profile
  recipients user
  profile "This is a test"
end


def news_feed(recipients, title, body)
  send_as :story
  self.recipients(Array(recipients))
  title = title[0..60] if title.length > 60
  body = body[0..200] if body.length > 200
  self.body( body )
  self.title( title )
  
end

def notification_email(user,friends,date)
    send_as :email
    recipients friends
    from user                       
    title "Birthday reminder"
    fbml  <<-MESSAGE                    
  	  <fb:fbml> 
         #{user.name}'s birthday is on #{date.strftime("%B #{date.day.ordinalize}")} <br/><br/>

        Click here to view #{user.name}'s wishlist http://apps.facebook.com/littlesurprizes/wish_lists/#{WishList.find_by_user_id(user.id).id rescue nil}
         
  	  </fb:fbml>
  	MESSAGE
 end
  
  

    
    
    


end
