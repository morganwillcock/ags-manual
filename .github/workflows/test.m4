include(`actions.m4')dnl
define(`__DATETIME', `NOW')dnl
# This file is templated. Do not edit!
name: Build test

on:
  - push
  - pull_request
  - workflow_dispatch

jobs:
defjob(`windows', `cmd', `2.9.1')dnl
include(`job.m4')dnl

defjob(`windows', `bash', `2.9.1')dnl
include(`job.m4')dnl

defjob(`ubuntu', `bash', `2.9.1')dnl
include(`job.m4')dnl

defjob(`macos', `bash', `2.9.1')dnl
include(`job.m4')dnl

  check:
    runs-on: ubuntu-latest
    needs:
undivert(1)dnl
    steps:
      - run: |
          echo '${{ toJSON(needs.*.outputs.sha256) }}' | jq -e '.|unique|length == 1 and (.[0]|test("^[A-Fa-f0-9]{64}$"))'
