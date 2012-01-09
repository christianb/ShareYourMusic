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
	//addSongField();
	popover();
	//remove_fields();
	//add_fields();
	autoCompleteSearch();
	$.ajaxSetup({
	        beforeSend: function (xhr) {
	                xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
	        }
	    });
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
					$('.modifyBt').show();					
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
						$('.modifyBt').show();
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
					$('.modifyBt').show();
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
					$('.modifyBt').show();

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

				//var host = window.location.host;		
				var url = "/de/transaction/new?";
				var user = $('#user_id').attr('value');
				
				//alert(user);
				var href = $('a').attr('href');
				$('.actions a').attr('href', (url + 'user_id=' + user + '&cds_mine=' + $.unique($id_arr) + '&cds_wanted=' + $.unique($wanted_cds)));
				
				$('#cds_mine').attr('value', $.unique($id_arr));
				$('#cds_wanted').attr('value', $.unique($wanted_cds));
				
				var pattern = /[0-9]/g;

				var id_arr_match = $id_arr.toString().match(pattern);
				var wanted_cds_match = $wanted_cds.toString().match(pattern);
				
				if (id_arr_match != null && wanted_cds_match != null ){
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
				
				var url = "/de/transaction/modify/"
				var msg = $('#msg_id').attr('value');
				
				var href = $('a').attr('href');
				$('.actions a').attr('href', url + msg + '?cds_mine=' + $.unique($id_arr) + '&cds_wanted=' + $.unique($wanted_cds));

				$('#cds_mine').attr('value', $.unique($id_arr));
				$('#cds_wanted').attr('value', $.unique($wanted_cds));
				
				var pattern = /[0-9]/g;

				var id_arr_match = $id_arr.toString().match(pattern);
				var wanted_cds_match = $wanted_cds.toString().match(pattern);
				
				
				if (id_arr_match != null && wanted_cds_match != null ){
					$(this).hide();
					$('.sendBtn').show();
				} else {
					alert("Es muss mindestens eine CD zum Tausch angeboten werden");
				}
			});	
			
}

function popover(){
    $('a[rel=popover], img[rel=popover]')
        .popover({
            placement: 'below',
			content:"id",
			delayIn: 1000,
            html: true,
            template: '<div class="arrow"></div><div class="inner"><h3 class="title"></h3><div class="content" style="min-height:150px"><p></p></div></div>'
        })
}

function remove_fields(link){
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
  	var regexp = new RegExp("new_" + association, "g");
	$(link).parent().before(content.replace(regexp, new_id));
}

function autoCompleteSearch(){
	$("#querry").autocomplete({ 
	    //source: ['hi', 'bye', 'foo', 'bar'],
		source: '/autoCompl',
	    minLength: 2
	}).on("focus", function () {
	    $(this).autocomplete("search", '');
	});
}

function mbrainz(){
	var artist = $('#compact_disk_artist').val();
	var title = $('#compact_disk_title').val();
	var url = '/compact_disk/mbrainz?artist=' + artist + '&title=' + title;
	var cover_url = $('#compact_disk_photo_url').val();
	var year = $('#compact_disk_year').val();
	
	if (artist != "" && title != ""){
		// Falls bereits Felder vorhanden sind, werden diese entfernt
		$('.mbrainz_fields').find('input').remove();
		$('.mbrainz_fields').find('a').remove();
		$('#compact_disk_songs_attributes_0_title').remove();
		$('.fields').find('.rmSongBt').remove();
	
		$.ajax({
		    type: 'GET',
			dataType: "xml",
	        url: '/compact_disk/mbrainz',
			data: "artist="+artist+"&title="+title,
			success: function(xml){
				$(xml).find('tracks track').each(function(){
					var ran_nr = Math.floor(Math.random()*100);
					var new_id = (new Date().getTime()) * ran_nr;
					var val = $(this).text();
					$('<div class=\"input fields\">\n	<input id=\"compact_disk_songs_attributes_'+ new_id +'_title\" name=\"compact_disk[songs_attributes]['+ new_id +'][title]\" size=\"30\" type=\"text\" value=\"'+ val + '\"/>\n	<input id=\"compact_disk_songs_attributes_'+ new_id +'__destroy\" name=\"compact_disk[songs_attributes]['+ new_id +'][_destroy]\" type=\"hidden\" value=\"false\" /> \n	<a href=\"#\" onclick=\"remove_fields(this); return false;\"><span class=\"label important\"> - <\/span><\/a>\n<\/div>').appendTo('.mbrainz_fields');
		 		});
	
				var cover_url_field =  $('#compact_disk_photo_url');
				if (cover_url.length == 0) {
					cover_url_field.attr('value',$(xml).find('cover-url').text());
				}
			
			
				var year_field =  $('#compact_disk_year');
				if (year.length == 0) {
					year_field.attr('value',$(xml).find('year').text());
				}
			}
		});
	}else{
		alert("Es muss ein Title und ein Artist angegeben werden")
	}
}


