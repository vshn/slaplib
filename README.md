# Slapper stlib

This repository contains the stdlib for slapper.

## Release a new version

Execute this make target on master:

```shell
make release VERSION=1.2.3
```

It will make sure the version in `stdlib.yaml` matches the tag and push to master.
This in turn will trigger the release CI workflow.
