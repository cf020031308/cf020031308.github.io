# The Reason I Created agentDoc and Why You Don't Need it

Back to date May 2018 I wrote down the first line of a script called [agentDoc](https://github.com/cf020031308/agentDoc) for these two purposes:

1. Quick Notes. I hoped to find a way fast and simple to access, modify and search through my documents. I didn't pick any open sourced one, not only because they were not handy.
2. Shell Study. I found shell scripts very useful and convenient so I opened this project to drive me to learn Bash.

One interesting thing about agentDoc I hope to mention is that instead of configuring it in a file or with environment variables like we always do in common ways, you may configure it by linking it into the folder where you want your documents managed and then renaming it as if it is one of them.  
This is what the 'agent' in the name stands for.

agentDoc is created to be tiny but flexible. And it really achieved so. I used it to manage my [code snippets](https://github.com/cf020031308/cf020031308.github.io/tree/master/dotfiles/vim/vim-snippets), [articles and cheatsheets](https://github.com/cf020031308/cf020031308.github.io/wiki).

But as time went by, it was extended with many markdown-related features due to my heavy use of [Github Flavored Markdown](https://guides.github.com/features/mastering-markdown/) that it became 'agentMD' yet 'agentDoc'.

During this period, I got into the use of some awesome command line tools like [fzf](https://github.com/junegunn/fzf), [ripgrep](https://github.com/BurntSushi/ripgrep) and [fasd](https://github.com/clvv/fasd), which boosted my productivity largely but implied the unneccesarity of agentDoc. For example, with the use of `ripgrep`, a simple configuration like `alias wk="cd ~/wiki && rg"` in my `zshrc` would do most of the work agentDoc can do.

So in the next phase, I would try to extract the good features related to markdown from agentDoc into some other useful isolated scripts like `mdmv` which moves markdown files from one place (remote or local) to another with all the referenced images and links still available.  
As to agentDoc itself, it would be left as it is, in case someone else may think it valuable.

> This commit contains my recent tools to replace agentDoc: [fe34a11](https://github.com/cf020031308/cf020031308.github.io/commit/fe34a11b10fb5a71da177fa0cac25400ba435ad0) @20200627土17:21

## [Comments](https://github.com/cf020031308/cf020031308.github.io/issues/35)
