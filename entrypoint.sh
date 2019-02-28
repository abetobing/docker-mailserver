#!/bin/bash
set -e

groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/vmail -m
