module ApplicationHelper
	include Pagy::Frontend

	def pagination(obj)
		raw(pagy_bootstrap_nav(obj)) if @pagy.pages > 1
	end

	def full_title(page_title = "")
		base_title = "Ruby on Rails Sample App"
		page_title.present? ? "#{page_title} | #{base_title}" : base_title
	end
end
