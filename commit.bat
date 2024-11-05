set string="%DATE% %TIME:~0,8%"
git add *
git commit -m %string%
git push