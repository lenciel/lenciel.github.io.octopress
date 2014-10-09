all: update

comments:
	rake build_comments

preview:
	rake generate && rake preview

style:
	rake update_style

template:
	git pull octopress master
	bundle install
	rake update_source
	rake update_style

update:
	rake gen_deploy && \
	git add .; \
	git commit -am "blog update $$(date +%Y-%m-%d)"; \
	git push origin source

