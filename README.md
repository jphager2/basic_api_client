```ruby
client = BasicApiClient.new("user.cn", "userpassword", "http://example.com", "/api/v1/auth/sign_in")

client.authorize
#=> Returns a Hash with user data if success, else nil

client.get('/api/v1/users')
#=> Returns a Hash with user data if success, else nil
```
