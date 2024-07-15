class ForceJsonFormat
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['CONTENT_TYPE'] == 'application/json'
      env['HTTP_ACCEPT'] = 'application/json'
    end
    @app.call(env)
  end
end