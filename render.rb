# frozen_string_literal: true

require 'mustache'
require 'json'

hn_posts = JSON.parse File.read('hn.json')
reddit_posts = JSON.parse File.read('reddit.json')

posts = {
  posts: hn_posts.concat(reddit_posts).sort_by { |p| p['created-at'] }.reverse
}

template = File.read 'index.mustache'

File.write 'index.html', Mustache.render(template, posts)

File.delete 'hn.json'
File.delete 'reddit.json'
