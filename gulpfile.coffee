'use strict'
gulp = require 'gulp'
uglify = require 'gulp-uglify'
livereload = require 'gulp-livereload'
csso = require 'gulp-csso'
cleanhtml = require 'gulp-cleanhtml'
browserify = require 'gulp-browserify'
rename     = require 'gulp-rename'
watch      = require 'gulp-watch'
plumber    = require 'gulp-plumber'

gulp.task 'default', ->
  gulp.start 'build'

gulp.task 'test', ->

gulp.task 'scripts', ->
  gulp.src [ 'app/js/*.js' ]
  .pipe uglify()
  .pipe gulp.dest 'dist/js'

#gulp.task 'styles', ->
#  gulp.src [ 'app/sass/**/*.scss' ]
#    .pipe sass style: 'expanded'
#    .pipe gulp.dest 'app/css'
#  gulp.src 'app/css/**/*.css'
#    .pipe gulp.dest 'dist/css'
#    .pipe csso()
#    .pipe gulp.dest 'dist/css/min'

gulp.task 'pages', ->
  gulp.src 'app/*.html'
  .pipe cleanhtml()
  .pipe gulp.dest 'dist'

gulp.task 'coffee', ->
  gulp
  .src 'app/js/index.coffee', read: false
  .pipe plumber()
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
    debug: true
  .pipe rename 'app.js'
  .pipe gulp.dest './dist/js'

#gulp.task 'watch', ->
#  gulp.watch('app/**/*.coffee', ['coffee'])


gulp.task 'build', [
  'scripts'
#  'styles'
  'pages'
  'coffee'
]
gulp.task 'server', ->
  connect = require('connect')
  server = connect()
  server.use(connect.static('dist')).listen process.env.PORT or 9122
  require('opn') 'http://localhost:' + (process.env.PORT or 9122)
gulp.task 'watch', [ 'server' ], ->
  gulp.start 'build'
#  gulp.watch 'app/sass/**/*.scss', [ 'styles' ]
  gulp.watch 'app/js/**/*.js', [ 'scripts' ]
  gulp.watch 'app/*.html', [ 'pages' ]
  gulp.watch('app/**/*.coffee', ['coffee'])
  server = livereload()
  gulp.watch('dist/**').on 'change', (file) ->
    server.changed file.path

