(import http)
(import json)


(def url "https://search.maven.org/solrsearch/select?q=a:clojure&start=0&rows=20")
(def response (http/get url))
(def data (json/decode (get response :body) true true))

(def result {:name (get-in data [:response :docs 0 :latestVersion])
             :published-at (/ (get-in data [:response :docs 0 :timestamp])
                              1000)})

(with [f (file/open "version.json" :w)]
  (file/write f (json/encode result)))
