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
             * Copyright © <%= grunt.template.today("yyyy") %> <%= pkg.author %>
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
            less: 'src/less/stylesheet.less'
            tpls: {
                ctpl: [ 'src/template/**/*.html' ]
                atpl: [ 'src/views/**/*.html' ]
            }

        vendor:
            js: [
                'vendor/jquery/jquery.js'
                'vendor/angular/angular.min.js'
                'vendor/angular-cookies/angular-cookies.min.js'
                'vendor/angular-resource/angular-resource.min.js'
                'vendor/angular-ui/bootstrap/ui-bootstrap-0.3.0.js'
            ]

        clean:
            tmp: [ '.tmp' ]
            build: [ '<%= buildDir %>' ]
            assets: [ '<%= buildDir %>/assets' ]

        copy:
            assets:
                files: [
                    expand: true
                    cwd: 'src/assets/'
                    src: [ '**' ]
                    dest: '<%= buildDir %>'
                ]
        recess:
            build:
                src: [ '<%= src.less %>' ],
                dest: '<%= buildDir %>/styles/<%= pkg.name %>.css',
                options:
                    compile: true
                    compress: true

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
            tpls:
                src: [ '<%= src.tpls.ctpl %>', '<%= src.tpls.atpl %>' ]
                dest: '<%= buildDir %>/scripts/ui-bootstrap.tpls.js'
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
            build:
                options:
                    banner: '<%= meta.banner %>'
                files:
                    '<%= buildDir %>/scripts/<%= pkg.name %>.min.js': [ '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js' ]
            tpls:
                files:
                    '<%= buildDir %>/scripts/ui-bootstrap.tpls.min.js': '<%= buildDir %>/scripts/ui-bootstrap.tpls.js'

        delta:
            options:
                livereload: true
            assets:
                files: [ 'src/assets/**' ]
                tasks: [ 'clean:assets', 'copy:assets' ]
            tpls:
                files: [ '<%= src.tpls.ctpl %>', '<%= src.tpls.atpl %>' ]
                tasks: [
                    'html2js'
                    'uglify:tpls'
                ]
            coffee:
                files: [ '<%= src.coffee %>' ]
                tasks: [
                    'coffee:build'
                    'concat:build'
                    'ngmin:build'
                    'uglify:build'
                    'timestamp'
                ]
            less:
                files: [ '<%= src.less %>' ],
                tasks: [ 'recess' ]

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
        'concat'
        'ngmin:build'
        'jshint'
        'html2js'
        'uglify'
        'recess'
        'copy'
    ]

    grunt.registerTask 'build-coffee', [
        'clean:tmp'
        'coffee:build'
        'concat:build'
        'ngmin:build'
        'jshint'
        'uglify:build'
    ]
