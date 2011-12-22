// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui



$(document).ready(function(){
	//selectCD();
	dragDropCD();
	//openInBox();
	addSongField();
	popover();
});

function dragDropCD(){
			
			// Arrays zum Speichern der CD IDs die per Drag and Drop hinzugefügt wurden
			var $id_arr = new Array();
			var $wanted_cds = new Array();
			$('.sendBtn').hide();
			
			// Bereich die draggable oder droppable seien sollen
			var $gallery = $( "#myCDs" ),
				$trash = $( "#mine" ),
				$gallery2 = $("#userCDs"),
				$trash2 = $("#wanted");

			// Alle CDs des Nutzers und des Tauschpartners sind draggable
			$( "img", $gallery).draggable({
				cancel: "a.ui-icon", // clicking an icon won't initiate dragging
				revert: "invalid", // when not dropped, the item will revert back to its initial position
				containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
				helper: "clone",
				cursor: "move"
			});
			
			$( "img", $gallery2).draggable({
				cancel: "a.ui-icon", // clicking an icon won't initiate dragging
				revert: "invalid", // when not dropped, the item will revert back to its initial position
				containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
				helper: "clone",
				cursor: "move"
			});
			
			$( "img", $trash2).draggable({
				cancel: "a.ui-icon", // clicking an icon won't initiate dragging
				revert: "invalid", // when not dropped, the item will revert back to its initial position
				containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
				helper: "clone",
				cursor: "move"
			});

			$( "img", $trash).draggable({
				cancel: "a.ui-icon", // clicking an icon won't initiate dragging
				revert: "invalid", // when not dropped, the item will revert back to its initial position
				containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
				helper: "clone",
				cursor: "move"
			});

			// let the trash be droppable, accepting the gallery items
			$trash.droppable({
				accept: "#myCDs > img",
				activeClass: "ui-state-highlight",
				drop: function( event, ui ) {
					deleteImage( ui.draggable );
					//alert(ui.draggable.attr('alt'));
					
					// CD IDs in Array speichern
					$id_arr.push(ui.draggable.attr('alt'));
					$('.sendBtn').hide();
					$('.shareBt').show();					
				}
			});
			
			$trash2.droppable({
				accept: "#userCDs > img",
				activeClass: "ui-state-highlight",
				drop: function( event, ui ) {
					deleteImage2( ui.draggable );
					//alert(ui.draggable.attr('alt'));
					
					// CD IDs in Array speichern
					$wanted_cds.push(ui.draggable.attr('alt'));
						$('.sendBtn').hide();
						$('.shareBt').show();
				}
			});

			// let the gallery be droppable as well, accepting items from the trash
			$gallery.droppable({
				accept: "#mine img",
				activeClass: "custom-state-active",
				drop: function( event, ui ) {
					recycleImage( ui.draggable );
					//var index = jQuery.inArray(ui.draggable.attr('alt'), $id_arr);
					//$id_arr.splice(index,1);	
					$id_arr.length = 0;
					$('.sendBtn').hide();
					$('.shareBt').show();
				}
			});
			
			$gallery2.droppable({
				accept: "#wanted img",
				activeClass: "custom-state-active",
				drop: function( event, ui ) {
					recycleImage2( ui.draggable );
					//var index = jQuery.inArray(ui.draggable.attr('alt'), $wanted_cds);
					//$wanted_cds.splice(index,1);
					$wanted_cds.length = 0;
					$('.sendBtn').hide();
					$('.shareBt').show();
				}
			});

			// image deletion function
			var recycle_icon = "<a href='link/to/recycle/script/when/we/have/js/off' title='Recycle this image' class='ui-icon ui-icon-refresh'>Recycle image</a>";
			function deleteImage( $item ) {
				$item.appendTo( $trash );
			/*	$item.fadeOut(function() {
					var $list = $( "ul", $trash ).length ?
						$( "ul", $trash ) :
						$( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $trash );

					$item.find( "a.ui-icon-trash" ).remove();
					$item.append( recycle_icon ).appendTo( $list ).fadeIn(function() {*/
						$item.fadeIn(function() {
						$item
							.animate({ width: "70px" })
							.find( "img" )
								.animate({ height: "70px" });
							//	$id_arr.push($item.attr('alt'));
					//});
				});
			}
			function deleteImage2( $item ) {
				$item.appendTo( $trash2 );
/*				$item.fadeOut(function() {
					var $list = $( "ul", $trash ).length ?
						$( "ul", $trash ) :
						$( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $trash2 );

					$item.find( "a.ui-icon-trash" ).remove();
					$item.append( recycle_icon ).appendTo( $list ).fadeIn(function() {*/
						$item.fadeIn(function() {
						$item
							.animate({ width: "70px" })
							.find( "img" )
								.animate({ height: "70px" });
				//	});
				});
			}

			// image recycle function
			var trash_icon = "<a href='link/to/trash/script/when/we/have/js/off' title='Delete this image' class='ui-icon ui-icon-trash'>Delete image</a>";
			function recycleImage( $item ) {
				$item.fadeOut(function() {
					$item
						.find( "a.ui-icon-refresh" )
							.remove()
						.end()
						.css( "width", "70px")
						.append( trash_icon )
						.find( "img" )
							.css( "height", "70px" )
						.end()
						.appendTo( $gallery )
						.fadeIn();
				});
			}
			
			function recycleImage2( $item ) {
				$item.fadeOut(function() {
					$item
						.find( "a.ui-icon-refresh" )
							.remove()
						.end()
						.css( "width", "70px")
						.append( trash_icon )
						.find( "img" )
							.css( "height", "70px" )
						.end()
						.appendTo( $gallery2 )
						.fadeIn();
				});
			}
			
			/*
			// image preview function, demonstrating the ui.dialog used as a modal window
			function viewLargerImage( $link ) {
				var src = $link.attr( "href" ),
					title = $link.siblings( "img" ).attr( "alt" ),
					$modal = $( "img[src$='" + src + "']" );

				if ( $modal.length ) {
					$modal.dialog( "open" );
				} else {
					var img = $( "<img alt='" + title + "' width='384' height='288' style='display: none; padding: 8px;' />" )
						.attr( "src", src ).appendTo( "body" );
					setTimeout(function() {
						img.dialog({
							title: title,
							width: 400,
							modal: true
						});
					}, 1 );
				}
			}*/

			// resolve the icons behavior with event delegation
			$( "ul.gallery > li" ).click(function( event ) {
				var $item = $( this ),
					$target = $( event.target );

				if ( $target.is( "a.ui-icon-trash" ) ) {
					deleteImage( $item );
				} else if ( $target.is( "a.ui-icon-zoomin" ) ) {
					viewLargerImage( $target );
				} else if ( $target.is( "a.ui-icon-refresh" ) ) {
					recycleImage( $item );
				}

				return false;
			});
			
			// Mit Klick auf Button wird Link zur Action im Controller erstellt
			$('.shareBt').click(function(){
	//			$wanted_cds.push($('#wanted').find('img').attr('alt'));
				
						// CDs im Array speichern
						$('html body').find('#wanted').each(function(index) {
							$wanted_cds.push($(this).find('img').attr('alt'));
						});
						$('html body').find('#mine').each(function(index) {
						     $id_arr.push($(this).find('img').attr('alt'));
						});
						
				var url = "http://localhost:3000/de/transaction/new?"
				var user = $('#user_id').attr('value');
				
				//alert(user);
				var href = $('a').attr('href');
				$('a').attr('href', url + 'user_id=' + user + '&cds_mine=' + $.unique($id_arr) + '&cds_wanted=' + $.unique($wanted_cds));
				
				if ($id_arr.toString() != "" && $wanted_cds.toString() != "" ){
					$(this).hide();
					$('.sendBtn').show();
				} else {
					alert("Es muss mindestens eine CD zum Tausch angeboten werden");
				}
			
			});
			
			$('.modifyBt').click(function(){
			//	$wanted_cds.push($('#wanted').find('img').attr('alt'));
				
				// CDs im Array speichern
				$('html body').find('#wanted').each(function(index) {
					$wanted_cds.push($(this).find('img').attr('alt'));
				});
				$('html body').find('#mine').each(function(index) {
				     $id_arr.push($(this).find('img').attr('alt'));
				});
				
				var url = "http://localhost:3000/de/transaction/modify/"
				var msg = $('#msg_id').attr('value');
				
				var href = $('a').attr('href');
				$('a').attr('href', url + msg + '?cds_mine=' + $.unique($id_arr) + '&cds_wanted=' + $.unique($wanted_cds));

			});	
			
}


/*
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
*/
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

/*
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
}*/

function addSongField(){
	var num = 2;
	$('#btnAdd').click(function(){
		$('<p><input id="song_'+ num +'" ' + 'name="song['+ num + ']"></input><p/>').appendTo('#input1');
		num += 1;
	});
	
/*	$('#btnDel').click(function(){
		('#input1').find('input'+ $num).remove();
	});*/
}

function popover(){
    $('a[rel=popover]')
        .popover({
            placement: 'below',
			delayIn: 2000,
            html: true,
            template: '<div class="arrow"></div><div class="inner"><h3 class="title"></h3><div class="content" style="height:250px"><p></p></div></div>'
        })
        .click(function(e) {
             e.preventDefault()
     })
}

