Introduction of [fortune](https://en.wikipedia.org/wiki/Fortune_%28Unix%29)

## bootstrap

```bash
cd content

# generate index files
find . \! -name '*.dat' -type f -exec strfile {} \;

# replace built-in content
fortune -f 2>&1 | sed -n '1s/^.* //p' | xargs -I{} sh -c "rm -r {} && ln -s $PWD {}"
```

## usage

```bash
fortune
```
