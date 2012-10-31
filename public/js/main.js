var viewSwitch = function(){
    $('#home-search').click(function(){
	$('#home').fadeOut('fast', function(){
	    $('#search-list').fadeIn('fast');
	});
    });

    $('#result-search').click(function(){
	$('#search-list').fadeOut('fast', function(){
	    $('#home').fadeIn('fast');
	});
    });
}

var uploadModal = function(){
    $('#up-switch').click(function(){
	modalOpen = $('.up-cont').hasClass('open');
	if ( modalOpen == true ) {	    
	    $('#up-modal').fadeOut('fast', function(){
		$('#overlay').hide(function(){
		    $('.up-cont').removeClass('open');
		    $('#up-modal').hide();
		});							
	    });
	}
        else {
	    $('#overlay').show(function(){
		$('#up-modal').fadeIn('fast', function(){
		    $('.up-cont').addClass('open');
		});		
	    });
	}
    });
    $('#overlay').click(function(){
	$('#up-modal').fadeOut('fast', function(){
	    $('#overlay').fadeOut('slow', function(){
		$('.up-cont').removeClass('open');
	    });				
	});
    });
}

//viewSwitch();
uploadModal();
