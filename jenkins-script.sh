#! /bin/bash

#################################################################################
# This script takes diffs between the last successful jenkins run and the       #
# current run to find what files have changed. The script updates (in zendesk)  #
# each article that has changed (by looking at the rst files). It also updates  #
# each article that uses an image that has changed (by finding images that have #
# changed and then grepping recursively for that filename in each rst file).    #
# The script figures out what section ID an article has by looking at the       #
# "section_id.txt" file in the directory that also has the article source (rst) #
#################################################################################

if [ -z "$EMAIL" ] ; then
    echo '$EMAIL is not set'
    exit 1
fi

if [ -z "$ZENDESK_PASS" ] ; then
    echo '$ZENDESK_PASS is not set'
    exit 1
fi

if [ -z "$ZENDESK_URL" ] ; then
    echo '$ZENDESK_URL is not set'
    exit 1
fi

# Build the documentation
tox

if [ $? -ne 0 ] ; then
    echo "tox build failed"
    exit 1
fi

# Clone the publish script
git clone https://github.com/dreamhost/zendesk-publish-script.git

if [ $? -ne 0 ] ; then
    echo "Could not clone the publishing script"
    exit 1
fi

# create a venv to run the publishing script
virtualenv venv ; . venv/bin/activate ; pip install -r zendesk-publish-script/requirements.txt

if [ $? -ne 0 ] ; then
    echo "Failed to make a virtualenv with the proper modules"
    exit 1
fi

# Get all the files that have changed since the last time the script published
# to zendesk
files="`git diff --name-only $GIT_PREVIOUS_SUCCESSFUL_COMMIT $GIT_COMMIT`"

# If a file is an image, add the places where it is referenced to $files
for file in $files ; do
    if `echo "$file" | egrep -i '\.png$|\.jpg$' > /dev/null` ; then
        file_name="`basename $file`"
        affected_files="`grep -R "$file_name" source/* | cut -d ':' -f1`"
        files="$(echo -e "${files}\n${affected_files}")"
    fi
done

# If a file is in examples, add the places where it is referenced to $files
for file in $files ; do
    if `echo "$file" | egrep -i '\/examples\/.*$' > /dev/null` ; then
        file_name="`basename $file`"
        affected_files="`egrep -R "\.\.\s+literalinclude::\s+examples(\/.*)?\/$file_name" source/* | cut -d ':' -f1`"
        files="$(echo -e "${files}\n${affected_files}")"
    fi
done

# If a file is in common, add the places where it is referenced to $files
for file in $files ; do
    if `echo "$file" | egrep -i '\/common\/.*\.rst$' > /dev/null` ; then
        file_name="`basename $file`"
        affected_files="`egrep -R "\.\.\s+include::\s+common(\/.*)?\/$file_name" source/* | cut -d ':' -f1`"
        files="$(echo -e "${files}\n${affected_files}")"
    fi
done

files="`echo "$files" | sort -u`"

for file in $files ; do
    if [ -e "$file" ] ; then
        # if the file extension is .rst and it is not "index.rst", get the
        # location it built to and publish it to the section specified in the
        # file "section_id.txt" in the rst file's directory
        if `echo "$file" | egrep '^source/.*\.rst$' > /dev/null` && ! `echo "$file" | egrep '\/index\.rst$' > /dev/null` && ! `echo "$file" | egrep '\/common\/.*\.rst$' > /dev/null` ; then
            html_file="`echo $file | sed 's/^source\(.*\).rst$/build\/html\1\.html/'`"
            echo "$html_file"
            dir="`dirname $file`"
            if [ -f "${dir}/section_id.txt" ] ; then
                section_id="$( cat "${dir}/section_id.txt" )"
            elif [ -f "${dir}/../section_id.txt" ] ; then
                section_id="$( cat "${dir}/../section_id.txt" )"
            fi
            if [ -z "$section_id" ] ; then
                echo "Cannot find the section id for file $file"
                exit 1
            fi
            python zendesk-publish-script/publish.py "$html_file" "$section_id"
            if [ $? -ne 0 ] ; then
                exit 1
            fi
        fi
    fi
done

git clone https://github.com/dreamhost/zendesk-pull-article-id
python zendesk-pull-article-id/get_metadata.py
