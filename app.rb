# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'
require 'rack'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  if File.exist?('data.json')
    JSON.parse(File.read('data.json'))
  else
    {}
  end
end

def save_memos(memos)
  File.write('data.json', JSON.pretty_generate(memos))
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  id = SecureRandom.uuid
  memos[id] = { 'title' => params[:title], 'content' => params[:content] }
  save_memos(memos)
  redirect 'memos'
end

get '/memos/:id' do
  memos = load_memos
  @id = params[:id]
  @memo = memos[@id]
  erb :show
end

get '/memos/:id/edit' do
  memos = load_memos
  @id = params[:id]
  @memo = memos[@id]
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  id = params[:id]
  memos[id] = { 'title' => params[:title], 'content' => params[:content] }
  save_memos(memos)
  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  memos = load_memos
  id = params[:id]
  memos.delete(id)
  save_memos(memos)
  redirect '/memos'
end

not_found do
  '404 Not Found.'
end
