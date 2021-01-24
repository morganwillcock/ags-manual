include(`actions.m4')dnl
# This file is templated. Do not edit!
name: Release and upload

on:
  push:
    tags:
      - v*

jobs:
defjob(`windows', `bash', `2.9.1')dnl
include(`job.m4')dnl
      - name: Create release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: false
          prerelease: false
      - name: Release CHM file
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ags-manual/htmlhelp/build/ags-help.chm
          asset_name: ags-help.chm
          asset_content_type: application/octet-stream
      - name: Deploy on GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ags-manual/html/build
divert(-1)dnl
undivert(1)dnl
