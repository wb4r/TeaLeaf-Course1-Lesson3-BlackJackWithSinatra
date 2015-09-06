$(document).ready(function() {

	$('#hitform button').click(function() {
		$.ajax({
			type: 'POST',
			url: '/game'

		}).done(function(msg) {
			$('#game').replaceWith(msg);
		});
		return false;
	});

});