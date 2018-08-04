// JQUERY
$(function() {
	/*
    */
	var images = ['https://image.ibb.co/mhyZxJ/1.jpg', 'https://image.ibb.co/ducird/2.jpg', 'https://image.ibb.co/n04Drd/3.jpg', 'https://image.ibb.co/kiQ8Py/4.jpg', 'https://image.ibb.co/g8SzWd/5.jpg', 'https://image.ibb.co/jZcBcJ/6.jpg', 'https://image.ibb.co/dNnzWd/7.jpg', 'https://image.ibb.co/cGCoPy/8.jpg' ];

   $('#container').append('<style>#container, .acceptContainer:before, #logoContainer:before {background: url(' + images[Math.floor(Math.random() * images.length)] + ') center fixed }');
	
	
	
	
	setTimeout(function() {
		$('.logoContainer').transition({scale: 1}, 700, 'ease');
		setTimeout(function() {
			$('.logoContainer .logo').addClass('loadIn');
			setTimeout(function() {
				$('.logoContainer .text').addClass('loadIn');
				setTimeout(function() {
					$('.acceptContainer').transition({height: '600.5px'});
					setTimeout(function() {
						$('.acceptContainer').addClass('loadIn');
						setTimeout(function() {
							$('.formDiv, form h1').addClass('loadIn');
						}, 400)
					}, 400)
				}, 250)
			}, 250)
		}, 500)
	}, 10)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
});