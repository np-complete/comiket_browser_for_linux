class ComiketBrowser < Padrino::Application
  register CoffeeInitializer
  register SassInitializer
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  get '/' do
    haml :index
  end

  get '/areas' do
    content_type :json
    {"E1-3" => 1, "E4-6" => 38, "W1-2" => 75}.to_json
  end

  get '/blocks' do
    content_type :json
    Block.all.map{|x| [x.id, x.name]}.to_json
  end

  get '/colors' do
    content_type :json
    Hash[Color.all.map do |x|
        matched = x.color.match /(.{2})(.{2})(.{2})/
        color = "#{matched[3]}#{matched[2]}#{matched[1]}"
        [x.id.to_i, {color: "##{color}", title: x.title}]
      end].to_json
  end

  get '/help' do
    haml 'help'
  end

end
