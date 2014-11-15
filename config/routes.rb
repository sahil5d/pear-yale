Pear::Application.routes.draw do

	root 'static_pages#home'
	get '/profile', to: 'users#show'
	get '/finish',  to: 'users#finish'
	get '/logout',  to: 'users#logout'

	get '/planner',   to: 'openings#new'
	get '/openings',  to: 'openings#index'
	post '/openings', to: 'openings#create'



	# resources :openings
	# root 'prerelease#alpha'
	# post '/' => 'prerelease#signup'
	
	# rake routes

end
