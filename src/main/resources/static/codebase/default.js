$.ajaxSetup({
	beforeSend: function(xhr, settings) {
		xhr.setRequestHeader('AJAX', true);
	},
	error : function(xhr){
		console.log(xhr);
	}
});