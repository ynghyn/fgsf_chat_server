jQuery(document).ready(function($) {
	var lastMessageId = 0;
	var $userId = $("#user_id");
	var $nameChange = $('#name_change');
	var username = $nameChange.text();
	var $dropdownUsers = $('#dropdown_users');
	var imgGreenDotHTML = $('#imgGreenDot').html();
	
	$("#name_change").click(function(e) {
		e.preventDefault();
		toggleName();
	});
	
	$('#name_change').keydown(function(e) {
    // trap the Return key being pressed
    if (e.keyCode === 13) {
			toggleName();
      // prevent the default behaviour of return key pressed
      return false;
    }
  });

	// Update use's name if name change has been made
	function toggleName() {
		var isEditable = $nameChange.is('.editable');
		$nameChange.prop('contenteditable', !isEditable).toggleClass('editable');
		if (isEditable && username != $nameChange.text()) {
			var data = {
				user_id: $userId.val(),
				name: $nameChange.text()
			};
			$.ajax({
			  url: "chat/update_name",
			  type: "PUT",
			  data: data,
				success: function(data) {
					lastMessageId = 0;
					refreshView(true);
			  }
			});
			username = $nameChange.text();
		}
	}

	// Post message if user presses Return key from textbox
	$("#message").keypress(function(e) {
    if(e.which == 13) {
    	postMessage();
    }
	});

	$("#post").click(function() {
		postMessage();
	});

	// Posts message to server
	function postMessage() {
		if ($("#message").val() != "") {
			var data = {
				user_id: $("#user_id").val(),
				chatroom_id: $("#chatroom_id").val(),
				message: $("#message").val()
			};
			$.post( "chat/create_message", data, function(data) {
				refreshView(true);
			});
			// clear message
			$("#message").val('');
		}
	}

	// Refreshes message box if newer messsage has been found
	function refreshView(bypass) {
		var data = {
			chatroom_id: $("#chatroom_id").val(),
			message_id: lastMessageId,
			user_id: $userId.val(),
			bypass: bypass
		}
		$.get("chat/get_messages", data, function(data) {
			if (data.lastMessageId > lastMessageId || !!bypass) {
				var msgHtml = "";
				$.each(data.messages, function(index, message) {
					var color = message.color ? message.color : "#000000";
					msgHtml += "<div style=\"color:" + color + "\">";
					msgHtml += "[" + message.time + "] ";
					msgHtml += message.username + ": ";
					msgHtml += message.message + "</div>";
				});
				$("#message_box").html(msgHtml);
				$("#message_box").scrollTop($("#message_box")[0].scrollHeight);
				lastMessageId = data.lastMessageId;
			}

			var userHtml = ""
			$.each(data.activeUsers, function(index, name) {
				userHtml += "<li>" + imgGreenDotHTML + name + "</li>"
			});
			$dropdownUsers.children().remove()
			$dropdownUsers.append(userHtml);
		});
	}

	$(document).ready(function() {
		// Grab initial messages and 3 second interval AJAX calls
		refreshView(true);
		setInterval(refreshView, 3000, false);
		
		// Initialize hex color and color picker
		$('#colorpicker').val($('#color').val());
		$('#colorpicker').minicolors();

		// Update user's color choice on color change
		$('#colorpicker').change(function() {
			var data = {
				user_id: $userId.val(),
				color: $('#colorpicker').val()
			};
			$.ajax({
			  url: "chat/update_color",
			  type: "PUT",
			  data: data,
				success: function(data) {
					lastMessageId = 0;
					refreshView(true);
			  }
			});
		});
	});
});
