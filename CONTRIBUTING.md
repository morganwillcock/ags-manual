# Contributing to AGS Documentation

## Introduction

Thank you for considering contributing to AGS Manual wiki. The AGS Manual is made better by people like you.

Since the manual is made by multiple contributions, reading the guidelines ensures we can provide a cohesive document for the game developers using AGS. 
We also assume you are also a game developer using AGS which means in the future you will also be thanking yourself later.

*If instead, you have questions about building the manual and website help template, create an issue on GitHub so we can discuss that!*

## Getting started

- Create an account on GitHub
- If you are unsure about your contribution, Create an issue
- If you are REALLY confident about your contribution, and you have created at least one issue, write in the wiki

## Opening issues

- Be respectful when writing issues
- If you want to discuss a topic already on the manual, link it in the wiki.
- If you want to discuss a new entry, not in the manual, suggest it's name and where it would reside
- Issues are where we can sketch ideas and discuss pages, so don't be afraid of writing too much, just be aware that it will take more time to think about the more that is written.

## Writing in the wiki

- Ensure all pages have at least one other page that leads to it. Do not cause or add orphaned pages.

### How to add screenshots to the documentation

Screenshots should be avoided, but they make sense in tutorials or when describing how AGS Editor user interface works.

- Do not overuse screenshots.
- Screenshots should be saved as PNG or JPG, with a width of at least 400 px.
- Try to keep the file size less than 220KB.
- Do not rely on images to provide information or context.
- Do not include any personally identifying information.
- Capture just the part of the screen or window that users must focus on.
- Do not include window headers in the final screenshots unless completely necessary.
- Limit empty GUI space, manipulate your screenshots to condense important information.
- Do not include any watermark or any reference to other tools in a screenshot.
- Prefer the interface and portrayed game objects to be in English when possible.

Finally, the actual inclusion of screenshots in the manual can only be done by people with commit access to the repository wiki, likely the [docs-contributors](https://github.com/orgs/adventuregamestudio/teams/docs-contributors) team.

Clone the wiki locally 

    git clone https://github.com/adventuregamestudio/ags-manual.wiki.git

And add necessary screenshots inside `images/`, then add, commit and push the images.

### Code snippets in contributions

Always ensure your code snippets in the manual follow below

- Is as small as possible to achieve what's desired;
- Either can run on empty game template or can run on Sierra template;
- If it requires additional resources (like a gMyGUI, cEgo2, ...) it can be grasped from the context it's presented.

## The build system

### Introduction

The current build system is based on converting wiki pages which are
written in GitHub Flavored Markdown (GFM). Conversion is done using
Pandoc using templates derived from Pandoc's default templates for
HTML4 and HTML5 output. Lua filters are used to modify content,
generate metadata, and implement custom output types.

There are currently two types of output which are produced:

- A directory of files which can be browsed as a static website
- A CHM file that can be used on Windows

Builds are configured through the use of the `configure` script which
will generate a Makefile suitable for the majority of `make`
implementations. The website pages are always generated since only
Pandoc is required. Creation of the CHM file is optional since it
depends on the presence of a CHM compiler.

Building on Windows is supported through using
[MSYS2](https://www.msys2.org/).

### The CHM problem

Creating a CHM file is a two-step process. Pandoc with custom Lua
scripting is able to recreate the equivalent of an 'htmlhelp' project
structure but the second stage requires running a CHM compiler which
takes this project as its input. Unfortunately the CHM format is
proprietary and only partially reverse engineered. There are two
feasible options:

1. Use Microsoft's own `hhc` compiler which is available within an
   installation of "HTML Help Workshop"
2. Use the `chmcmd` compiler which is supplied as part of
   the default installation of Free Pascal

Currently the build system will default to using `hhc` since this
maintains the same search index generation method which has been used
previously and because it is a known quantity. Unfortunately it only
works on Windows and Microsoft have removed the HTML Help Workshop
download from their website. It is unclear if anyone else has the
legal right to host a copy of it and/or distribute it.

Free Pascal's `chmcmd` compiler is functional and being actively
developed. The search index which it generates is smaller than the one
generated by `hhc` although potentially this is because `hhc` is
splitting words to allow partial searches to work. Given that `chmcmd`
is available and cross-platform it is the intention that, if CHM
builds are still required in the long term, the compiler preference
should be switched to `chmcmd`.

### Dependencies

When `configure` is run any dependencies will be searched for and
potentially tested. Setting the build variables which define the path
to a program implies that it is known working version so any tests
will be skipped.

#### Installing Pandoc

Pandoc can be downloaded from its GitHub release assets. A recommended
minimum version is 2.10. The following commands will download a Pandoc
binary into the current directory:

```sh pandoc Linux
# Download the Linux binary for Pandoc $PANDOC_VERSION into the current directory
url="https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz"
curl -fL "$url" | tar -f - -vxz --strip-components 2 pandoc-$PANDOC_VERSION/bin/pandoc
```

```sh pandoc macOS
# Download the macOS binary for Pandoc $PANDOC_VERSION into the current directory
url="https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-macOS.zip"
(cd /tmp && curl -fLOJ "$url")
bsdtar -vxf /tmp/pandoc-$PANDOC_VERSION-macOS.zip --strip-components 2 pandoc-$PANDOC_VERSION/bin/pandoc
```

```sh pandoc Windows
# Download the Windows binary for Pandoc $PANDOC_VERSION into the current directory
url="https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-windows-x86_64.zip"
(cd /tmp && curl -fLOJ "$url")
bsdtar -vxf /tmp/pandoc-$PANDOC_VERSION-windows-x86_64.zip --strip-components 1 pandoc-$PANDOC_VERSION/pandoc.exe
```

#### Installing HTML Help Workshop

HTML Help Workshop (which includes a copy of `hhc`) is no longer
available for download from Microsoft's website but it has been
archived at <https://archive.org/>. The following commands will
download the installer and run it without requiring any user
interaction:

```sh html-help-workshop
# Download HTML Help Workshop
url=https://web.archive.org/web/20200918004813/https://download.microsoft.com/download/0/A/9/0A939EF6-E31C-430F-A3DF-DFAE7960D564/htmlhelp.exe
(cd /tmp && curl -fLOJ "$url")

# Verify this was the expected download
checksum=b2b3140d42a818870c1ab13c1c7b8d4536f22bd994fa90aade89729a6009a3ae
echo "$checksum  /tmp/htmlhelp.exe" | sha256sum --check

# Extract the installer from the outer wrapper
/tmp/htmlhelp.exe //Q //T:"$(cygpath --windows /tmp/htmlhelp_ex)" //C

# Remove the update check and install
> /tmp/htmlhelp_ex/htmlhelp_noupdate.inf grep -v '^"hhupd.exe' /tmp/htmlhelp_ex/htmlhelp.inf
"$(cygpath --windir)/SysWOW64/rundll32.exe" advpack.dll,LaunchINFSection ""$(cygpath --windows /tmp/htmlhelp_ex/htmlhelp_noupdate.inf)"",,3,N

# Verify that the CHM compiler is now present
test -f '/c/Program Files (x86)/HTML Help Workshop/hhc.exe'
```

#### Installing chmcmd

Free Pascal installations should provide `chmcmd` by default. Binary
release archives should contain a copy, on Linux the following
commands will download the archive and just extract `chmcmd` to the
current directory:

```sh chmcmd Linux
# Download the Linux chmcmd binary to the current directory
url=https://sourceforge.net/projects/freepascal/files/Linux/3.2.2/fpc-3.2.2.x86_64-linux.tar/download
curl -fLSs "$url" | \
    tar -Oxf - fpc-3.2.2.x86_64-linux/binary.x86_64-linux.tar | \
    tar -Oxf - units-chm.x86_64-linux.tar.gz | \
    tar -xvzf - --strip-components 1 bin/chmcmd
```

An easy way to install on macOS is by using the
[Homebrew](https://brew.sh/) package manager. The follow commands will
update the package database and then install latest version of Free
Pascal:

```sh chmcmd macOS
# Install Free Pascal with the Homebrew package manager
brew update
brew install fpc
```

For Windows, the following commands will download the Free Pascal
installer and run it without requiring any user interaction:

```sh chmcmd Windows
# Download and install the Windows build of Free Pascal
url=https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/fpc-3.2.2.i386-win32.exe/download
(cd /tmp && curl -fLOJ "$url")
/tmp/fpc-3.2.2.i386-win32.exe //sp- //verysilent //norestart
```

### Comparing builds

A reasonable way to check for variations in builds between different
platforms or different Pandoc versions is to perform a recursive diff
between builds on a common directory. Currently the CI system performs
a check on all builds of the website directory by using a script which
compares a single build to all other builds (where each argument to
the script is a directory containing the final website):

```sh diff-dirs
#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Nothing to compare"
    exit 0
fi

first="$1"
rc=0
shift

for other; do
    echo "Comparing '$first' to '$other'"
    diff -r "$first" "$other" || rc=1
done

exit $rc
```

This is particularly useful when combined with a `make` implementation
which supports VPATH builds, which facilitate configuring and building
within a sub-directory:

```sh
mkdir build_2.9.2
cd build_2.9.2
../configure PANDOC=~/pandocs/2.9.2/pandoc
```

### Spelling check

Currently no spelling checks are made as part of the build process,
although it would appear to be feasible if an AGS specific dictionary
could be loaded and Markdown source has all script API references and
examples identified as code. Omitting the custom dictionary for the
moment it is possible to check the website pages with any tool which
can parse HTML and be told to ignore code elements and the page
footer:

```sh spellcheck
#!/bin/sh

for html in source/*.html; do
    echo "$html"
    cat "$html" | \
        aspell -d en \
               -H \
               --add-html-skip=code \
               --add-html-skip=footer \
               list | \
        sort | uniq -c
done
```

**Note that the dictionary should be configured as US English**

### Common tasks

#### Page metadata

Both build targets require that any missing metadata be generated; the same Pandoc filter can be used to generate a page title. The metadata value for **title** is also set directly, based on the filename of what is being converted:

    --metadata title=$* \
	--lua-filter "lua/set_title.lua" \

...this means that if whatever the Lua filter wants to use a page title is not present, the stem name coming from GNU Make is used instead.

#### Link targets

There is also the issue of fixing internal document links, as converting from GFM to HTML in Pandoc does not implicitly rewrite the link target to match the output format. i.e. the GFM link `[Other Features](OtherFeatures)` works within GitHub pages but would need to be converted to the equivalent of `[Other Features](OtherFeatures.html)` in the HTML version. Since both build targets require the same conversion, they also share the same Pandoc filter:

    --lua-filter "lua/rewrite_links.lua" \

#### Output templates

The page conversion itself also requires a template that matches the output format; the default templates have been exported from Pandoc and modified. The coresponding template needs to be specified for each output format.

For the CHM file the output format is html4:

    --to html4 \
    --template "htmlhelp/template.html4" \

For the website target the output format is html5:

    --to html5 \
    --template "html/template.html5" \

#### Write metadata file

For each converted page a matching Lua file is written using a custom Pandoc writer.

    --to "lua/write_metablock.lua" \
    --metadata docname=$* \

These files are designed to be evaluated using the Lua `dofile` function to return a Lua table which contains information about the page. The information stored is:

* The page title
* Headings found on the page and their anchor links
* Links found on the page
* A list of keywords and number of times each occurs

An important feature of the custom writer is to identify which parts of the page relate to script documentation so that later actions may treat them differently.

### CHM file only

#### Write an hhk file

The hhk file is used by the the CHM compiler to define the index. A custom Lua writer is used to write an HHK file from all Lua metadata files (excluding anything relating to index file).

    --from markdown \
    --to "lua/write_hhk.lua" \

The result should be a file of site map objects, like this one:

    <LI> <OBJECT type="text/sitemap">
    <param name="Keyword" value="AudioClip.FileType">
    <param name="Local" value="AudioClip.html#audioclipfiletype">
    </OBJECT>

#### Write an hhc file

The hhc file is used by the CHM compiler to define the contents. Currently we are only considering the index page (index.md) for the source of the contents, so this is converted using a custom Lua writer which writes the hhc file based on the headings and bulleted lists which are present. The output needs to produce hierarchical lists where the contents page should expand and collapse.

    --from gfm \
    --to "lua/write_hhc.lua" \
    --lua-filter "lua/rewrite_links.lua" \
    --template "htmlhelp/template.hhc" \

Note that link target are being rewritten too, because the input file will be the original GFM source for the index page.

#### Write an hhp file

The hhp file is the main project file that is passed to the CHM compiler. It is written using a custom Pandoc writer which just needs to know the list of source files to include and the name prefix that is used for the hhk, hhc, and stp project files.

    --to "lua/write_hhp.lua" \
    --metadata incfiles="$(HTMLFILES) $(subst /,$(strip \),$(IMAGEFILES))" \
    --variable projectname=ags-help \
    --template "htmlhelp/template.hhp" \

Note that the paths passed in need to have the slashes changes from / to \ in so that if this file is written on a non-Windows platform the content will still be valid.

#### Write an stp file

The stp file is just a list of words that the CHM compiler should ignore when creating its own search index. Rather than dynamically generate this file, it is just copied into position.

### Website files only

#### A-Z index page

Since the website build wouldn't have a built-in index, an index page is generated from all Lua metadata files (excluding anything relating to index file) using a custom Pandoc writer.

    --from markdown \
    --to "lua/write_genindex.lua" \
    --template "html/template.html5" \

Note that the same HTML5 template that was used for the actual page conversion is used here, so the page will keep the same styling as the other pages. If passing in any external styling (i.e. using `--css`) on other pages, it will need to be included here too.

#### Javascript search and JSON data

For the current search system, the number of occurrences of each word are recorded in all of the Lua metadata files, so these are written as a JSON object into a template file which also contains the Javascript search functions.

    --from markdown \
    --to "lua/write_metajs.lua" \
    --template "html/template.js" \

Again, the Lua file for the index page is not processed so that the contents page remains acting like a site map and doesn't count towards search results. The resulting javascript file is included at the bottom of the HTML5 template, so every page of the website will have loaded the search functions as well as the JSON object that they require.

## Creating releases

Below are the steps necessary to create a release, beginning from a
newly cloned working tree. Note that in order to bootstrap the build
system you will need a local installation of Autoconf, Automake, and
Git.

### Update the wiki content

1. Clone the wiki sub-module

   Wiki content is referenced as a sub-module for the 'source'
   directory and so this directory will be initially be empty. Update
   all sub-modules to get the version of the wiki content which is
   currently referenced.

   ```
   git submodule update --init
   ```

2. Update the sub-module

   The source directory should no longer be empty. Pull the latest
   copy of wiki content and merge it.

   ```sh
   git submodule update --remote --merge
   ```

   If there were any changes they will be reported. Whoever is
   committing the changes is effectively responsible for promoting the
   content from the wiki into the official release; reading the
   changes in the page content is a good idea.

3. Bootstrap the build system

   At the time that the build system is bootstrapped the content of
   the sub-module (as reported by `git ls-files`) is the authoritative
   source of which source files will be incorporated into the build
   process.

   ```sh
   ./bootstrap
   ```

4. Configure and distcheck

   Run configure and then verify that everything builds and that there
   are no packaging problems. Ideally do this with the CHM build
   enabled to also cover optional files in the checks. Note that
   configuration for the 'distcheck' target is specified separately to
   the initial configuration.

   ```sh
   ./configure
   make DISTCHECK_CONFIGURE_FLAGS=--with-chmcmd distcheck 
   ```

   When the process has completed you should see a confirmation that
   the release is available to use:

   ```
   ==================================================
   ags-manual-1.2.3 archives ready for distribution: 
   ags-manual-1.2.3.tar.gz
   ==================================================
   ```

   The most likely cause of failure is that new external links have
   been added to the wiki pages and they haven't yet been added to the
   approved links list. Approved links are listed alphabetically in
   [`meta/approved_links.txt`](https://github.com/adventuregamestudio/ags-manual/blob/master/meta/approved_links.txt).
   Once new links have been added to this file the 'distcheck' target
   should report success.

5. Commit the changes

   If the updates look OK and there are no issues highlighted by the
   checks commit the sub-module change:

   ```sh
   git add source
   git commit -m "Sync with wiki content"
   ```

   Now the changes can be pushed back.

### Generating a GitHub release

1. Check the current package version

   Firstly verify the package version currently defined by the build
   system:

   ```sh
   grep ^AC_INIT configure.ac 
   ```

   ...which will give output similar to:

   ```
   AC_INIT([ags-manual], [1.2.3])
   ```

   This defines the package name and version. If the version needs to
   be increased edit the number and push the changes back before doing
   anything else.

2. Create a GitHub release

   Within the GitHub release web interface create a new tag that
   represents the release version. **You must ensure that the tag name
   begins with a "v"**. For example, if the package version is "1.2.3"
   use the tag name "v1.2.3".

   Once the release is created the CI system should build and upload
   the release assets.
