'use strict'

module.exports = (grunt) ->
    require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
    require('time-grunt')(grunt)

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
        app:
            scripts: 'app/scripts/**/*.coffee'
            styles: 'app/styles/stylesheet.less'
            tpls: 'app/scripts/**/*.html'

        vendor:
            angular: [
                'app/bower_components/angular/index.js'
                'app/bower_components/angular-route/index.js'
                'app/bower_components/angular-resource/index.js'
                'app/bower_components/angular-animate/index.js'
                'app/bower_components/angular-cookies/index.js'
            ]
            twitter: [ 'app/bower_components/twitter/js/*.js' ]
            jquery: 'app/bower_components/jquery/jquery.min.js'

        clean:
            tmp: [ '.tmp' ]
            build: [ '<%= buildDir %>' ]
            assets: [ '<%= buildDir %>/assets' ]

        copy:
            assets:
                files: [
                    expand: true
                    cwd: 'app/assets/'
                    src: [ '**' ]
                    dest: '<%= buildDir %>'
                ]
        recess:
            build:
                options:
                    compile: true
                    compress: true
                src: [ '<%= app.styles %>' ],
                dest: '<%= buildDir %>/styles/<%= pkg.name %>.css',

        coffee:
            build:
                options:
                    sourceMap: true
                src: '<%= app.scripts %>'
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.js'

        concat:
            vendor:
                src: [
                    '<%= vendor.jquery %>'
                    '<%= uglify.twitter.dest %>'
                    '<%= vendor.angular %>'
                ]
                dest: '<%= buildDir %>/scripts/libs.js'

        # Annotate angular sources
        ngmin:
            build:
                src: '<%= coffee.build.dest %>'
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.annotated.js'

        html2js:
            tpls:
                options:
                    base: 'app/scripts'
                    module: '<%= pkg.name %>.tpls'
                src: '<%= app.tpls %>'
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.tpls.js'

        # Minify the sources!
        uglify:
            twitter:
                dest: '.tmp/scripts/twitter.min.js'
                src: '<%= vendor.twitter %>'
            build:
                options:
                    banner: '<%= meta.banner %>'
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.min.js'
                src: [
                    '<%= html2js.tpls.dest %>'
                    '<%= ngmin.build.dest %>'
                ]

        delta:
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
        'coffee'
        'html2js'
        'ngmin'
        'uglify'
        'concat'
        'copy'
    ]
