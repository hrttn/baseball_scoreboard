jQuery ->

	do toggleButtons
	do highlightBestScore

	# Changing the score
	$('#scoreboard').on 'change', '.score-player', ->
		playerNumber = this.name.slice -1 #We get the player's number through the name of the input

		score = 0
		for round in [1..9]
			roundName = 'score' + round + '-player' + playerNumber

			scoreRound = Number $('input[name="' + roundName + '"]').val()
			scoreRound = 0 if isNaN scoreRound

			score += scoreRound

		$('#total-player' + playerNumber).text(score)
		do highlightBestScore



	# Adding a player (and the associated column) up to 8 players
	$('#add-player').click ->
		playersNumber = do getPlayersNumber
		
		for j in [1..8]
			if j not in playersNumber
				newPlayerNumber = j
				break

		numberOfPlayers = do getNumberOfPlayers

		if numberOfPlayers < 8 # We check that we are below the maximum number of players

			$('#scoreboard thead tr').append('<th class="player' + newPlayerNumber + '"><input size="6" type="text" name="name-player' + newPlayerNumber + '" class="name-player" value="Player ' + newPlayerNumber + '" placeholder="Player ' + newPlayerNumber + '\'s name" /><button type="button" class="btn btn-danger delete-player">❌</button></th>')
			$('#scoreboard tfoot tr').append('<td class="total-player player' + newPlayerNumber + '" id="total-player'+ newPlayerNumber + '">0</td>')

			roundNumber = 1
			$('#scoreboard tbody tr').each ->
				$(this).append('<td class="player' + newPlayerNumber + '"><input type="number" name="score' + roundNumber + '-player' + newPlayerNumber + '"  class="score-player"  min="0" max="42"/></td>')
				roundNumber++

			console.log "Player #" + newPlayerNumber + " succesfully created."

			do toggleButtons
			do highlightBestScore
		else
			console.log "Maximum number of players reached."

		

	
	# Deleting a player (and the associated column)
	$('#scoreboard').on 'click', '.delete-player', ->
		parentClass = $(this).parent().attr('class')
		playerNumber = parentClass.slice -1, parentClass.length # We get the player's number from its parent's class 
		
		playerNumberClass = ".player" + playerNumber
		$(playerNumberClass).remove()

		console.log "Player #" + playerNumber + " succesfully deleted."
		do toggleButtons
		do highlightBestScore		

	$('#new-game').click ->
		$('.score-player').val('')
		$('.total-player').text('0')
		do highlightBestScore

getTotals = ->
	playersTotal = {}
	$('#scoreboard tfoot .total-player').each ->
		playersTotal[$(this).attr('id')] = Number $(this).text()

	console.log playersTotal
	playersTotal

getBestPlayers =->
	totals = do getTotals
	bestPlayers = []

	min = 378 # Highest score in the game

	for player, total of totals
		if total <= min			
			
			if total == min 
				bestPlayers.push player
			else
				bestPlayers = [player]
			min = total
	
	bestPlayers

highlightBestScore = ->
	bestPlayers = do getBestPlayers

	console.log bestPlayers
	for i in getPlayersNumber()
		totalCell = $('#total-player' + i)
		
		if((totalCell.hasClass('bg-success text-white font-weight-bold')) && (totalCell.attr('id') not in bestPlayers))
			totalCell.removeClass('bg-success text-white font-weight-bold')
		else if ((!totalCell.hasClass('bg-success text-white font-weight-bold')) && (totalCell.attr('id') in bestPlayers))
			totalCell.addClass('bg-success text-white font-weight-bold')

getNumberOfPlayers = ->
	playersNumber = do getPlayersNumber		
	playersNumber.length


getPlayersNumber = ->
	playersNumber = []
	$('#scoreboard thead .name-player').each ->
		playersNumber.push Number $(this).parent().attr('class').slice -1
	
	playersNumber.sort()

toggleButtons = ->
	numberOfPlayers = do getNumberOfPlayers
	
	if numberOfPlayers > 3 # We check that we are above the minimum number of players
		$('.delete-player').prop "disabled", false
				
		if numberOfPlayers > 7
			$('#add-player').prop "disabled", true
		else
			$('#add-player').prop "disabled", false
	else
		$('.delete-player').prop "disabled", true;