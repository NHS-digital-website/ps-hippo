# NHS Digital Website - Hippo CMS

[![Build Status][build-status]][travis-project-page]

* To setup this project run `make init`.
* To run an initial build of all modules run `mvn clean verify` (only need to do this once).
* To start local server `make serve`.
* To run all tests `make test`.
* To get more help, simply run `make help`.

Set `REPO_PATH = -Drepo.path=storage` in `env.mk` to preserve your local docs between `make serve` sessions.
This creates `storage` directory within the project directory, that contains your local CMS database.
The directory is ignored by git, so you're not risking committing it by accident. If you need to start with
clean slate, simply delete the directory and it will be recreated on the next run.


## Key Maven Build Operations

This project uses [Maven] as its build system. Unless stated otherwise, instructions below assume that Maven commands
will be executed from command line in the directory of the parent module.

The [IDE] of your choice may offer alternate (sometimes more convenient) mechanisms to execute those or similar
commands, so it's worth spending some time to explore its capabilities. In particular, [IntelliJ] is able to target
[Junit] tests without involving Maven, giving a more graphical feedback on the tests' status combined with the ability
to automatically re-run the tests whenever the code changes. It also offers the option of saving commonly used commands
as [Run Configurations][IntelliJ Run Configurations] for quick and easy recall.

Note: whenever you execute an operation that involves starting up the application, make sure you don't have an instance
of it already running in the background or the server will fail to start, complaining about the port being already
used.

To run:

**Unit tests**:
```
mvn test
```

**Full suite of tests**:
```
mvn verify -Pacceptance-test-hippo,acceptance-test
```
This will execute both unit and acceptance tests. An instance of Tomcat server will be automatically spawned and
applications under test deployed into it, prior to executing automated acceptance tests. The server will automatically
stop once the tests complete. Tomcat server gets automatically downloaded and installed in a temporary project space as
part of the build so it doesn't have to already be present in the development system.

Note that, by default, the acceptance tests will be executed in a 'headless' mode, that is no browser window will be
opened on the screen. In order to see the web browser interacted with by the automated accepance tests, disable headless
mode by adding parameter `-Dheadless=false` in the command line.

[Profile][Maven profiles] `acceptance-test` activates the tests themselves, while `acceptance-test-hippo` ensures
automatic startup and shutdown of the application.

<a name="run-hippo-standalone">**Standalone Hippo instance**:</a>

```
mvn verify
mvn -Pcargo.run
```

This will run Hippo in a standalone mode, useful during development and manual tests. The first line runs unit tests and
packages the application and the second one starts it.

Once the aplication has started, the console will display message `Press Ctrl-C to stop the Cargo container...`. You can
then access Hippo CMS by navigating to `http://localhost:8080/cms` in your web browser.

You can stop the server by following the aforementioned message and hitting `Ctrl-C` in the terminal window where you
started Hippo.

**Acceptance tests against standalone Hippo instance**

