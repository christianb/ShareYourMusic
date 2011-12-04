// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .


$(document).ready(function(){
	dragDropCD();
	//openInBox();
});

function dragDropCD(){
			
			var $id_arr = new Array();
			
			// there's the gallery and the trash
			var $gallery = $( "#gallery" ),
				$trash = $( "#shareBox" );

			// let the gallery items be draggable
			$( "li", $gallery ).draggable({
				cancel: "a.ui-icon", // clicking an icon won't initiate dragging
				revert: "invalid", // when not dropped, the item will revert back to its initial position
				containment: $( "#demo-frame" ).length ? "#demo-frame" : "document", // stick to demo-frame if present
				helper: "clone",
				cursor: "move"
			});

			// let the trash be droppable, accepting the gallery items
			$trash.droppable({
				accept: "#gallery > li",
				activeClass: "ui-state-highlight",
				drop: function( event, ui ) {
					deleteImage( ui.draggable );
					//alert(ui.draggable.find("img").attr("alt"));
					$id_arr.push(ui.draggable.find("img").attr("alt"));
				}
			});

			// let the gallery be droppable as well, accepting items from the trash
			$gallery.droppable({
				accept: "#shareBox li",
				activeClass: "custom-state-active",
				drop: function( event, ui ) {
					recycleImage( ui.draggable );
				}
			});

			// image deletion function
			var recycle_icon = "<a href='link/to/recycle/script/when/we/have/js/off' title='Recycle this image' class='ui-icon ui-icon-refresh'>Recycle image</a>";
			function deleteImage( $item ) {
				$item.fadeOut(function() {
					var $list = $( "ul", $trash ).length ?
						$( "ul", $trash ) :
						$( "<ul class='gallery ui-helper-reset'/>" ).appendTo( $trash );

					$item.find( "a.ui-icon-trash" ).remove();
					$item.append( recycle_icon ).appendTo( $list ).fadeIn(function() {
						$item
							.animate({ width: "48px" })
							.find( "img" )
								.animate({ height: "36px" });
					});
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
						.css( "width", "130px")
						.append( trash_icon )
						.find( "img" )
							.css( "height", "115px" )
						.end()
						.appendTo( $gallery )
						.fadeIn();
				});
			}

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
			}

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
			
			$('.shareBt').click(function(){
				//$("<h3>Tausche: "+ $id_arr + "</h3>").appendTo($trash);	
				alert($id_arr);
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