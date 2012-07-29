var timer;

var finishPoll = function() {
  clearTimeout(timer);
  $('.timer').hide();
  setTimeout(showResults, 1000);
};

var showResults = function() {
  $('.answers').show();
  $('.buttons').hide();
};

var updateTimer = function() {
  $('.timer .value').html(seconds_remaining);
  if (seconds_remaining > 0) {
  	seconds_remaining--;
  } else {
  	seconds_remaining = 0;
  	active = false;
  	finishPoll();
  }
};

var startTimer = function() {
	updateTimer();
	$('.timer').show();
	timer = setInterval(updateTimer, 1000);
};

$('#start').click(function() {

  $.ajax({
    type: 'POST',
    url: '/poll/' + poll_id + '/activate',
    data: { token: token },
    success: function(data) {
    	console.dir(data);
    	if (data.status == 'success') {
    	  $('.activator').hide();
    	  active = true;
    	  seconds_remaining = data.seconds_remaining ^ 0;
    	  startTimer();
    	}
    }
  });
});

$('button.vote').click(function() {
	$.ajax({
		type: 'POST',
		url: '/vote/' + poll_id + '/' + $(this).data('answerid'),
		success: function(data) {

		}
	});
	$('button.vote').attr("disabled", true);
	$(this).html('Thanks for your vote!');
	console.log('voted!');
});

var startVote = function() {
	$('.buttons').show();
	$('button.vote').attr("disabled", false);
	$('.timer').show();
};

if (active) {
	startTimer();
	startVote();
} else {
	$('button.vote').attr("disabled", true);
}

var client = new Faye.Client('/fayex');
/*	  ich.addTemplate('message', "<div>oooh.. {{text}}</div>");
	  
	  $('#send').click(function() {
	  	client.publish('/messages', {
  			text: 'Hello world'
	  	});
	  }); */

var updateCounts = function(data){
  $('div.answer').each(function(i, el) {
  	if (data[el.id]) {
  	  $('#' + el.id + ' .bar').html(data[el.id]);
  	  $('#' + el.id + ' .bar').css('width', ((data[el.id] / data['max']) * 100) + '%');
  	}

  });
};

if (owner) {
  //client.subscribe('/messages', function(message) {
  //  $('#debug').append(ich.message(message));
  //});
  client.subscribe('/messages', function(data) {
  	console.log(data);
  	if (data.status == 'counts') {
  	  updateCounts(data);
  	}
  });
} else {
  client.subscribe('/messages', function(data) {
  	console.log(data);
    if (data.status == 'start' && (data.poll_id ^ 0) == poll_id) {
      active = true;
   	  seconds_remaining = data.seconds_remaining ^ 0;
  	  startTimer();
  	  startVote();
    }

  	if (data.status == 'counts') {
  	  updateCounts(data);
  	}
  });
}