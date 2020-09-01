.PHONY: build

build:
	janet hn/import.janet && \
	janet reddit/import.janet && \
	ruby clojureverse/import.rb && \
	janet stackoverflow/import.janet && \
	janet version/import.janet && \
	janet render.janet && \
	mkdir -p dist && \
	cp index.html dist/index.html && \
	cp about.html dist/about.html && \
	cp css/*.css dist/ && \
	rm index.html
