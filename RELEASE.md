# Release

1. Bump `VERSION.txt`
1. Commit bump - TODO: automate this?
1. `make tag`
    - Creates git tag
1. Run git command previous step outputs: `git push origin $(VERSION)`
    - Triggers TravisCI build that pushes to GitHub releases
