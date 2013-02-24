class WhacAMu

  constructor: () ->
    @score = 0
    @scorePanel = $("#score")
    @field = $("section.holes")
    @createHoles()
    @createHammer()
    @bindControls()
    @startGame()
    @val = 0

  bindControls: () ->
    self = @
    $("#startGame").click () -> self.startGame()
    $("#pauseGame").click () -> self.pauseGame()
    $("#reset").click () -> self.reset()

  changeButtonState: ( btn ) ->
    $(".btn").removeClass("disabled")
    $( btn ).addClass("disabled")

  startGame: ( ) ->
    self = @
    @gameStarted = true
    @muuuu()
    @randomMu = setInterval () ->
      self.muuuu( {noTrigger: true} )
    , 5000
    @changeButtonState( "#startGame" )

  createHoles: () ->
    i = 0
    while i < 16
      i++
      @field.append("<div class=\"hole\"></div>")

  getRandom: ( last_muuu ) ->
    val = _.random(0, $(".hole").length - 1 )
    while val == last_muuu
      val = _.random(0, $(".hole").length - 1 )
    val

  muuuu: ( options ) ->
    self = @
    if @gameStarted
      @val = @getRandom( @val )
      mu = $(".hole").eq(self.val).addClass("out")
      @bindWhack( mu, options )

  createHammer: () ->
    self = @
    $(window).bind "mousemove", ( e ) ->
      inField = e.pageY > self.field.position().top && e.pageX > self.field.position().left && e.pageY < (self.field.position().top + self.field.height()) &&  e.pageX < (self.field.position().left + self.field.width())
      if inField
        $("#hammer").css( "top": e.pageY, "left": e.pageX )

    $(window).bind "click", ( e ) ->
      inField = e.pageY > self.field.position().top && e.pageX > self.field.position().left && e.pageY < (self.field.position().top + self.field.height()) &&  e.pageX < (self.field.position().left + self.field.width())
      if inField
        $("#hammer").addClass("smash")
        setTimeout () ->
          $("#hammer").removeClass("smash")
        , 200

  bindWhack: ( mu, options ) ->
    self = @
    options = $.extend {}, options
    newtime = setTimeout () ->
      self.updateScore(-10) if mu.is(".out")
      mu.removeClass("out").unbind "click"
      self.muuuu() unless options.noTrigger
    , 2000
    
    mu.bind "click", () ->
      mu.removeClass("out").unbind "click"
      self.muuuu() unless options.noTrigger
      self.updateScore(+10)
      clearTimeout newtime
  
  updateScore: ( score ) ->
    @score = @score + score
    @scorePanel.html( @score )

  pauseGame: ( ) ->
    self = @
    $(".hole").removeClass("out")
    clearInterval( self.randomMu )
    @gameStarted = false
    @changeButtonState( "#pauseGame" )

  reset: ( ) ->
    @updateScore( (0 - @score) )
    @pauseGame()
    @changeButtonState( "#reset" )

jQuery -> 
  new WhacAMu