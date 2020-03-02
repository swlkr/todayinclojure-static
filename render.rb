# frozen_string_literal: true

require 'mustache'
require 'json'
require 'date'

hn_posts = JSON.parse File.read('hn.json')
reddit_posts = JSON.parse File.read('reddit.json')
clojureverse_posts = JSON.parse File.read('clojureverse.json')
stackoverflow_posts = JSON.parse File.read('stackoverflow.json')
posts = hn_posts + reddit_posts + clojureverse_posts + stackoverflow_posts

version = JSON.parse File.read('version.json')

days = posts
       .sort_by { |p| p['created-at'] }
       .reverse
       .group_by { |p| p['created-at'] - (p['created-at'] % 86_400) }
       .map { |k, v| { day: Time.at(k).utc.strftime('%B %d, %Y'), posts: v } }

data = {
  days: days,
  version: version['name']
}

template = File.read 'index.mustache'

File.write 'index.html', Mustache.render(template, data)

File.delete 'hn.json'
File.delete 'reddit.json'
File.delete 'clojureverse.json'
File.delete 'stackoverflow.json'
File.delete 'version.json'
