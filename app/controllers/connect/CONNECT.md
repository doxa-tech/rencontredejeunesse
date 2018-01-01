# Old version of UsersController

```ruby
def show
  @current_partial = params[:partial] || "home"
end

def settings
  @current_partial = "settings"
  render 'show'
end

def shop
  @current_partial = "shop"
  render 'show'
end

def volunteer
  @current_partial = "volunteer"
  render 'show'
end

def goodies
  @current_partial = "goodies"
  render 'show'
end
```

# Old version of routes.rb

```ruby
root to: "users#show"
get 'settings', to: "users#settings"
get 'shop', to: "users#shop"
get 'volunteer', to: "users#volunteer"
get 'goodies', to: "users#goodies"
```
