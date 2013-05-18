'use strict'

module.exports = (grunt) ->
    require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

    grunt.initConfig
        buildDir: 'build'
        tmpDir: '.tmp'
        pkg: grunt.file.readJSON 'package.json'
        meta:
            banner:"""
            /**
             * <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %>
             * <%= pkg.homepage %>
             *
             * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author %>
             * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>
             */\n"""
        ###
            This is a collection of file definitions we use in the configuration of
            build tasks. `js` is all project javascript, less tests. `atpl` contains
            our reusable components' template HTML files, while `ctpl` contains the
            same, but for our app's code. `html` is just our main HTML file and 
            `less` is our main stylesheet.
        ###
        src:
            coffee: [ 'src/coffee/**/*.coffee', '!src/coffee/**/*.spec.coffee' ]
            less: 'src/less/main.less'
            tpl: {
                cmp: [ 'src/template/**/*.html' ]
            }

        vendor:
            js: [
                'vendor/jquery/jquery.js'
                'vendor/angular/angular.min.js'
                'vendor/angular-cookies/angular-cookies.min.js'
                'vendor/angular-resource/angular-resource.min.js'
            ]

        clean:
            tmp: [ '.tmp' ]
            build: [ '<%= buildDir %>' ]

        recess:
            build:
                src: [ '<%= src.less %>' ],
                dest: '<%= buildDir %>/styles/<%= pkg.name %>.css',
                options:
                    compile: true
                    compress: true
                    noUnderscores: false
                    noIDs: false
                    zeroUnits: false

        coffee:
            build:
                options:
                    bare: true
                    join: true
                files:
                    '.tmp/scripts/<%= pkg.name %>.js': [ '<%= src.coffee %>' ]

        concat:
            build:
                options:
                    banner: '<%= meta.banner %>'
                src: [
                    'module.prefix'
                    '.tmp/scripts/**/*.js'
                    'module.suffix'
                ]
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.js'
            libs:
                src: [ '<%= vendor.js %>' ]
                dest: '<%= buildDir %>/scripts/libs.js'

        # Annotate angular sources
        ngmin:
            build:
                src: [ '<%= buildDir %>/scripts/<%= pkg.name %>.js' ]
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js'

        html2js:
            app:
                src: [ '<%= src.tpl.cmp %>' ]
                dest: '.tmp/bootstrap.tpls.js'
                module: 'ui.bootstrap.tpls'

        jshint:
            files: [
                '<%= buildDir %>/scripts/<%= pkg.name %>.js'
                '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js'
            ]
            options:
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                boss: true,
                eqnull: true,
                globals: {}

        ###
            Minify the sources!
        ###
        uglify:
            options:
                banner: '<%= meta.banner %>'
            build:
                files:
                    '<%= buildDir %>/scripts/<%= pkg.name %>.min.js': [ '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js' ]

        delta:
            options:
                livereload: true
            coffee:
                files: [ '<%= src.coffee %>' ]
                tasks: [
                    #'karma:unit:run'
                    'coffee:build'
                    'concat:build'
                    'ngmin:build'
                    'uglify:build'
                    'timestamp'
                ]
            less:
                files: [ '<%= src.less %>' ],
                tasks: [ 'recess', 'timestamp' ]

    #Print a timestamp (useful for when watching)
    grunt.registerTask 'timestamp', ->
        grunt.log.subhead Date()

    grunt.renameTask 'watch', 'delta'
    grunt.registerTask 'watch', [
        'build'
        'delta'
    ]

    # The default task is to build.
    grunt.registerTask 'default', [ 'build' ]
    grunt.registerTask 'build', [
        'clean'
        'coffee:build'
        #'html2js'
        #'karma:continuous'
        'concat'
        'ngmin:build'
        'jshint'
        'uglify'
        'recess'
        #'index'
        #'copy'
    ]

    grunt.registerTask 'build-coffee', [
        'clean:tmp'
        'coffee:build'
        'concat:build'
        'ngmin:build'
        'jshint'
        'uglify:build'
    ]
