(defn from [mapping dict key]
  (get dict (get mapping key key)))