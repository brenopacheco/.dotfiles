#!/usr/bin/env bash

pajv test -s ./menu_schema.json -d ./menu_data_valid.json   --valid
pajv test -s ./menu_schema.json -d ./menu_data_invalid.json --invalid
