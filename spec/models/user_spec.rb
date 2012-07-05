require 'spec_helper'

describe User do
  before { @user = User.new(name: "Test User", email: "test@example.com",
                            password: "password", 
                            password_confirmation: "password") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should be_valid }

  describe "when name/email are not present" do
  	before { @user.update_attributes(name: '', email: '')}

  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = 'a'*51 }

  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |address| 
      	@user.email = address
      	@user.should_not be_valid
      end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		@user_with_same_email = @user.dup
      @user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "email address is downcased before save" do
  	before do 
  		@user.email = "FOO@BAR.COM"
  		@user.save
  	end

  	its(:email) { should == "foo@bar.com" }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = ''}

    it { should_not be_valid }
  end

  describe "when password has mismatch" do
    before { @user.password_confirmation = "mismatch" } 

    it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil}

    it { should_not be_valid }
  end

  describe "authenticating the user" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email)}

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      it { should_not == found_user.authenticate("invalid") }
    end
  end

  describe "remember token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end
  
end
