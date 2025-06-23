class UserMock
  def initialize
    create(name: 'John Doe', email: 'hZ6Ys@example.com', password: 'password')
  end

  def create(attributes)
    @user = User.new(attributes)
    @user.save!
  end
end
