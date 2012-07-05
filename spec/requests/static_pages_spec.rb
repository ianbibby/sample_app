require 'spec_helper'

describe "Static pages" do

	let(:base_title) { 'Sample App' }

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector 'title', text: page_title }
		it { should have_selector 'h1', text: page_heading }
	end

	describe "Home page" do
		before { visit home_path }
		let(:page_title) { base_title }
		let(:page_heading) { base_title }

		it_should_behave_like "all static pages"
		it { should_not have_selector 'title', text: "| Home" }
		it { should have_link "Sign in", href: signin_path }
	end

	describe "Help page" do
		before { visit help_path }
		let(:page_title) { "#{base_title} | Help" }
		let(:page_heading) { "Help" }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }
		let(:page_title) { "#{base_title} | About Us" }
		let(:page_heading) { "About Us" }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let(:page_title) { "#{base_title} | Contact Us" }
		let(:page_heading) { "Contact Us" }

		it_should_behave_like "all static pages"
	end

	describe "Layout" do
		before { visit root_path }

		it "should have the correct links" do
			click_link "Help"
			current_path.should eq(help_path)
			click_link "About"
			current_path.should eq(about_path)
			click_link "Contact"
			current_path.should eq(contact_path)
		end
	end

end