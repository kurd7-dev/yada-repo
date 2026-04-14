# Yada Repo

Static package repository layout for `ypkg`.

Suggested publish targets:
- GitHub Pages
- a plain static web host
- any object storage bucket with public HTTP access

Structure:

```text
yada-repo/
  bootstrap/
    latest.txt
  packages/
    index.txt
  staging/
    coreutils-mini/
```

Workflow:
1. build package payloads into `staging/<pkg>/usr/...`
2. zip the staging folder contents
3. move the zip into `packages/`
4. compute SHA-256
5. add the package entry to `packages/index.txt`

You do not need to give me a GitHub token to prepare this locally.
If you want to publish later, the safest path is:
- use `gh auth login` on your machine
- or create the repo yourself and point `ypkg` at the raw/static URL
