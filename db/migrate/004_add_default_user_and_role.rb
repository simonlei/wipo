class AddDefaultUserAndRole < ActiveRecord::Migration
  def self.up
  end 
  def nothing
    role = Role.new
    role.title = 'Admin'
    role.save

    user = User.new
    user.login = 'Admin'
    user.update_password 'password'
    user.email = 'root@localhost'
    # the next line is essential
    user.state = User.states['confirmed'] 
    user.save

    user.roles << role
    user.save
  end

  def self.down
    User.delete_all "login='Admin'"
    Role.delete_all "title='Admin'"
  end
end
