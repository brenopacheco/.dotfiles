#!/usr/bin/env bash

read -p "starting vim using $1. press any key "
nvim -u $1 test.lua


