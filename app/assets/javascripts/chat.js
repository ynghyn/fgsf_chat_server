jQuery(document).ready(function($) {
	var lastMsgId = 0; // not used at the moment

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
		  var msgHtml = data.messages.join("<br>");
			$("#message_box").html(msgHtml);
			$("#message_box").scrollTop($("#message_box")[0].scrollHeight);
		});
		console.log("Refreshed");
	}

	$(document).ready(function() {
		refreshView();
		setInterval(refreshView, 3000);
	});
});
