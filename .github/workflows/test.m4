changequote(`<{', `}>')dnl
changecom(<{##}>, <{
}>)dnl
# This file is templated. Do not edit!
name: Build test

on:
  - push
  - pull_request
  - workflow_dispatch

define(<{__PANDOC}>, <{2.9.1}>)dnl
define(<{__DATETIME}>, <{NOW}>)dnl
jobs:
define(<{__OS}>, <{windows}>)dnl
define(<{__SHELL}>, <{cmd}>)dnl
include(<{job.m4}>)dnl

define(<{__OS}>, <{windows}>)dnl
define(<{__SHELL}>, <{bash}>)dnl
include(<{job.m4}>)dnl

define(<{__OS}>, <{ubuntu}>)dnl
define(<{__SHELL}>, <{bash}>)dnl
include(<{job.m4}>)dnl

define(<{__OS}>, <{macos}>)dnl
define(<{__SHELL}>, <{bash}>)dnl
include(<{job.m4}>)dnl

  check:
    runs-on: ubuntu-latest
    needs:
      - build-windows-cmd-2-9-1
      - build-windows-bash-2-9-1
      - build-ubuntu-bash-2-9-1
      - build-macos-bash-2-9-1
    steps:
      - run: |
          echo '${{ toJSON(needs.*.outputs.sha256) }}' | jq -e '.|unique|length == 1 and (.[0]|test("^[A-Fa-f0-9]{64}$"))'
