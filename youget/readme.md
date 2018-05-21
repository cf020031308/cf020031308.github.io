## about

Dumb downloader that scrapes the web, see [you-get repo](https://github.com/soimort/you-get) or [you-get.org](https://you-get.org/)

## usage

```bash
docker build -t youget youget/
# append to .zshrc
alias you-get="docker run --rm -v $PWD:/tmp/workdir youget"
```
