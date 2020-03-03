(import http)
(import json)

(def now (os/time))
(def midnight (- now (mod now 86400)))
(def four-days-ago (- midnight (* 86400 4)))

(def url (string/format "https://api.stackexchange.com/2.2/questions?fromdate=%d&order=desc&sort=activity&tagged=clojure&site=stackoverflow"
                        four-days-ago))

(def response (http/get url))

(with [f (file/open "results.json.gz" :wb)]
  (file/write f (get response :body)))

(os/shell "gunzip results.json.gz")

(def results (with [f (file/open "results.json" :r)]
               (file/read f :all)))

(def results (json/decode results true true))

(defn post [p]
  {:url (get p :link)
   :title (get p :title)
   :author (get-in p [:owner :display_name])
   :author-url (get-in p [:owner :link])
   :source "stackoverflow"
   :source-url "https://stackoverflow.com"
   :created-at (get p :creation_date)
   :answers (if (one? (get p :answer_count))
              (string (get p :answer_count) " answer")
              (string (get p :answer_count) " answers"))})

(def posts (as-> results ?
                 (get ? :items)
                 (map post ?)))

(with [f (file/open "stackoverflow.json" :w)]
  (file/write f (json/encode posts)))

(os/rm "results.json")
