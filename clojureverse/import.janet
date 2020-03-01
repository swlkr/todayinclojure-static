(import http)
(import json)
(import ../importer :as importer)


(def mapping {:comments :posts_count})
(def from (partial importer/from mapping))


(defn posts-json []
  (as-> (http/get "https://clojureverse.org/latest.json?order=created") ?
        (get ? :body)
        (json/decode ? true true)))


(defn topics [m]
  (get-in m [:topic_list :topics]))


(defn post [users p]
  (let [{:id id :posters posters :slug slug :created_at created_at} p
        user-id (get-in posters [0 :user_id])
        user (first (filter |(= user-id (get $ :id) users)))
        author (get user :username)]
    (merge p {:url (string "https://clojureverse.org/t/" slug "/" id)
              :author author
              :source "clojureverse"
              :source-url "https://clojureverse.org"
              :created-at (epoch created_at)
              :comments-url (string "https://clojureverse.org/t/" slug "/" id)
              :comments (from p :comments)})))


(defn posts
  ([epoch]
   (let [posts-json (posts-json)
         users (get posts-json :users)
         posts (topics json)]
     (->> (map) #(post users %) posts)
          (filter)))) #(> (:post/created-at %) epoch)))))
  ([]
   (posts (time/hour))))
