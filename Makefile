include env.mk
include vars.mk

export HOME

ifneq ($(HIPPO_MAVEN_USERNAME),)
MVN_OPTS ?= ${MVN_VARS} --global-settings "$(PWD)/.mvn.settings.xml"
endif
MVN_OPTS ?= ${MVN_VARS}

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)

## Initialise local project
init: .git/.local-hooks-installed

## Clean, build and start local hippo
# Clean and recompile only modules that we do customise.
serve: essentials/target/essentials.war
	mvn clean verify $(MVN_OPTS) \
	-am -DskipTests=true \
	-pl site/components,site/webapp,cms,repository-data/development,repository-data/site-development,repository-data/local
	$(MAKE) run

## Serve without allowing auto-export
# Clean and recompile only modules that we do customise.
serve.noexport: essentials/target/essentials.war
	mvn clean verify $(MVN_OPTS) \
	-am -DskipTests=true \
	-pl site,cms,repository-data/development,repository-data/local
	$(MAKE) run PROFILE_RUN=cargo.run,without-autoexport

## Start server using cargo.run
run:
	mvn $(MVN_OPTS) -P $(PROFILE_RUN) $(REPO_PATH)

# we don't have to recompile it every time.
essentials/target/essentials.war:
	mvn clean verify $(MVN_OPTS) -pl essentials -am --offline -DskipTests=true

## Run acceptance tests against already running server (`make serve`)
test.site-running:
	mvn verify $(MVN_OPTS) -f acceptance-tests/pom.xml \
		-Pacceptance-test \
		-Dcucumber.options="src/test/resources/features/site"

## Run only acceptance tests tagged with "WIP"
# This target requires a running site instance (e.g. `make serve.noexport`)
test.wip:
	mvn verify $(MVN_OPTS) -f acceptance-tests/pom.xml \
		-Pacceptance-test \
		-Dheadless=false \
		-Dcucumber.options="src/test/resources/features --tags @WIP" \

## Generate a number of test docs and users for S3 performance testing
# Optional argument TEST_DOCS_COUNT=X specifies the number of Legacy Publication YAML files to
# generate in local module, ready for bootstrapping; if the argument is not provided then the number
# is by default 100.
#
# See 'test-s3-performance.md' for more details.
prep.s3-perf-test-data:
	mvn gplus:execute@generate-s3-perf-test-docs $(MVN_OPTS) \
		-pl repository-data/local \
		-DdocumentCount=$(TEST_DOCS_COUNT) \

## Run S3 performance tests - only those tagged with "WIP"
# This target requires a running site instance (e.g. `make serve.noexport`)
# To target instances other than the default one running on localhost,
# provide CMS_URL=<your-url-here> and/or SITE_URL=<your-site-url-here>
test.s3-perf:
	mvn verify $(MVN_OPTS) -f acceptance-tests/pom.xml \
		-Pacceptance-test \
		-Dheadless=false \
		-Dcucumber.options="src/test/resources/s3-performance --tags @WIP" \
		-DcmsUrl=$(CMS_URL) \
		-DsiteUrl=$(SITE_URL) \

## Format YAML files, run after exporting to reduce changes
format-yaml:
	mvn gplus:execute@format-yaml $(MVN_OPTS) \
		-pl repository-data/local

## Update maven dependency versions
update-dependencies:
	mvn verify $(MVN_OPTS) versions:update-parent versions:use-latest-versions versions:update-properties versions:commit -U -DskipTests=true

## proxy all other targets to ci-cd/Makefile
# Usage: make test
#        make test.site
#        make test.unit
%:
	$(MAKE) -C ci-cd/ $@

# install hooks and local git config
.git/.local-hooks-installed:
	@bash .git-local/install

env.mk:
	touch env.mk

frontend:
	cd repository-data/webfiles && npm install && NODE_ENV=development npm start
