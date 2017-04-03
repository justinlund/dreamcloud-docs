#!/bin/bash

changedfiles="$(git diff HEAD --name-only | egrep '^source\/dream.*\/.*\/.*\.rst$')"
titleschanged="0"
for file in $changedfiles; do
    numschanged="$(git diff HEAD --unified=0 "$file" | sed -n 5p)"
    lineschanged="$(echo "$numschanged" | awk '{print $2}' | cut -d ',' -f1 | cut -d '-' -f2- | cut -d '+' -f2-)"
    if [ "$lineschanged" -le 3 ] ; then
        titleschanged="1"
    fi
done
if [ "$titleschanged" -eq 1 ] ; then
    echo "WARNING YOU MAY BE CHANGING AN ARTICLE TITLE, ONLY CHANGE AN"
    echo "ARTICLE TITLE IF YOU ARE ENTIRELY SURE OF HOW TO DO SO"
    echo "For more info see 'Gotchas of contributing' in the README"
fi

filesmissinglabels="`find ./source/dream*/*/*.rst | egrep -v '\/common\/.*\.rst' | xargs -I FILE grep -L ':labels:' FILE`"

if [ -z "$filesmissinglabels" ] ; then
    echo "All articles have labels"
    exit 0
else
    for file in $filesmissinglabels ; do
        echo "$file"
    done

    echo "The above files have missing labels"
    exit 1
fi
