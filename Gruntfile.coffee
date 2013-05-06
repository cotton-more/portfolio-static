'use strict'

module.export = (grunt) ->
    require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

    grunt.initConfig
        coffee:
            dist:
                expand: true
                cwd: ''
                src: ''
                dest: ''
                ext: '.js'
        jshint:
            options:
                jshintrc: '.jshintrc'
            all: [
                ''
            ]
        less:
            dist:
                options:
                    paths: ['']
                files:
                    '': ''

    grunt.registerTaks 'default', ['build']

# vim: set sts=4 sw=4 ts=4:
