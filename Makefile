.PHONY: all install


help:
	@echo "all     :: run all install tasks"
	@echo "task    :: run tasks interactiverly"
	@echo "fzf     :: fzf pick task to run"

all:
	./install

task:
	./install -i -v

fzf:
	./install -f -v
