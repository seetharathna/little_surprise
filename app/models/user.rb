class User < ActiveRecord::Base
  acts_as_authentic do |c|


  
    #c.validate_login_field = false
    #c.validate_crypted_password = false
  end

  has_and_belongs_to_many :roles


def has_role?(role)
    list ||= self.roles.collect(&:name)
    list.include?(role.to_s) || list.include?('admin')
end

def before_connect(facebook_session)
    self.name = facebook_session.user.name
end

end
