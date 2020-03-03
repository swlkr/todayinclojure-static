(import json)
(import http)
(import ../importer :as importer)


(def mapping {:created-at :created_at_i :comments-url :objectID :comments :num_comments})


(defn posts-since [time]
  (let [url (string "https://hn.algolia.com/api/v1/search_by_date?query=%22clojure%22&page=0&tags=story&numericFilters=created_at_i%3E" time)
        response (http/get url)]
    (json/decode (get response :body) true true)))


(def from (partial importer/from mapping))


(defn post [p]
  (merge p {:source "hn"
            :source-url "https://news.ycombinator.com"
            :created-at (from p :created-at)
            :comments-url (string "https://news.ycombinator.com/item?id=" (from p :comments-url))
            :comments (from p :comments)}))


(def now (os/time))
(def midnight (- now (mod now 86400)))
(def four-days-ago (- midnight (* 86400 4)))


(defn posts []
  (let [posts (as-> (posts-since four-days-ago) ?
                    (get ? :hits)
                    (map post ?))]
    (with [f (file/open "hn.json" :w)]
      (file/write f (json/encode posts)))))


(posts)
