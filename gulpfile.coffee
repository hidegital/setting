'use strict'
gulp = require 'gulp'
uglify = require 'gulp-uglify'
livereload = require 'gulp-livereload'
csso = require 'gulp-csso'
cleanhtml = require 'gulp-cleanhtml'
browserify = require 'gulp-browserify'
browserSync = require 'browser-sync'
rename     = require 'gulp-rename'
watch      = require 'gulp-watch'
plumber    = require 'gulp-plumber'
stylus      = require 'gulp-stylus'
ejs = require 'gulp-ejs'
gutil = require 'gulp-util'
DEST = "./dist"
APP = "./app"
paths =
  js: ["#{APP}/**/*.coffee"]
  css: ["#{APP}/**/*.styl", "!#{APP}/**/spriteSp*.styl", "!#{APP}/**/_**/*.styl"]
#  img: ["#{SRC}/**/*.{png,jpg,gif}", "!#{SRC}/**/spriteSp/**/*.png"]
  html: ["#{APP}/ejs/**/*.ejs","!" + "#{APP}/ejs/**/_*.ejs"]
  reload: ["#{DEST}/**/*", "!#{DEST}/**/*.css"]
#  sprite: "#{SRC}/**/sprite/**/*.png"
#  spriteSp: "#{SRC}/**/spriteSp/**/*.png"

nib = require 'nib'
#gulp.task 'stylus', ['sprite'], ->
gulp.task 'stylus', ->
  gulp.src paths.css
  .pipe plumber()
  .pipe stylus use: nib(), errors: true
  .pipe gulp.dest DEST
  #.pipe browserSync.reload stream: true
gulp.task 'ejs', ->
  gulp.src paths.html
  .pipe ejs()
  .pipe gulp.dest DEST

gulp.task 'coffee', ->
  gulp
  .src paths.js, read: false
  .pipe plumber()
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
    debug: true
  .pipe rename 'app.js'
  .pipe gulp.dest './dist/js'

gulp.task 'browserSync', ->
  browserSync
    startPath: 'index.html'
    server: baseDir: DEST

gulp.task 'watch', ->
  gulp.watch paths.js, ['coffee']
  gulp.watch paths.css, ['stylus']
  gulp.watch paths.html, ['ejs']
  gulp.watch paths.reload, -> browserSync.reload once: true

gulp.task 'build', [
#  'scripts'
  'stylus'
  'coffee'
  'ejs'
]

gulp.task 'default', ['watch', 'browserSync']