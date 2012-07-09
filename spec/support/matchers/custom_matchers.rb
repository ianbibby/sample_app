module SampleApp

	module Spec

		module Matchers

			%w(error success warn notify).each do |t|
				RSpec::Matchers.define "have_#{t}_message".to_sym do |message|
				  match do |page|
				    page.should have_selector("div.alert.alert-#{t}", text: message)
				  end
				end
			end
			
		end

	end

end