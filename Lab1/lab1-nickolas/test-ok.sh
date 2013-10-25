#! /bin/sh

#UCLA CS 111 Lab 1b

tmp=$0-$$.tmp
mkdir "$tmp" || exit

(
cd "$tmp" || exit

cat >test.sh << 'EOF'

echo GO | cat | cat #pipe
true || false || echo bad #ors
false && true && echo bad #ands

echo nick | (tr n U | cat) | cat >nick.txt #subshell

( ( (cat | tr i C ) | tr c L) | tr k A) <nick.txt | cat >yes.txt #nested

echo bad | cat <yes.txt

rm nick.txt yes.txt

EOF

cat >test.exp <<'EOF'
GO
UCLA
EOF

../timetrash test.sh >test.out 2>test.err || exit

diff -u test.exp test.out || exit
test ! -s test.err || {
  cat test.err
  exit 1
}

) || exit

rm -fr "$tmp"
