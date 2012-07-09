namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!( name: "Example Admin",
													email: "admin@example.com",
													password: "password",
													password_confirmation: "password")
		admin.toggle!(:admin)
		
		User.create!(	name: "Example user",
									email: "example_user@example.com",
									password: "password",
									password_confirmation: "password")
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "foobar"
			User.create!( name: name,
										email: email,
										password: password,
										password_confirmation: password)
		end
	end
end