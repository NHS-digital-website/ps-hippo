include ../vars.mk

BUILD_DIR ?= ../../ps-build
ENV ?= tst
OD_ENV = $(shell bash ondemand-env-name $(ENV))
RD_CONF = $(PWD)/rd.conf
RELEASE_DATE = $(shell d=1; while (($$(date --date +$${d}day +%u) >= 6)); do ((++d)); done; date --date +$${d}day +%Y-%m-%d)
RELEASE_TIME_UTC = 12:05:00
TRAVIS_BUILD_CMD ?= test.site
TRAVIS_EVENT_TYPE ?=
VENV ?= $(PWD)/.venv
VERSION ?= $(shell git describe --tags --match "$(VERSION_BASE)*" || echo $(VERSION_BASE).0)
VERSION_BASE ?= $(shell cat "$(PWD)/../.version")
SLACK_HOOK_URL ?=

PATH := $(VENV)/bin:$(PWD)/bin:$(PWD)/vendor:$(shell printenv PATH)
SHELL := env PATH=$(PATH) /bin/bash

ifneq ($(HIPPO_MAVEN_USERNAME),)
MVN_OPTS ?= --file ../pom.xml -Drevision=$(VERSION) ${MVN_VARS} --global-settings "$(PWD)/../.mvn.settings.xml"
endif
MVN_OPTS ?= --file ../pom.xml -Drevision=$(VERSION) ${MVN_VARS}

ifeq ($(TRAVIS_EVENT_TYPE),cron)
TRAVIS_BUILD_CMD = test.e2e
endif

.PHONY: .phony

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)

## Initialise local project
init: $(VENV)

## Sudo for AWS Roles
# Usage:
#   $(make aws-sudo PROFILE=profile-name)
#   $(make aws-sudo PROFILE=profile-with-mfa TOKEN=123789)
aws-sudo: $(VENV)
	@(printenv TOKEN > /dev/null && aws-sudo -m $(TOKEN) $(PROFILE) ) || ( \
		aws-sudo $(PROFILE) \
	)

## Test, tag, build and upload artefact
# You still have to push newly created tag
release: test version.bumpup
	# we have to call build manually, so that the VERSION is set properly.
	$(MAKE) build upload

## Run all tests
test: clean test.e2e

## Run unit tests
test.unit:
	mvn package $(MVN_OPTS) -DskipTests --quiet
	mvn test $(MVN_OPTS) --quiet

## Run BDD tests for "site" only.
test.site:
	mvn clean verify $(MVN_OPTS) -f acceptance-tests/pom.xml --quiet \
		-Dcucumber.options="src/test/resources/features/site" \
		-Pacceptance-test-hippo,acceptance-test

## Run tests for cms only, without development data
test.cms:
	mvn clean verify $(MVN_OPTS) --quiet \
		-Dcucumber.options="src/test/resources/features/cms" \
		-Pacceptance-test-hippo,acceptance-test,acceptance-without-development-data

## Run only acceptance tests tagged with "WIP" without a running server
# Useful for testing travis build only running some tests
test.wip.standalone:
	mvn clean verify $(MVN_OPTS) \
		-Dcucumber.options="src/test/resources/features --tags @WIP" \
		-Pacceptance-test-hippo,acceptance-test

## Run the tests that we want for travis builds
# We only run site tests for pull requests as the CMS tests are unreliable
# however we are adding a cron job that will run all test once a day and
# we can fix these as we go along.
test.travis:
	$(MAKE) $(TRAVIS_BUILD_CMD)

## Run BDD tests
test.e2e:
	$(MAKE) test.site
	$(MAKE) test.cms

## Build distribution package
build:
	mvn verify $(MVN_OPTS) -DskipTests=true
	mvn $(MVN_OPTS) -P separate-dist -DskipTests=true
	mvn $(MVN_OPTS) -P on-demand-dist -DskipTests=true

## Set a success status on current commit
# You would normally run this target after running (and passing) all tests
# Usage: make github.status.success
github.status.success:
	bash bin/set-commit-status "success" "Version $(VERSION) passed unit and site tests."

## Updates 'ENV' tag and pushes is back to github
# Usage: make git.update-environment-tag
#        git.update-environment-tag ENV=uat VERSION=v2.0.31
git.update-environment-tag:
	git tag --force $(ENV) $(VERSION)
	git push --force --no-verify origin tag $(ENV)

## Upload build artefact to AWS
upload: $(VENV)
	@echo "Task: upload Hippo $(VERSION) build distribution to S3 bucket"
	aws s3 \
		cp ../target/website-$(VERSION)-cms-distribution.tar.gz \
		s3://artefacts.mgt.nhsd.io/hippo_authoring/$(VERSION)/website.tgz
	aws s3 \
		cp ../target/website-$(VERSION)-site-distribution.tar.gz \
		s3://artefacts.mgt.nhsd.io/hippo_delivery/$(VERSION)/website.tgz

## Upload distribution file to ondemand sftp server
ondemand.upload:
	echo "put ../target/website-$(VERSION)-on-demand-distribution.tar.gz /uploads/dists/$(VERSION).tar.gz" \
		| sftp nhs@static.hosting.onehippo.com

