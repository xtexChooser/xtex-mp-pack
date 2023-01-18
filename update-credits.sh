#! /usr/bin/bash
PACKWIZ=${PACKWIZ:-packwiz}

TMPFILE=".tmp.mods.md"
touch $TMPFILE

$PACKWIZ list | while read i
do
echo "- $i" >> $TMPFILE
done

echo "const fs = require('fs'); fs.writeFileSync('CREDITS.md', fs.readFileSync('CREDITS.md').toString().replace(/<!--BEGIN MOD LIST-->((.|\\n)*)<\!--END MOD LIST-->/m, '<!--BEGIN MOD LIST-->\\n\\n' + fs.readFileSync('$TMPFILE') + '\\n<\!--END MOD LIST-->'))" | node

rm $TMPFILE
touch $TMPFILE

git log --pretty='%aN' | uniq | sort | while read i
do
echo "- $i" >> $TMPFILE
done

echo "const fs = require('fs'); fs.writeFileSync('CREDITS.md', fs.readFileSync('CREDITS.md').toString().replace(/<!--BEGIN CONTRIBUTORS LIST-->((.|\\n)*)<\!--END CONTRIBUTORS LIST-->/m, '<!--BEGIN CONTRIBUTORS LIST-->\\n\\n' + fs.readFileSync('$TMPFILE') + '\\n<\!--END CONTRIBUTORS LIST-->'))" | node

rm $TMPFILE
