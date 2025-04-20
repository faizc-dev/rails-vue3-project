# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:8080', 'http://localhost:5173'  # Add your frontend origins here
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :options],
        credentials: false
    end
  end
  