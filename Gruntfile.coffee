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
            tpls: [ 'src/views/**/*.html', 'src/coffee/**/*.html' ]

        vendor:
            js: [
                'vendor/jquery/jquery.js'
                'vendor/foundation/foundation.min.js'
                'vendor/angular/angular.min.js'
                'vendor/angular-cookies/angular-cookies.min.js'
                'vendor/angular-resource/angular-resource.min.js'
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
                files: [
                    expand: true,
                    cwd: 'src/coffee',
                    src: [ '**/*.coffee' ],
                    dest: '.tmp/scripts/',
                    ext: '.js'
                ]

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
                src: [
                    '<%= src.tpls %>'
                ]
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.tpls.js'
                module: '<%= pkg.name %>.tpls'

        jshint:
            files: [
                '.tmp/scripts/**/*.js'
                '<%= buildDir %>/scripts/<%= pkg.name %>.js'
                '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js'
            ]
            options:
                curly: true
                eqeqeq: true
                immed: true
                latedef: true
                newcap: true
                noarg: true
                sub: true
                boss: true
                eqnull: true
                globals:
                    $: true
                    jQuery: true
                    angular: true

        # Minify the sources!
        uglify:
            build:
                options:
                    banner: '<%= meta.banner %>'
                files:
                    '<%= buildDir %>/scripts/<%= pkg.name %>.min.js': [ '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js' ]
            tpls:
                files:
                    '<%= buildDir %>/scripts/<%= pkg.name %>.tpls.min.js': '<%= buildDir %>/scripts/<%= pkg.name %>.tpls.js'

        delta:
            options:
                livereload: true
            assets:
                files: [ 'src/assets/**' ]
                tasks: [ 'clean:assets', 'copy:assets' ]
            tpls:
                files: [ '<%= src.tpls %>' ]
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
                ]
            less:
                files: [ '<%= src.less %>' ],
                tasks: [ 'recess' ]


    grunt.renameTask 'watch', 'delta'
    grunt.registerTask 'watch', [
        'build'
        'delta'
    ]

    # The default task is to build.
    grunt.registerTask 'default', [ 'build' ]
    grunt.registerTask 'build', [
        'clean'
        'recess'
        'coffee:build'
        'concat'
        'ngmin:build'
        'jshint'
        'html2js'
        'uglify'
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
