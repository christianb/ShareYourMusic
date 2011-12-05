// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui.



$(document).ready(function(){
	//selectCD();
	dragDropCD();
	//openInBox();
	addSongField();
});

function selectCD(){
	$( "#selectable" ).selectable();
}

function dragDropCD(){
	var $cds = $("#selectable");
	var $share = $("#shareBox");
	
	// make elements (cds) draggable
	$("li", $cds).draggable({
		revert: "invalid"
	});
	
	// place to drop cds
	$share.droppable({
		accept: "#selectable > li",
		drop: function( event, ui ) {
		//	$( "<li></li>" ).text( ui.draggable.text()).appendTo( this ).append("Remove");
			ui.draggable.fadeOut(1000);
		}
	});
	
	$cds.droppable({
		accept: "#shareBox li",
		drop: function( event, ui ) {
			//removeFromShare( ui.draggable );
			ui.draggable.appendTo("#selectable");
		}
	});
}
/*
function openInBox(){
	$('#opendialog a').each(function() {
			var $dialog = $('<div></div>');
			var $link = $(this).one.('click', function() {
				$dialog
					.load($link.attr('href') + ' #content p')
					.dialog({
						title: $link.attr('title'),
						width: 500,
						height: 300
					});

				$link.click(function() {
					$dialog.dialog('open');
					return false;
				});
				return false;
			});
	});
}
*/

function addSongField(){
	$('#btnAdd').click(function() {
                var num     = $('.clonedInput').length; 
                var newNum  = new Number(num + 1);      
 
                var newElem = $('#input' + num).clone().attr('id', 'input' + newNum);
 
                newElem.children(':first').attr('id', 'name' + newNum).attr('name', 'name' + newNum);
 
                $('#input' + num).after(newElem);
 
                $('#btnDel').attr('disabled','');
			
 			});
               
            $('#btnDel').click(function() {
                var num = $('.clonedInput').length;
                $('#input' + num).remove();
 
                $('#btnAdd').attr('disabled','');
 
                if (num-1 == 1)
                    $('#btnDel').attr('disabled','disabled');
            });
 
            $('#btnDel').attr('disabled','disabled');
}