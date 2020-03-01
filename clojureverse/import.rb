# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'
require 'net/https'
require 'date'

def posts_json
  url = URI.parse('https://clojureverse.org/latest.json?order=created')
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(url.to_s)
  res = https.request(req)

  JSON.parse res.body
end

def topics(res)
  res.dig('topic_list', 'topics')
end

def post(users, p)
  user_id = p.dig('posters', 0, 'user_id')
  user = users.first { |u| u.id == user_id }
  author = user['username']
  created_at = DateTime.parse(p['created_at']).strftime('%s').to_i
  url = "https://clojureverse.org/t/#{p['slug']}/#{p['id']}"

  {
    title: p['title'],
    url: url,
    author: author,
    'author-url' => "https://clojureverse.org/u/#{author}",
    source: 'clojureverse',
    'source_url' => 'https://clojureverse.org',
    'created-at' => created_at,
    'replies' => (p['posts_count'] - 1) == 1 ? "#{p['posts_count'] - 1} reply" : "#{p['posts_count'] - 1} replies"
  }
end


def posts
  now = Time.now.to_i
  midnight = now - (now % 86_400)
  posts_json = posts_json()
  users = posts_json['users']
  posts = topics(posts_json)

  posts
    .map { |p| post(users, p) }
    .select { |p| p['created-at'] >= midnight }
end

posts = posts()

File.write 'clojureverse.json', JSON.dump(posts)