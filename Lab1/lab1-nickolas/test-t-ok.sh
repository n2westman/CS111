#! /bin/sh
# test-t-ok.sh

tmp=$0-$$.tmp
mkdir "$tmp" || exit

(
cd "$tmp" || exit

cat >test.sh <<'EOF'

#Should print out "good dog chases cat" or "dog good chases cat"
false && echo bad
true && echo good | tr g d >text.tmp

false || echo good | tr d g >text.tmp
true || echo bad || echo bad && echo good >text.tmp

(sleep 2; echo cat)
(sleep 1; echo chases)
echo dog

rm text.tmp
EOF

cat >test.exp <<'EOF'
dog
chases
cat
EOF

../timetrash -t test.sh >test.out 2>test.err || exit

diff -u test.exp test.out || exit
test ! -s test.err || {
  cat test.err
  exit 1
}

) || exit

rm -fr "$tmp"
