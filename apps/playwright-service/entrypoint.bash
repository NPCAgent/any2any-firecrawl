#!/bin/bash
/usr/local/share/desktop-init.sh
python -m hypercorn main:app --bind [::]:$PORT