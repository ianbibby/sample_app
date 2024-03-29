module UsersHelper
	def gravatar_for(user, options = { size: 40 })
		gravatar_id = Digest::MD5::hexdigest user.email.downcase
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}&size=#{options[:size]}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
end
