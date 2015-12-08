jQuery(document).ready(function($) {
	var lastMessageId = 0;
	var $userId = $("#user_id");
	var $nameChange = $('#name_change');
	
	$("#name_change").click(function(e) {
		e.preventDefault();
		toggleName();
	});
	
	$('#name_change').keydown(function(e) {
    // trap the return key being pressed
    if (e.keyCode === 13) {
			toggleName();
      // prevent the default behaviour of return key pressed
      return false;
    }
  });
	
	function toggleName() {
		var isEditable = $nameChange.is('.editable');
		$nameChange.prop('contenteditable', !isEditable).toggleClass('editable');
		if (isEditable) {
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
					refreshView();
			  }
			});
		}
	}

	$("#message").keypress(function(e) {
    if(e.which == 13) {
    	$("#post").click();
    }
	});
	
	$("#post").click(function() {
		var userId = $("#user_id").val();
		var chatroomId = $("#chatroom_id").val();
		var message = $("#message").val();
		
		var data = {
			user_id: userId,
			chatroom_id: chatroomId,
			message: message
		};

		$.post( "chat/create_message", data, function(data) {});

		// clear message and refresh
		$("#message").val('');
		refreshView();
	});

	function refreshView() {
		var chatroomId = $("#chatroom_id").val();
		var args = "?chatroom_id=" + chatroomId;
		$.get("chat/get_messages" + args, function(data) {
			if (data.lastMessageId > lastMessageId) {
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
		});
	}

	$(document).ready(function() {
		refreshView();
		setInterval(refreshView, 3000);
		$('#colorpicker').val($('#color').val());
		$('#colorpicker').minicolors();

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
					refreshView();
			  }
			});
		});
	});
});
