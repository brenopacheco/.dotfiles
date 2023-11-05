.PHONY: all install


help:
	@echo "all     :: run all install tasks"
	@echo "task    :: run tasks interactiverly"

all:
	./install

task:
	./install -i -v
