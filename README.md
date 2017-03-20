Introduction of [https://en.wikipedia.org/wiki/Fortune_%28Unix%29](fortune)

# bootstrap

```bash
cd content
find . -type f | xargs -I{} strfile '{}'
ln -s $PWD `fortune -f 2>&1 | sed -n '1s/^.* //p'`
```

# usage

```bash
fortune
```
