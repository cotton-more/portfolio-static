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
            twitter: 'app/bower_components/twitter/dist/js/bootstrap.min.js'
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
            vendor:
                files: [
                    expand: true
                    flatten: true
                    src: [
                        '<%= vendor.jquery %>'
                        'app/bower_components/jquery/jquery.min.map'
                        '<%= vendor.twitter %>'
                    ]
                    dest: '<%= buildDir %>/scripts/'
                ]
            angular:
                options:
                    expand: true
                    flatten: true
                files: [
                    {
                        src:'app/bower_components/angular/index.js'
                        dest: '<%= buildDir %>/scripts/angular.min.js'
                    }
                    {
                        src:'app/bower_components/angular-route/index.js'
                        dest: '<%= buildDir %>/scripts/angular-route.min.js'
                    }
                    {
                        src:'app/bower_components/angular-animate/index.js'
                        dest: '<%= buildDir %>/scripts/angular-animate.min.js'
                    }
                    {
                        src:'app/bower_components/angular-cookies/index.js'
                        dest: '<%= buildDir %>/scripts/angular-cookies.min.js'
                    }
                    {
                        src:'app/bower_components/angular-resource/index.js'
                        dest: '<%= buildDir %>/scripts/angular-resource.min.js'
                    }
                ]
            angularMap:
                files: [
                    {
                        src:'app/bower_components/angular-animate-map/index.map'
                        dest: '<%= buildDir %>/scripts/angular-animate.min.js.map'
                    }
                    {
                        src:'app/bower_components/angular-cookies-map/index.map'
                        dest: '<%= buildDir %>/scripts/angular-cookies.min.js.map'
                    }
                    {
                        src:'app/bower_components/angular-map/index.map'
                        dest: '<%= buildDir %>/scripts/angular.min.js.map'
                    }
                    {
                        src:'app/bower_components/angular-resource-map/index.map'
                        dest: '<%= buildDir %>/scripts/angular-resource.min.js.map'
                    }
                    {
                        src:'app/bower_components/angular-route-map/index.map'
                        dest: '<%= buildDir %>/scripts/angular-route.min.js.map'
                    }
                ]

        recess:
            build:
                options:
                    compile: true
                    compress: true
                src: [ '<%= app.styles %>' ],
                dest: '<%= buildDir %>/styles/<%= pkg.name %>.css',

        coffee:
            options:
                sourceMap: true
            build:
                src: '<%= app.scripts %>'
                dest: '<%= buildDir %>/scripts/<%= pkg.name %>.js'

        concat:
            angular:
                src: '<%= vendor.angular %>'
                dest: '<%= buildDir %>/scripts/angular.js'

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
        'clean:build'
        'recess'
        'coffee'
        'html2js'
        'ngmin'
        # 'concat'
        'uglify'
        'copy'
    ]
