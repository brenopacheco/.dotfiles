# File:   ${expand("%:t")}
# Author: ${expand("$USER")}
# Email:  ${$USER . "@" . hostname()}
# Date:   ${strftime("%c")}

.ONESHELL:
.SHELL	  := /bin/bash
.SHELLFLAGS := -eu -o pipefail -o posix -c
MAKEFGLAGS  += --no-builtin-rules
MAKEFGLAGS  += --print-directory

CC	 := gcc
CFLAGS := -Wall -Wextra -Wpedantic -std=c99
LFLAGS := -lm
SRC	:= $(wildcard *.c)
OBJ	:= $(SRC:%.c=%.o)
BIN	:= main

.PHONY:		all clean
.DEFAULT_GOAL: all

all: $(BIN)

$(BIN): $(OBJ)
	@echo "Compiling output files $^"
	$(CC) $^ -o $@ $(CFLAGS)

%.o: %.c
	@echo "Compiling object files $<"
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -f $(OBJ) $(BIN)

run: $(BIN)
	./$<


# vim: set ft=make
