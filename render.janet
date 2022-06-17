(import ./musty :as musty)
(import json)

(def hn (json/decode (slurp "hn.json") true))
(def reddit (json/decode (slurp "reddit.json") true))
(def clojureverse (json/decode (slurp "clojureverse.json") true))
(def stackoverflow (json/decode (slurp "stackoverflow.json") true))
(def posts (array/concat hn reddit clojureverse stackoverflow))

(def version (json/decode (slurp "version.json") true))

(defn group-by
  `Groups an indexed datastructure according to function f

  Example:

  (group-by |($ :tbl) [{:tbl "post" :col "id"} {:tbl "post" :col "created_at"}])

  =>

  @{"post" @[@{:tbl "post" :col "id"} @{:tbl "post" :col "created_at"}]}`
  [f ind]
  (reduce
    (fn [ret x]
      (let [k (f x)]
        (put ret k (array/push (get ret k @[]) x))))
    @{} ind))


(defn- datefmt
  "Get the current date nicely formatted"
  [&opt time]
  (let [date (if time (os/date time) (os/date))
        month (+ 1 (date :month))
        day (+ 1 (date :month-day))
        year (date :year)]
    (string/format "%d/%.2d/%.2d"
                   month day year)))


(def days (->> posts
               (group-by |(- ($ :created-at) (% ($ :created-at) 86_400)))
               (pairs)
               (map |(struct :day (first $) :dayfmt (datefmt (first $)) :posts (last $)))
               (sort-by |($ :day))
               (reverse)))

(def data {:days days
           :version (version :name)})

(def index (slurp "index.mustache"))

(spit "index.html" (musty/render index data))

(os/rm "hn.json")
(os/rm "reddit.json")
(os/rm "clojureverse.json")
(os/rm "stackoverflow.json")
(os/rm "version.json")
