#!/bin/bash

urxvt bash -c 'cat "$@"| w3m -o auto_image=TRUE -T text/html -F'
