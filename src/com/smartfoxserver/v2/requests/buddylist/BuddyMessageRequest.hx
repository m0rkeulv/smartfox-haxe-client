package com.smartfoxserver.v2.requests.buddylist;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.data.ISFSObject;


import com.smartfoxserver.v2.requests.GenericMessageRequest;
import com.smartfoxserver.v2.requests.GenericMessageType;
import com.smartfoxserver.v2.requests.GenericMessageRequest.*;

/**
 * Sends a message to a buddy in the current user's buddies list.
 * 
 *<p>Messages sent to buddies using the<em>BuddyMessageRequest</em>request are similar to the standard private messages(see the<em>PrivateMessageRequest</em>request)
 * but are specifically designed for the Buddy List system:they don't require any Room parameter, nor they require that users joined a Room.
 * Additionally, buddy messages are subject to specific validation, such as making sure that the recipient is in the sender's buddies list and the sender is not blocked by the recipient.</p>
 * 
 *<p>If the operation is successful, a<em>buddyMessage</em>event is dispatched in both the sender and recipient clients.</p>
 * 
 *<p><b>NOTE</b>:this request can be sent if the Buddy List system was previously initialized only(see the<em>InitBuddyListRequest</em>request description).</p>
 * 
 * @example	The following example sends a message to a buddy and handles the related event:
 *<listing version="3.0">
 * 
 * private function someMethod():Void
 * {
 * 	sfs.addEventListener(SFSBuddyEvent.BUDDY_MESSAGE, onBuddyMessage);
 * 	
 * 	// Get the recipient of the message, in this case my buddy Jack
 * 	var buddy:Buddy=sfs.buddyManager.getBuddyByName("Jack");
 * 	
 * 	// Send a message to Jack
 * 	sfs.send(new BuddyMessageRequest("Hello Jack!", buddy));
 * }
 * 
 * private function onBuddyMessage(evt:SFSBuddyEvent):Void
 * {
 * 	// As messages are forwarded to the sender too,
 * 	// I have to check if I am the sender
 * 	
 * 	var isItMe:Bool=evt.params.isItMe;
 * 	var sender:Buddy=evt.params.buddy;
 * 	
 * 	if(isItMe)
 * 		trace("I said:", evt.params.message);
 * 	else
 * 		trace("My buddy " + sender.name + " said:", evt.params.message);
 * }
 *</listing>
 * 
 * @see		com.smartfoxserver.v2.SmartFox#event:buddyMessage buddyMessage event
 * @see		InitBuddyListRequest
 */
class BuddyMessageRequest extends GenericMessageRequest {

	/** @exclude */
	private var _recipient:Int;
	
	/**
	 * Creates a new<em>BuddyMessageRequest</em>instance.
	 * The instance must be passed to the<em>SmartFox.send()</em>method for the request to be performed.
	 * 
	 * @param	message		The message to be sent to a buddy.
	 * @param	targetBuddy	The<em>Buddy</em>object corresponding to the message recipient.
	 * @param	params		An instance of<em>SFSObject</em>containing additional custom parameters(e.g. the message color, an emoticon id, etc).
	 * 
	 * @see		com.smartfoxserver.v2.SmartFox#send()SmartFox.send()
	 * @see		com.smartfoxserver.v2.entities.data.SFSObject SFSObject
	 */
	public function new(message:String, targetBuddy:Buddy, params:ISFSObject = null) {
		super();
		_type = GenericMessageType.BUDDY_MSG;
		_message = message;
		_recipient = targetBuddy != null ? targetBuddy.id : -1;
		_params = params;
	}

	override public function validate(sfs:SmartFox):Void {
		var errors:Array<String>=[];
		
		if (!sfs.buddyManager.isInited)
			errors.push("BuddyList is not inited. Please send an InitBuddyRequest first.");

		if (sfs.buddyManager.myOnlineState == false)
			errors.push("Can't send messages while off-line");

		if (_message == null || _message.length == 0)
			errors.push("Buddy message is empty!");

		if (_recipient < 0)
			errors.push("Recipient is not online or not in your buddy list");

		if(errors.length>0)
			throw new SFSValidationError("Request error - ", errors);
	}

	override public function execute(sfs:SmartFox):Void
	{
		_sfso.putByte(KEY_MESSAGE_TYPE, _type);
		// Id of the recipient buddy
		_sfso.putInt(KEY_RECIPIENT, _recipient);

		// Message
		_sfso.putUtfString(KEY_MESSAGE, _message);

		// Params
		if(_params !=null)
			_sfso.putSFSObject(KEY_XTRA_PARAMS, _params);
	}
}
