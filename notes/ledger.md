# ledger

## a powerful command-line double-entry accounting system

短暂地用过 [ledger](https://www.ledger-cli.org/) 来记账，复式记账的话没个脚本纯靠手打是有点麻烦，或者是我的场景太简单，总之不打算再用了。

###

Intro
Tutorial
principles
journal
transactions
reports
reports



### Report

```bash
ledger -f x.dat balance
ledger -f x.dat register
ledger -f x.dat cleared
```

```bash
ledger -f 电玩账目.dat balance --value --effective -b 2017-12 -e 2018-02
```

[ledger-analytics](https://github.com/kendricktan/ledger-analytics)
