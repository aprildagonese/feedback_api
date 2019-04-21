Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'surveys', to: 'surveys#create'
    end
  end
end
