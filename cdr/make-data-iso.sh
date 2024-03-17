#!/usr/bin/env bash
# Generates a new ISO file fit for burning DVDs.

FILE_OUTPUT=$1
DISC_LABEL=$2

dd if=/dev/zero of=$FILE_OUTPUT bs=2048 count=2295104 status=progress
mkudffs -b 2048 -l $DISC_LABEL $FILE_OUTPUT

