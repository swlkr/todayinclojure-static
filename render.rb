# frozen_string_literal: true

require 'mustache'
require 'json'

hn_posts = JSON.parse File.read('hn.json')
reddit_posts = JSON.parse File.read('reddit.json')
clojureverse_posts = JSON.parse File.read('clojureverse.json')
posts = hn_posts + reddit_posts + clojureverse_posts

data = {
  posts: posts.sort_by { |p| p['created-at'] }.reverse,
  today: Time.now.utc.strftime('%B %d, %Y')
}

template = File.read 'index.mustache'

File.write 'index.html', Mustache.render(template, data)

File.delete 'hn.json'
File.delete 'reddit.json'
File.delete 'clojureverse.json'
