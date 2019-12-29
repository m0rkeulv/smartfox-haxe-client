package com.smartfoxserver.v2.requests;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.requests.GenericMessageRequest;
import com.smartfoxserver.v2.requests.MessageRecipientMode;
import com.smartfoxserver.v2.requests.GenericMessageRequest.*;
import openfl.errors.ArgumentError;
/**
 * Sends an administrator message to a specific user or a group of users.
 * 
 *<p>The current user must have administration privileges to be able to send the message(see the<em>User.privilegeId</em>property).</p>
 * 
 *<p>The<em>recipientMode</em>parameter in the class constructor is used to determine the message recipients:a single user or all the
 * users in a Room, a Group or the entire Zone. Upon message delivery, the clients of the recipient users dispatch the<em>adminMessage</em>event.</p>
 * 
 * @example	The following example sends an administration message to all the users in the Zone;it also shows how to handle the related event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSEvent.ADMIN_MESSAGE, onAdminMessage);
 * 	
 * 	// Set the message recipients:all users in the Zone
 * 	var recipMode:MessageRecipientMode=new MessageRecipientMode(MessageRecipientMode.TO_ZONE, null);
 * 	
 * 	// Send the administrator message
 * 	sfs.send(new AdminMessageRequest("Hello to everybody from the Administrator!", recipMode));
 * }
 * 
 * private function onAdminMessage(evt:SFSEvent):Void
 * {
 * 	trace("The administrator sent the following message:" + evt.params.message);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:adminMessage adminMessage event
 * @see		com.smartfoxserver.v2.entities.User#privilegeId User.privilegeId
 * @see		ModeratorMessageRequest
 */
class AdminMessageRequest extends GenericMessageRequest {

	/** @exclude */
	private var _recipient:Any;

	
	/**
	 * Creates a new<em>AdminMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	message			The message of the administrator to be sent to the target user/s defined by the<em>recipientMode</em>parameter.
	 * @param	recipientMode	An instance of<em>MessageRecipientMode</em>containing the target to which the message should be delivered.
	 * @param	params			An instance of<em>SFSObject</em>containing custom parameters to be sent to the recipient user/s.
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(message:String, recipientMode:MessageRecipientMode, params:ISFSObject = null) {
		if (recipientMode == null)
			throw new ArgumentError("RecipientMode cannot be null!");

		_type = GenericMessageType.ADMING_MSG;
		_message = message;
		_params = params;
		_recipient = recipientMode.target;
		_sendMode = recipientMode.mode;
	}

	override public function validate(sfs:SmartFox):Void {
		var errors:Array<String> = [];

		if (_message == null || _message.length == 0)
			errors.push("Administrator message is empty!");

		switch(_sendMode)
		{
			case MessageRecipientMode.TO_USER:
				if (!(Std.is(_recipient, User)))
					errors.push("TO_USER expects a User object as recipient");

			case MessageRecipientMode.TO_ROOM:
				if (!(Std.is(_recipient, Room)))
					errors.push("TO_ROOM expects a Room object as recipient");

			case MessageRecipientMode.TO_GROUP:
				if (!(Std.is(_recipient, String)))
					errors.push("TO_GROUP expects a String object(the groupId)as recipient");
		}
		if (errors.length > 0)
			throw new SFSValidationError("Request error - ", errors);
	}

	override public function execute(sfs:SmartFox):Void {
		_sfso.putByte(KEY_MESSAGE_TYPE, _type);
		_sfso.putUtfString(KEY_MESSAGE, _message);

		if (_params != null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);

		_sfso.putInt(KEY_RECIPIENT_MODE, _sendMode);

		switch(_sendMode)
		{
			// Put the User.id as Int
			case MessageRecipientMode.TO_USER:
				_sfso.putInt(KEY_RECIPIENT, _recipient.id);

			// Put the Room.id as Int
			case MessageRecipientMode.TO_ROOM:
				_sfso.putInt(KEY_RECIPIENT, _recipient.id);

			// Put the Room Group as String
			case MessageRecipientMode.TO_GROUP:
				_sfso.putUtfString(KEY_RECIPIENT, _recipient);

			// the TO_ZONE case does not need to pass any other params
		}
	}


}
