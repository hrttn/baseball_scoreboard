jQuery ->
	$('#scoreboard').on 'change', '.score-player', ->
		playerNumber = this.name.slice -1 #We get the player's number through the name of the input

		score = 0
		for round in [1..9]
			roundName = 'score' + round + '-player' + playerNumber

			scoreRound = Number $('input[name="' + roundName + '"]').val()
			scoreRound = 0 if isNaN scoreRound

			score += scoreRound

		$('#total-player' + playerNumber).text(score);


	# Adding a player (and the associated column) up to 8 players
	$('#add-player').click ->
		playersNumber = do getPlayersNumber
		
		`assigningNewPlayerNumber: //` # CoffeeScript does not support labels for loop so this is pure js
		for j in [1..8]
			if j not in playersNumber
				newPlayerNumber = j
				`break assigningNewPlayerNumber`

		numberOfPlayers = do getNumberOfPlayers

		if numberOfPlayers < 8 # We check that we are below the maximum number of players

			$('#scoreboard thead tr').append('<th class="player' + newPlayerNumber + '"><input size="6" type="text" name="name-player' + newPlayerNumber + '" class="name-player" value="Player ' + newPlayerNumber + '" placeholder="Player ' + newPlayerNumber + '\'s name" /><button type="button" class="btn btn-danger delete-player">❌</button></th>')
			$('#scoreboard tfoot tr').append('<td class="total-player" id="total-player'+ newPlayerNumber + '" class="player' + newPlayerNumber + '">0</td>')

			roundNumber = 1
			$('#scoreboard tbody tr').each ->
				$(this).append('<td class="player' + newPlayerNumber + '"><input type="number" name="score' + roundNumber + '-player' + newPlayerNumber + '"  class="score-player"  min="0" max="42"/></td>')
				roundNumber++

			console.log "Player #" + newPlayerNumber + " succesfully created."

			if numberOfPlayers > 2 # We check that we are above the minimum number of players
				$('.delete-player').prop("disabled", false);
			else
				$('.delete-player').prop("disabled", true);
		else
			console.log "Maximum number of players reached."

	
	# Deleting a player (and the associated column)
	$('#scoreboard').on 'click', '.delete-player', ->
		parentClass = $(this).parent().attr('class')
		playerNumber = parentClass.slice -1, parentClass.length
		
		playerNumberClass = ".player" + playerNumber
		$(playerNumberClass).remove()

		numberOfPlayers = do getNumberOfPlayers

		if numberOfPlayers > 3 # We check that we are above the minimum number of players
				$('.delete-player').prop("disabled", false);
			else
				$('.delete-player').prop("disabled", true);

	$('#new-game').click ->
		$('.score-player').val('')
		$('.total-player').text('0')

	getNumberOfPlayers = ->
		playersNumber = do getPlayersNumber		
		playersNumber.length


	getPlayersNumber = ->
		playersNumber = []
		$('#scoreboard thead .name-player').each ->
			playersNumber.push Number $(this).parent().attr('class').slice -1
		
		playersNumber.sort()