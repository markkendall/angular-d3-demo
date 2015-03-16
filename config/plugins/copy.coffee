module.exports = (lineman) ->
  config:
    copy:
      dist:
        files: [
          {
            expand: true
            cwd: 'vendor/static'
            src: '**'
            dest: 'dist'
          }
          {
            expand: true
            cwd: 'app/static'
            src: '**'
            dest: 'dist'
          }
          {
            src: 'generated/index.html'
            dest: 'dist/index.html'
          }
        ]
