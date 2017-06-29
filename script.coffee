jQuery ->
	$('#scoreboard').on 'change', '.score-player', ->
		playerNumber = this.name.slice -1

		score = 0
		for round in [1..9]
			roundName = 'score' + round + '-player' + playerNumber

			scoreRound = Number $('input[name="' + roundName + '"]').val()
			scoreRound = 0 if isNaN scoreRound

			score += scoreRound

		$('#total-player' + playerNumber).text(score);

	$('#add-player').click ->
		roundNumber = 1
		playersNumber = []
		
		$('#scoreboard thead .name-player').each ->
			playersNumber.push Number $(this).parent().attr('class').slice -1

		playersNumber.sort
		console.log playersNumber

		`assigningNewPlayerNumber: //` # CoffeeScript does not support labels for loop so this is pure js
		for j in [1..8]
			if j not in playersNumber
				newPlayerNumber = j
				`break assigningNewPlayerNumber`

		
		if newPlayerNumber < 9
			$('#scoreboard thead tr').append('<th class="player' + newPlayerNumber + '"><input size="6" type="text" name="name-player' + newPlayerNumber + '" class="name-player" value="Player ' + newPlayerNumber + '" placeholder="Player ' + newPlayerNumber + '\'s name" /><button type="button" class="btn btn-danger delete-player">❌</button></th>')

			$('#scoreboard tfoot tr').append('<td id="total-player'+ newPlayerNumber + '" class="player' + newPlayerNumber + '">0</td>')

			$('#scoreboard tbody tr').each ->
				$(this).append('<td class="player' + newPlayerNumber + '"><input type="number" name="score' + roundNumber + '-player' + newPlayerNumber + '"  class="score-player"  min="0" max="42"/></td>')
				roundNumber++
		else
			console.log "Maximum number of players reached."
	
	$('#scoreboard').on 'click', '.delete-player', ->
		parentClass = $(this).parent().attr('class')
		playerNumber = parentClass.slice -1, parentClass.length
		
		playerNumberClass = ".player" + playerNumber
		$(playerNumberClass).remove()