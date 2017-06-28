jQuery ->
	$('.score-player').change ->
		playerNumber = this.name.slice -1

		score = 0
		for round in [1..9]
			roundName = 'score' + round + '-player' + playerNumber

			scoreRound = Number $("input[name='" + roundName + "']").val()
			scoreRound = 0 if isNaN scoreRound

			score += scoreRound

		$('#total-player' + playerNumber).text(score);
