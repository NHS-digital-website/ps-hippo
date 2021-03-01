// Include gulp
const del = require("del");
const browsersync = require("browser-sync").create();
const postcss = require("gulp-postcss");
const sass = require("gulp-dart-sass");
const stylelint = require("gulp-stylelint");
const eslint = require("gulp-eslint");
const named = require("vinyl-named");
const webpack = require("webpack-stream")

const autoprefixer = require("autoprefixer");
const cssnano = require("cssnano");

const {task, src, dest, series, watch, parallel} = require("gulp");

const isDev = process.env.NODE_ENV && process.env.NODE_ENV === "development";
const isProd = process.env.NODE_ENV && process.env.NODE_ENV === "production";

const devRoot = 'localhost:8080';
const webfileRoot = "src/main/resources/site";
const paths = {
    js: `${webfileRoot}/src/js`,
    scss: `${webfileRoot}/src/scss`,
    dist: `${webfileRoot}/dist`
};

task('clean', function () {
    return del([paths.dist])
});

task("lint-js", function () {
    return src(`${paths.js}/**/*.js`)
        .pipe(
            eslint({
                fix: true
            })
        )
        .pipe(eslint.format())
        .pipe(eslint.failAfterError());
});

task("lint-scss", function lintCssTask() {
    return gulp.src(`${paths.scss}/**/*.scss`).pipe(
        stylelint({
            reporters: [{formatter: "string", console: true}]
        })
    );
});

const postCssPlugins = [autoprefixer];

if (!isDev) {
    postCssPlugins.push(cssnano);
}

task("build-css", function processScss() {
    return src(`./${paths.scss}/*.scss`, {sourcemaps: isDev})
        .pipe(sass().on("error", sass.logError))
        .pipe(postcss(postCssPlugins))
        .pipe(dest(`./${paths.dist}`, {sourcemaps: isDev ? '.' : false}))
        .pipe(browsersync.stream())
});

// Concatenate && Minify JS
task("build-js", function gulpScripts() {
    // eslint-disable-next-line global-require
    const webpackConfig = require("./webpack.config.js");
    webpackConfig.output.path = `/${paths.js}`;

    return src([
        `${paths.js}/nhsd-priority-scripts.js`,
        `${paths.js}/nhsd-scripts.js`,
        `${paths.js}/nhsd-frontend-scripts.js`,
        `${paths.js}/intranet-scripts.js`,
    ])
        .pipe(named())
        .pipe(
            webpack({
                config: webpackConfig
            }).on('error', (err) => {
                console.log(err.message);
                this.emit('end'); // Recover from errors
            })
        )
        .pipe(dest(paths.dist))
});

task("lint", parallel("lint-js", "lint-scss"));

task("scss", series("lint-scss", "build-css"));
task("scripts", series("lint-js", "build-js"));

task('build', series('clean', parallel('build-css', 'build-js')));

// create a task that ensures the `js` task is complete before
// reloading browsers
task("script-watch", series("build-js", function scriptWatch(done) {
    browsersync.reload();
    done();
}));

// Watch Files For Changes
task('watch', function (done) {

    browsersync.init({
        proxy: `http://${devRoot}/site`,
        rewriteRules: [
            // Allow Bloomreach to reload on FTL change
            {
                match: /return "ws:\/\/" \+ document.location.host \+ CONTEXT_PATH \+ AUTO_RELOAD_PATH;/g,
                fn() {
                    return `return "ws://${devRoot}" + CONTEXT_PATH + AUTO_RELOAD_PATH;`;
                }
            }
        ]
    });

    watch(`${paths.scss}/**/*.scss`, series('build-css'));
    watch(`${paths.js}/**/*.js`, series('script-watch'));
    done();
});

task('default', series('build', 'watch'));
