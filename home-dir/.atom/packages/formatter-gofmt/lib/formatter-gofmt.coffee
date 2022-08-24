{CompositeDisposable} = require 'atom'

module.exports = FormatterGofmt =
  activate: (state) ->
    return

  config:
    a:
      title: 'Path to the exectuable'
      type: 'object'
      properties:
        executablePath:
          title: 'Full path of exectuable'
          type: 'string'
          default: 'gofmt'
    go:
      title: 'Golang'
      type: 'object'
      description: 'All parameters for Golang.'
      properties:
        enable:
          title: 'Enable formatter for Golang'
          type: 'boolean'
          default: true
          description: 'Need restart Atom.'
        arguments:
          title: 'Arguments passed to the formatter Golang'
          type: 'array'
          default: []
          description: 'Example : `-s, -r, "(a) -> a"`.'

  provideFormatter: ->
    {
      selector: '.source.go'
      getNewText: (text) ->
        child_process = require 'child_process'
        return new Promise (resolve, reject) ->
          command = atom.config.get 'formatter-gofmt.a.executablePath'
          args = atom.config.get 'formatter-gofmt.go.arguments'
          toReturn = []
          toReturnErr = []
          process = child_process.spawn(command, args, {})
          process.stderr.on 'data', (data) -> toReturnErr.push data
          process.stdout.on 'data', (data) -> toReturn.push data
          process.stdin.write text
          process.stdin.end()
          process.on 'close', ->
            if toReturn.length isnt 0
              resolve(toReturn.join('\n'))
            else
              atom.notifications.addError('formatter-gofmt : error', {dismissable: true, detail: toReturnErr.join('\n')});
    } if atom.config.get 'formatter-gofmt.go.enable'
