(import json)
(import http)
(import ../importer :as importer)


(def mapping {:created-at :created_utc :comments :num_comments :comments-url :permalink})


(def from (partial importer/from mapping))


(defn post [p]
  (merge p {:source "/r/clojure"
            :source-url "https://old.reddit.com/r/clojure"
            :created-at (from p :created-at)
            :author-url (string "https://old.reddit.com/u/" (get p :author))
            :comments-url (string "https://old.reddit.com" (from p :comments-url))
            :comments (from p :comments)}))


(def now (os/time))
(def midnight (- now (mod now (* 86400 4))))


(defn posts-json []
  (let [response (http/get "https://old.reddit.com/r/clojure.json")]
    (json/decode (get response :body) true true)))


(defn posts-since [time]
  (let [posts-json (posts-json)]
    (->> (get-in posts-json [:data :children])
         (map |(get $ :data))
         (filter |(not (empty? (get $ :url))))
         (filter |(> (get $ :created_utc) time)))))


(defn posts []
  (let [posts (as-> (posts-since midnight) ?
                    (map post ?))]
    (with [f (file/open "reddit.json" :w)]
      (file/write f (json/encode posts)))))


(posts)
