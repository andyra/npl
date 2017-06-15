module.exports = (grunt) ->

  # Project configuration
  grunt.initConfig

    coffee:
      compile:
        options:
          join: true
        files: [
          'assets/javascripts/shared/shared.js': 'assets/javascripts/shared/_*.coffee'
          'assets/javascripts/pages/pages.js': 'assets/javascripts/pages/_*.coffee'
        ]

    concat:
      dist:
        src: [
          # Manual dependency ordering (put specific files first)
          'assets/javascripts/vendor/moment.js'
          'assets/javascripts/vendor/jquery.min.js'
          'assets/javascripts/vendor/fullcalendar.js'
          'assets/javascripts/vendor/gcal.js'
          'assets/javascripts/vendor/*.js'
          'assets/javascripts/shared/*.js'
          'assets/javascripts/pages/*.js'
        ]
        dest: 'assets/javascripts/npl.min.js'

    uglify:
      dist:
        src: '<%= concat.dist.dest %>'
        dest: '<%= concat.dist.dest %>' # Stomp over the file

    jshint:
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        unused: true
        boss: true
        eqnull: true
        browser: true
        globals: {}

    autoprefixer:
      dist:
        options:
          browsers: ['last 2 versions', '> 5%', 'Firefox ESR']
        src: ['assets/stylesheets/npl.min.css']

    notify:
      sass:
        options:
          title: "Task Complete"
          message: "SASS finished compiling!"

    sass:
      dist:
        options:
          style: 'compressed'
          quiet: false
          sourcemap: 'auto'
          loadPath: require('node-neat').includePaths
        files: ['assets/stylesheets/npl.min.css': 'assets/stylesheets/npl.scss']

    watch:
      options:
        livereload: true
      stylesheets:
        files: ['assets/stylesheets/**/*.scss']
        tasks: ['sass', 'autoprefixer']
      coffeescripts:
        files: ['assets/javascripts/**/*.coffee']
        tasks: ['coffee', 'jshint', 'concat', 'uglify']
      javascripts:
        files: [
          'assets/javascripts/pages/**/*.js'
          'assets/javascripts/shared/**/*.js'
          'assets/javascripts/vendor/**/*.js'
        ]
        tasks: ['jshint', 'concat', 'uglify']

    svgmin:
      options:
        plugins: [
          { removeViewBox: false }
          { removeUselessStrokeAndFill: true }
          { cleanupIDs: false }
        ]
      dist:
        files:
          'assets/images/sprite.svg' : 'assets/images/sprite.svg'

    svgstore:
      options:
        formatting:
          indent_size: 2
      default:
        files:
          'assets/images/sprite.svg': 'assets/images/sprite/*.svg'


  # Load all Grunt tasks automatically
  require('load-grunt-tasks') grunt

  # Register tasks
  grunt.registerTask 'default', ['coffee', 'jshint', 'concat', 'uglify', 'sass', 'autoprefixer', 'watch']
  grunt.registerTask 'scripts', ['coffee', 'jshint', 'concat', 'uglify']
  grunt.registerTask 'styles', ['sass', 'autoprefixer']
  grunt.registerTask 'sprite', ['svgstore', 'svgmin']