In cases where you only edit code of the acceptance tests (rather than production code), usually a lot of time can
be saved by keeping an instance of the application running in the background and execute acceptance tests repeatedly,
without having to restart the application. To do so, make sure to have the application already started and running in a
standalone mode ([see instructions above](#run-hippo-standalone)) and then, to run the tests, execute:
```
mvn verify -f acceptance-tests/pom.xml -Pacceptance-test
```

See [Automated Acceptance Tests](#automated-acceptance-tests) section for more details on how to further optimise the
development cycle when working on acceptance tests.

## Auto-export

When making changes to the CMS or console data, you may want your changes to be persisted in the yaml configuration
to be boot strapped into the application on startup. The easiest way to do this is to turn auto-export on in the CMS
(gray button on bottom left of every CMS page) or in the Console (top menu options). Make sure you turn it on before
making any of the changes and turn it off again once you are done. This will produce new/amended yaml files. You should
make sure the changes are in the correct module (`application` / `development`) creating a new file for new nodes where appropriate.

### YAML Formatter

All the yaml repository data files are formatted with a custom groovy script when the project is built.
This is to make the format consistent so when comparing changes to a previous version it is a lot eaiser
to see what has actually changed. UUIDs are also removed as these are generated by hippo dynamically on start up.
You can run the formatter manually by running `make format-yaml`.

## Updating versions

Periodically the versions of the dependencies we use should be updated to the latest versions, in order to
ensure we have the latest bug fixes and security patches. For the same reason, the version of Hippo that we
use as the parent pom should be updated whenever there is a new release.

To update versions automatically we use the [maven versions plugin](http://www.mojohaus.org/versions-maven-plugin/).
This will automatically update all dependancies and the parent pom version to the latest version avaliable.
To use this, simply run:
```
make update-dependencies
```

This will go through all the modules and sub-modules and check for newer versions for any that are specified
in the pom.

### Potential issues when upgrading Hippo version

This section should be kept up to date with all known changes we have made to the code base which require
consideration when changing parent Hippo version.

#### Document Workflow

We have our own version of the Hippo document workflow which is a copy of the out of the box workflow with
some customizations to meet our requirements. When changing hippo version there may be changes to the
document workflow which we need to implement in our forked version.

The original workflow can be sound in the sources jar:
```
hippo-repository-workflow-[VERSION]-sources.jar/hcm-config/documentworkflow.scxml
```

 Our version is located here:
```
repository-data/application/src/main/resources/hcm-config/configuration/modules/documentworkflow.scxml
```

## UI development

### Development

For best UI developer experience run the local dev server in one Terminal window, and run the frontend build process via `make frontend` in another one.

The developer may also navigate to `/repository-data/webfiles` and run the various npm scripts from there, as that allows for more granular rebuilding, i.e. of just the SCSS files. See the [UI Development document](docs/what-if/work-on-ui.md) for further information.

### Browser scope

The browser scope is based on [GDS best practices](https://www.gov.uk/service-manual/technology/designing-for-different-browsers-and-devices#browsers-to-test-in), which follows the Gov.UK service manual).

We support following browsers:
- Safari (latest version)
- Chrome (latest version)
- Firefox (latest version)
- Opera (latest version)
- MS Edge (latest version)
- IE11

### CLI commands


**Start frontend build process for local dev**

This will:

- Install NPM dependencies
- Run a gulp task which:
    - starts the SCSS compilation into CSS
    - starts the JS compilation via Webpack
    - starts Browsersync to stream in frontend changes

This requires a local installation of [Node.js](https://nodejs.org).

Note: This is aliased to `make frontend`

Please see [About the Frontend Build process](#about-the-frontend-build-process)

```bash
cd repository-data/webfiles && npm install && npm start
```

**Run the local dev server (will throw a lot of Splunk errors)**
```bash
mvn clean verify && mvn -Pcargo.run -Drepo.path=storage`
```

**Run the local dev server with quiet Splunk**

```bash
mvn -Pcargo.run -Dsplunk.hec.name=localhost -Dsplunk.url=http://localhost -Dsplunk.token= -Drepo.path=storage`
```

**Mega command**

> If you keep switching between different branches, you will have to remove the `storage` folder, then rebuild the app using the storage path and of course you'll want to quiet `splunk`...

	rm -rf storage && mvn clean verify && mvn -Pcargo.run -Dsplunk.hec.name=localhost -Dsplunk.url=http://localhost -Dsplunk.token= -Drepo.path=storage

**Both the CMS and the CMS console has their own AutoExport switch, which can be changed separately.**

#### Auto export - on/off

There are 2 ways to run the server: with or without `autoexport`. When the app runs with `autoexport` on, it exports new- and updated files triggered by CMS content updates and additions. To avoid these files accidentally being tracked by git, you better run the app without `autoexport`.



#### About the Frontend Build process

This project uses [frontend-maven-plugin](https://github.com/eirslett/frontend-maven-plugin) in order to build frontend assets as part of the Maven build. This means that backend developers **do not** need to locally install Node and run the Gulp-based build process unless they are working on SCSS or JS files.

Requirements: `node`/`npm` should be installed locally.

Quick start: `make frontend` will install dependencies, and start a build process.

For more information, read [What If I Want to Work on the UI](docs/what-if/work-on-ui.md).

#### Front-end library

> Ths project is using a styling system based on the [NHS UI library](https://github.com/nhsuk/frontend-library) for most of the UI components. The currently available release ([0.8.0](https://github.com/nhsuk/frontend-library/releases/tag/0.8.0)) is used as described in the [documentation](https://github.com/nhsuk/frontend-library#using-the-scss-directly).

There is a custom float based grid system in place. For more details on the grid system please refer to the [grid](/repository-data/webfiles/src/main/resources/site/scss/objects/_grid.scss) file.

The styling approach follows the [BEM](http://getbem.com/naming/) methodology - providing a robust naming convention and helping with the creation of reusable UI components.

The stylesheets are compiled using the modern Dart implementation of Sass. The source folder is under `repository-data/webfiles/src/main/resources/site/src/scss`, and the compiled files are created under `repository-data/webfiles/src/main/resources/site/dist`.

JavaScript is transpiled via Babel and bundled via Webpack. The source folder is under `repository-data/webfiles/src/main/resources/site/src/js` and the compiled files are created under `repository-data/webfiles/src/main/resources/site/dist`.

## Running the project for the first time

You'll need a couple of things in place to be able to successfully run the project, you can find the details [here](docs/what-if/first-time-set-up.md)

## Testing local site on VMs

In order to be able to test your localhost from a VM (such as VirtualBox) you'll have to add your IPv4 address to the server configuration. You can read how it can be done [here](docs/what-if/use-custom-host.md)

## Adding test content

Check out the [What if I want to add test content section for details][what if]

## Valtech branching strategy

Valtech follows RPS's `rebase` strategy - working off `master` branch. Once a feature branch is complete, we squash all commits on it into 1 meaningful commit and make a PR.

### Step 0 - Checkout `master` branch
```
git checkout master
git pull --rebase origin master
```

### Step 1 - Create new feature branch
```
git branch DW-XX-my-feature
git checkout DW-XX-my-feature
```

**Make changes, create new commits, work work work...**

### Step 2 - Push work to remote and keep it in line with origin
```
git pull --rebase origin DW-0000-feature // pull latest updates of the branch from origin
git push origin DW-0000-feature // push new commits to origin (might need to force push)
```

### Step 3 - Once Feature is complete, squash the commits into 1 meaningful commit and make a PR to the master branch

```
git fetch
git rebase -i origin/master
git push origin DW-0000-feature // again - might need to force push
```

## Automated Acceptance Tests

Automated acceptance tests ensure that the implementation meets functional criteria specified in the requirements.
Framework used in this project to run these tests is [Cucumber-JVM] and the tests are specified as [BDD]-style
scenarios, written in a language called [Gherkin]; see the [language's reference][Gherkin] for guidance on syntax.

See [Key Maven Build Operations](#key-maven-build-operations) for instructions how to execute the automated acceptance
tests.

**Run Only Selected Scenarios**

When you work on scenarios covering a specific feature, you don't always have to, or want to, run all the acceptance
tests in the system. In such a case, you can speed up improve your change-the-test-code/run-the-tests cycle by only
running selected Cucumber scenario(s) rather than all.

To do that:
- tag selected scenario(s) with a [custom tag][Gherkin tags] `@WIP`, placing it in the line directly preceding
  the scenario.
- run `make test.wip` this will run only the scenarios you have tagged.

Remember to remove these custom tags before executing a final complete suite of tests and
before pushing your changes to the central repo.

### Acceptance tests on Travis

Automated tests automatically run during the CI build process. Sometimes the build can fail due to acceptance tests erroring for seemingly no reason. To restart the build process, and rerun the acceptance tests, do:

    git commit --amend --no-edit
    git push -f

## More details

This Maven project has been generated using the official [Hippo Maven project archetype] v12.1.0.

Most of the project's structure has been retained with the few custom modifications described in the sections above
but you can find more details in the original README files auto-generated by the archetype:

- [top level readme][original top-level readme]
- [`repository-data` readme][original repository-data readme]

## Intranet

Information about the project under the "Intranet" channel can be found [here](docs/intranet.md). 



## What if...?

If you have a development related question, it's possible that we already have a
answer in [What If section][what if]




[original top-level readme]:        HIPPO.md
[original repository-data readme]:  repository-data/README.md
[what if]:                          docs/what-if.md
[Hippo Maven project archetype]:    https://www.onehippo.org/12/trails/getting-started/creating-a-project.html
[BDD]:                              https://en.wikipedia.org/wiki/Behavior-driven_development
[IDE]:                              https://en.wikipedia.org/wiki/Integrated_development_environment
[IntelliJ]:                         https://www.jetbrains.com/idea/
[IntelliJ Run Configurations]:      https://www.jetbrains.com/help/idea/creating-and-editing-run-debug-configurations.html
[Junit]:                            http://junit.org/junit5/
[Maven]:                            https://maven.apache.org/
[Maven profiles]:                   http://maven.apache.org/guides/introduction/introduction-to-profiles.html
[Cucumber-JVM]:                     https://cucumber.io/docs#reference
[Gherkin]:                          https://cucumber.io/docs/reference
[Gherkin tags]:                     https://cucumber.io/docs/reference#tags
[build-status]:                     https://travis-ci.org/NHS-digital-website/hippo.svg?branch=master
[travis-project-page]:              https://travis-ci.org/NHS-digital-website/hippo
