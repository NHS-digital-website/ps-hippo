AWS_KEY ?=
AWS_SECRET ?=
GOOGLE_RECAPTCHA_SECRET_KEY ?=
HIPPO_MAVEN_PASSWORD ?=
HIPPO_MAVEN_USERNAME ?=
HOME ?= $(shell printenv HOME)
PWD = $(shell pwd)
SPLUNK_HEC ?= localhost
SPLUNK_TOKEN ?=
SPLUNK_URL ?= http://localhost
PROFILE_RUN ?= cargo.run
S3_BUCKET ?= files.local.nhsd.io
S3_REGION ?= eu-west-1

# Path to local JCR database. Configuring it means no longer losing local documents between
# 'make serve' sessions.
# Set it to '-Drepo.path=storage' in env.mk to have the dir automatically created for you
# within the project directory. This name is ignored by git, so you're not risking
# committing it by accident.
REPO_PATH ?=

# Settings related to automated imports of OAS specifications
# into API Specification documents from Apigee.
# Override relevant variables (typically only APIGEE_USER, APIGEE_PASS and APIGEE_OTPKEY)
# in env.mk if you actually need to work on this integration.
#
# Note that the default value of APIGEE_BASIC is not really a secret,
# as it is a static, publicly available header value required by Apigee to obtain
# OAuth2 access and refresh tokens:
# https://docs.apigee.com/api-platform/system-administration/management-api-tokens#note
#
# Both cron expression variables below will need to have a property set in the system to
# enable the scheduled jobs in a local CMS instance. In order to keep this out of version
# control, we recommend setting both variables in env.mk as needed, e.g.
# 	APIGEE_SYNC_CRON = 0 0/2 * ? * *
# 	APIGEE_RERENDER_CRON = 0 1/1 * ? * *

APIGEE_SYNC_CRON ?=
APIGEE_RERENDER_CRON ?=
APIGEE_TOKEN_URL ?= https://login.apigee.com/oauth/token
APIGEE_SPECS_ALL_URL ?= https://apigee.com/dapi/api/organizations/nhsd-nonprod/specs/folder/home
APIGEE_SPECS_ONE_URL ?= https://apigee.com/dapi/api/organizations/nhsd-nonprod/specs/doc/{specificationId}/content
APIGEE_USER ?= REPLACE_WITH_ACTUAL_APIGEE_USERNAME
APIGEE_PASS ?= REPLACE_WITH_ACTUAL_APIGEE_PASSWORD
APIGEE_OTPKEY ?= REPLACE_WITH_ACTUAL_APIGEE_OTPKEY
APIGEE_BASIC ?= ZWRnZWNsaTplZGdlY2xpc2VjcmV0

#-Dsplunk.token=$(SPLUNK_TOKEN) \
#	-Dsplunk.url=$(SPLUNK_URL) \
#	-Dsplunk.hec.name=$(SPLUNK_HEC) \

MVN_VARS = -Ddynamic.bean.generation=false \
	-Dexternalstorage.aws.bucket=$(S3_BUCKET) \
	-Dexternalstorage.aws.region=$(S3_REGION) \
	-Dspring.profiles.active=local \
    "-Ddevzone.apispec.sync.daily-cron-expression=$(APIGEE_SYNC_CRON)" \
    "-Ddevzone.apispec.sync.nightly-cron-expression=$(APIGEE_RERENDER_CRON)" \
    -Ddevzone.apigee.resources.specs.all.url=$(APIGEE_SPECS_ALL_URL) \
    -Ddevzone.apigee.resources.specs.individual.url=$(APIGEE_SPECS_ONE_URL) \
	-Ddevzone.apigee.oauth.token.url=$(APIGEE_TOKEN_URL)

export AWS_ACCESS_KEY_ID=$(AWS_KEY)
export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET)
export GOOGLE_CAPTCHA_SECRET=$(GOOGLE_RECAPTCHA_SECRET_KEY)
export HIPPO_MAVEN_PASSWORD
export HIPPO_MAVEN_USERNAME
export DEVZONE_APIGEE_OAUTH_USERNAME=$(APIGEE_USER)
export DEVZONE_APIGEE_OAUTH_PASSWORD=$(APIGEE_PASS)
export DEVZONE_APIGEE_OAUTH_BASICAUTHTOKEN=$(APIGEE_BASIC)
export DEVZONE_APIGEE_OAUTH_OTPKEY=$(APIGEE_OTPKEY)
