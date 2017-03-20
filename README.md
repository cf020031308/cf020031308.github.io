Introduction of [fortune](https://en.wikipedia.org/wiki/Fortune_%28Unix%29)

# bootstrap

```bash
cd content
find . -type f | xargs -I{} strfile '{}'
FORTUNEPATH=`fortune -f 2>&1 | sed -n '1s/^.* //p'`
rm -r $FORTUNEPATH
ln -s $PWD $FORTUNEPATH
```

# usage

```bash
fortune
```
