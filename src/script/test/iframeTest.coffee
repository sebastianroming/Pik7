require ['lib/iframe', 'jquery'], (Iframe) ->
  'use strict'

  frameEl  = $('#Testframe')
  frameWin = frameEl[0].contentWindow

  test 'Init procedure', ->
    frame = new Iframe(frameEl)
    stop()
    frame.on 'load', ->
      equal frame.getNumSlides(), frameWin.$('.pikSlide').length

      test 'Commands', ->
        stop(2)
        frameWin.testPresentation.on 'slide', (num) ->
          equal num, 1337
          start()
        frameWin.testPresentation.on 'hidden', (state) ->
          equal state, false
          start()
        frame.do 'slide', 1337
        frame.do 'hidden', false

      start()


  frameEl.attr 'src', 'iframeTest/iframeTestFrame.html'