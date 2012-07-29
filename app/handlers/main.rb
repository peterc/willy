class Willy
  get '/' do
    erb :index
  end
  
  get '/style.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :style
  end
end