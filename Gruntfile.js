'use strict';

module.exports = function (grunt) {
    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

    // Automatically load required grunt tasks
    require('jit-grunt')(grunt,{
        lockfile: 'grunt-lock'
    });

    // Configurable paths
    var config = {
        resources_dir: 'Resources/',
        public_dir: 'Resources/public/'
    };

    // Define the configuration for all the tasks
    grunt.initConfig({
        // Project settings
        config: config,

        //Prevent multiple grunt instances
        lockfile: {
            grunt: {
                path: 'grunt.lock'
            }
        },

        // Watches files for changes and runs tasks based on the changed files
        watch: {
            gruntfile: {
                files: ['Gruntfile.js'],
                 options: {
                     reload: true
                 }
            },
            sass: {
                files: ['<%= config.resources_dir %>/sass/{,*/}*.{scss,sass}'],
                tasks: ['sass', 'postcss']
            }
        },

        // Compiles Sass to CSS and generates necessary files if requested
        sass: {
            options: {
                sourceMap: true,
                sourceMapEmbed: false,
                sourceMapContents: true,
                includePaths: ['.']
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= config.resources_dir %>/sass',
                    src: ['*.{scss,sass}'],
                    dest: '.tmp/css',
                    ext: '.css'
                }]
            }
        },

        postcss: {
            options: {
                map: true,
                processors: [
                    // Add vendor prefixed styles
                    require('autoprefixer')({
                        browsers: ['> 1%', 'last 2 versions', 'Firefox ESR', 'Opera 12.1']
                    })
                ]
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '.tmp/css/',
                    src: '{,*/}*.css',
                    dest: '<%= config.public_dir %>/css'
                }]
            }
        },
    });

    grunt.registerTask('serve', 'start the server and preview your app', function () {
        grunt.task.run([
            'lockfile',
            'sass:dist',
            'postcss',
            'watch'
        ]);
    });

    grunt.registerTask('default', [
        'serve'
    ]);
};
