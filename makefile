.PHONY: update
update:
	find content \! -name '*.dat' -type f -exec strfile {} \;

.PHONY: install
install:
	fortune -f 2>&1 | sed -n '1p' | cut -d":" -f 2 | xargs -I{} sh -c "rm -r {} && ln -s $PWD/content {}"
