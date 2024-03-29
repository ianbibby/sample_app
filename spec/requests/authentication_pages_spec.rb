require 'spec_helper'

describe "Authentication pages" do
	
	subject { page }

	describe "signin" do
		before { visit signin_path }

		it { should have_selector "title", text: "Sign in" }
		it { should have_selector "h1", text: "Sign in" }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_selector "title", text: "Sign in" }
			it { should have_error_message 'Invalid' }

			describe "remembers email address between attempts" do
				before do
					fill_in 'email', with: 'foo@example.com'
					click_button "Sign in"
				end

				it { should have_field "email", with: "foo@example.com" }
			end

			describe "does not show signed in links" do
				it { should_not have_link "Profile" }
				it { should_not have_link "Settings" }
				it { should_not have_link "Sign out" }	
				it { should have_link "Sign in" }	
			end

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message 'Invalid' }				
			end
			
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in(user)
			end

			it { should have_selector "title", text: user.name }
			it { should have_link "Users", href: users_path }
			it { should have_link "Profile", href: user_path(user) }
			it { should have_link "Settings", href: edit_user_path(user) }
			it { should have_link "Sign out", href: signout_path }
			it { should_not have_link "Sign in", href: signin_path }

			describe "followed by signout" do
				before { click_link "Sign out" }

				it { should have_link "Sign in", href: signin_path }
			end

		end
	end

	describe "authorization" do

		describe "for non-signed in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector "title", text: "Sign in" }
				end

				describe "updating the profile" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "when attempting to view a protected page" do
					before do
					  visit edit_user_path(user)
					  fill_in "Email", with: user.email
					  fill_in "Password", with: user.password
					  click_button "Sign in"
					end

					describe "after signing in" do
						it { should have_selector "title", text: "Edit user" }
					end
					
				end

				describe "visiting the user index page" do
					before { visit users_path }

					it { should have_selector "title", text: "Sign in" }
				end

				describe "deleting a user" do
					before { delete user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end

			describe "as wrong user" do
				let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }				
				before { sign_in(user) }

				describe "visiting edit page" do
					before { get edit_user_path(wrong_user) }
					specify { response.should redirect_to(root_path) }
				end

				describe "submitting update" do
					before { put user_path(wrong_user) }
					specify { response.should redirect_to(root_path) }
				end

			end

			describe "as a non-admin user" do
				let(:user) { FactoryGirl.create(:user) }
				let(:non_admin) { FactoryGirl.create(:user) }

				before do
					sign_in non_admin
				end

				describe "attempting to delete a user" do
					before { delete user_path(user) }				
					specify { response.should redirect_to(root_path) }
				end			
				
			end
			
		end
		
	end
end