## Deploy to OnDemand environment
# Usage: make ondemand.deploy ENV=tst RD_CONF=my-rd.conf
#        make ondemand.deploy ENV=uat RD_CONF=my-rd.conf
#        make ondemand.deploy ENV=prd RD_CONF=my-rd.conf
#
#        manually specify version (previously uploaded to on-demand)
#        make ondemand.deploy ENV=tst VERSION=v2.0.10 RD_CONF=my-rd.conf
ondemand.deploy: vendor/rd
	source $(RD_CONF) && vendor/rd run \
		--project nhs \
		--job "jobs/$(OD_ENV)/Deploy" \
		-- \
		-bootstrap true \
		-distribution "$(VERSION).tar.gz"

ondemand.pipeline-deploy: vendor/rd
	source vendor/rd run \
		--project nhs \
		--job "jobs/$(OD_ENV)/Deploy" \
		-- \
		-bootstrap true \
		-distribution "$(VERSION).tar.gz"

## Schedule deployment of the "rc" tag for next working day
# Please make note this does not take into account bank holidays.
#
# Usage: make ondemand.schedule-deploy ENV=tst
#        make ondemand.schedule-deploy ENV=uat RD_CONF=my-rd.conf
#
#        3am (2am UTC) automated deploy on 28th Feb
#        make ondemand.schedule-deploy ENV=uat RD_CONF=my-rd.conf RELEASE_DATE=2018-02-28 RELEASE_TIME_UTC=02:00:00
ondemand.schedule-deploy: vendor/rd
	source $(RD_CONF) && vendor/rd run \
		--at "$(RELEASE_DATE)T$(RELEASE_TIME_UTC)Z"\
		--project nhs \
		--job "jobs/$(OD_ENV)/Deploy" \
		-- \
		-bootstrap true \
		-distribution "$$(git describe --tags --match $(VERSION_BASE)* rc).tar.gz"

ondemand.restart: vendor/rd
	vendor/rd run -p nhs -j "jobs/$(OD_ENV)/Control" -- \
		-action restart

deploy.vagrant: build
	cp ../target/website-$(VERSION)-site-distribution.tar.gz $(BUILD_DIR)/.artefacts/
	cp ../target/website-$(VERSION)-cms-distribution.tar.gz $(BUILD_DIR)/.artefacts/
	cd $(BUILD_DIR) && ROLE=hippo_authoring vagrant ssh -c "/home/hippo_authoring/shipit /vagrant/.artefacts/website-$(VERSION)-cms-distribution.tar.gz"

## Create new version tag based on the nearest tag
version.bumpup:
	@git fetch --tags
	@git tag $$((git describe --abbrev=0 --tags --match "$$(cat ../.version)*" || echo $$(cat ../.version).-1) | perl -pe 's/^(v(\d+\.)*)(-?\d+)(.*)$$/$$1.($$3+1).$$4/e')
	$(MAKE) version.pprint
	@echo "Remember to push new tag to remote server."

## Prints current version
version.print:
	@echo "$(VERSION)"

## Pretty prints current version
version.pprint:
	@echo "- - -"
	@echo "Current version: $(VERSION)"
	@echo "- - -"

## Ensure that commit message contains JIRA id
check.commit-msg:
	@git log -n1 --no-merges --pretty=%B > $(PWD)/.commit-msg
	@head -n1 $(PWD)/.commit-msg | grep -E "^\[[A-Z]+-[0-9]+\]" || (echo "Missing JIRA id in the coomit message. Expecitng '[ABC-123] ...' but got" && cat .commit-msg && exit 1)
	python $(PWD)/../.git-local/hooks/commit-msg $(PWD)/.commit-msg
	@rm $(PWD)/.commit-msg

## Ensure that `make format-yaml` was run
check.yaml:
	cd .. && make format-yaml
	@if git status | grep ".yaml" | grep "modified"; then \
		echo "Modified yaml files found. Run 'make format-yaml' before submiting pull request."; \
		exit 1; \
	else \
		echo "No YAML changes."; \
	fi

## Notify the slack release channel of the commits in the upcoming release
notify.slack:
	curl -X POST --data-urlencode "payload={\"text\": \"Release to production has been scheduled at 12:05 on the next working day. The following new changes (if any) will be released:\n\n$$(git log --format="* %s. [Author %an]" prd..rc)\"}" https://hooks.slack.com/services/${SLACK_HOOK_URL}

## Clean up
clean:
	mvn clean $(MVN_OPTS) --quiet

# Install Rundec CLI
vendor/rd: vendor
	cd vendor && curl -LO https://github.com/rundeck/rundeck-cli/releases/download/v1.0.25/rundeck-cli-1.0.25-all.jar
	echo -e "#!/bin/bash \nDIR=\$$( cd \"\$$( dirname \"\$${BASH_SOURCE[0]}\" )\" && pwd ) \njava -jar \$${DIR}/rundeck-cli-1.0.25-all.jar \$$@" > vendor/rd
	chmod +x vendor/rd

vendor:
	mkdir -p vendor

# get python virtualenv
$(VENV):
	@which virtualenv > /dev/null || (\
		echo "please install virtualenv: http://docs.python-guide.org/en/latest/dev/virtualenvs/" \
		&& exit 1 \
	)
	virtualenv $(VENV)
	$(VENV)/bin/pip install -U "pip<9.0"
	$(VENV)/bin/pip install pyopenssl urllib3[secure] requests[security]
	$(VENV)/bin/pip install -r requirements.txt --ignore-installed
	virtualenv --relocatable $(VENV)

.phony:
