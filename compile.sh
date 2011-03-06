#!/bin/zsh

# simple compile.sh script
# by Albert Zeyer, 2010 or so
# code under zlib

cd "$(dirname $0)"
ROOTDIR="$(pwd)"
INCLUDE="$ROOTDIR"
BUILDDIR="build"

# $1 - target
# $... - deps
function checkdeps() {
	local t="$1"
	[ ! -e "$t" ] && return -1
	for arg in $*; do
		[ "$arg" != "" ] && [ ! -e "$arg" ] && return -1
		[ "$arg" != "" ] && [ "$arg" -nt "$t" ] && return -1
	done
	return 0
}

# $1 - dep-file
function listdeps() {
	sed -e "s/\\\\$//g" -e "s/.*\\.o://g" \
		-e "s/^ *//g" -e "s/ *$//g" \
		"$1"
		#-e "s/^/\\\"/g" -e "s/$/\\\"/g" 
}

# $1 - cpp-file
# will compile the o-file
function srccompile() {
	local f="$1"
	local o="$BUILDDIR/${f/.cpp/.o}"
	local deps="$BUILDDIR/$f.deps"
	mkdir -p "$(dirname "$o")"
	[ -e $deps ] && checkdeps $o $f $(listdeps $deps) && echo "uptodate: $o" && return 0
	echo "compiling $o"
	g++ -c -MMD -MF $deps -o $o -iquote $INCLUDE -g $f || exit -1
}

# $1 - bin-file
# will link all the $OBJS together
function srclink() {
	local cpp="$1"
	local o="$BUILDDIR/${cpp/.cpp/.o}"
	local b="bin/${cpp/.cpp/}"
	checkdeps $b $OBJS $o && echo "uptodate: $b" && return 0
	echo "linking $b"
	g++ $OBJS $o -o $b ${(z)2} || exit -1
}

BINS=("test-png-dumpchunks.cpp" "test-png-reader.cpp" "pnginfo.cpp" "db-push.cpp" "db-push-dir.cpp")

# compile all sources
OBJS=()
for f in *.cpp; do
	srccompile "$f"
	[[ ${BINS[(i)$f]} -gt ${#BINS} ]] && \
		OBJS=($OBJS "$BUILDDIR/${f/.cpp/.o}")
done

mkdir -p bin
for b in $BINS; do
	srclink $b "-lz"
done
