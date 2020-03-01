build:
	janet hn/import.janet && \
	janet reddit/import.janet && \
	ruby render.rb && \
	jam build