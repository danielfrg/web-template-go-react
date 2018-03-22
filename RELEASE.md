# Release

1. Bump `VERSION.txt`
1. `make tag`
    - Creates git tag
1. `git push`
    - Triggers TravisCI build that pushes to GitHub releases
