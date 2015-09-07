// THIS ONE GIVES ANSWER AND DISPLAYS THENEW PAGE BUT VERY STRANGELY LIKE REPEATING
// I TESTED $('#game').html(msg); and replaceWith

$(document).ready(function() {

	$('#repbtn').click(function() {
		$.ajax({
			type: 'POST',
			url: '/bet_amount',
			async: true
		}).done(function(msg) {
			$('#game').html(msg);
		});
		  return false;
	});

});


// THIS ONE IS NOT WORKING AT ALL

// $(document).ready(function() {

// 	$('#hitbtn').click(function() {
// 		$.ajax({
// 			type: 'POST',
// 			url: '/ingame'

// 		}).done(function(msg) {
// 			$('#game').html(msg);
// 		});
// 		return false;
// 	});

// });