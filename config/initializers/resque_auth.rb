Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "t0mat3!"
end