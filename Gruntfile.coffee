'use strict'

module.exports = (grunt) ->
    require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

    appConfig =
        static: '../portfolio-app/static'

    grunt.initConfig
        app: appConfig
        coffee:
            app:
                expand: true
                cwd: 'src/scripts/'
                src: '{,*/}*.coffee'
                dest: '<%= app.static %>/scripts'
                ext: '.js'
            beforeconcat:
                expand: true
                cwd: 'src/scripts/'
                src: '{,*/}*.coffee'
                dest: '.tmp/scripts'
                ext: '.js'
        jshint:
            options:
                jshintrc: '.jshintrc'
            beforeconcat: ['.tmp/scripts/**/*.js']
            afterconcat: ['']
        less:
            app:
                options:
                    paths: 'src/styles/'
                files:
                    '<%= app.static %>/styles/main.css': 'src/styles/main.less'

        clean:
            tmp: ['.tmp']
            tmpscripts: ['.tmp/scripts']
            tmpstyles: ['.tmp/styles']

        copy:
            thirdparty:
                files: [
                    expand: true
                    cwd: 'src/'
                    src: ['components/**', 'vendor/**', 'favicon.ico']
                    dest: '<%= app.static %>'
                ]

        deploy:
            dev:
                tasks: [
                    'clean:tmp'
                    'coffee:beforeconcat'
                    'jshint:beforeconcat'
                    'coffee:app'
                    'less:app'
                    'copy'
                ]

    grunt.registerTask 'checkcoffee', [
        'coffee:beforeconcat'
        'jshint:beforeconcat'
    ]

    grunt.registerMultiTask 'deploy', ->
        grunt.task.run @data.tasks

# vim: set sts=4 sw=4 ts=4:
