require ['lib/hash'], (Hash) ->
  'use strict'

  hash = new Hash

  examples = {
    'http://foo.org/index.html#!/index/index.html@1': ['index/index.html', 0, false]
    'localhost://#!presentations/HTML5/05_Formulare.html@37!hidden': ['presentations/HTML5/05_Formulare.html', 36, true]
    'http://www.foo.de/some/dir#!/presentations/Pik6Vorstellung@14': ['presentations/Pik6Vorstellung', 13, false]
    'file:///home/user/moo.html#!Pik6Vorstellung@11!hidden': ['Pik6Vorstellung', 10, true]
  }

  test 'Parse URLs', ->
    for url, expected of examples
      parsed = hash.parse url
      deepEqual parsed, {
        file: expected[0]
        slide: expected[1]
        hidden: expected[2]
      }

  test 'Create hashes', ->
    for url, values of examples
      expectedHash = url.split('#').pop()
      # Ignore slash inconstistencies
      if expectedHash[1] != '/' then expectedHash = '!/' + expectedHash.substr(1)
      builtHash = hash.createHash.apply null, values
      equal builtHash, expectedHash

  test 'Hashchange event', ->
    stop Object.keys(examples).length
    hash.on 'change', (data) ->
      ok 1 # TODO: check for correct values (`data`)
      start()
    for url, expected of examples
      newHash = hash.createHash expected...
      window.location.hash = newHash

  test 'Calculate common path', ->
    a = 'http://localhost/~peter/Pik7/#!/core/welcome.html@0'
    b = 'http://localhost/~peter/Pik7/presentations/Reality/'
    expected = 'http://localhost/~peter/Pik7/'
    equal Hash::commonPath(a, b), expected