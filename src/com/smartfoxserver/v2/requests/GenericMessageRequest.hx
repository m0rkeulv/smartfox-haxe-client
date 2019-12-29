package com.smartfoxserver.v2.requests;

import openfl.errors.Error;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.exceptions.SFSError;
import com.smartfoxserver.v2.exceptions.SFSValidationError;
import com.smartfoxserver.v2.logging.Logger;
import openfl.errors.ArgumentError;

/** @private */
class GenericMessageRequest extends BaseRequest
{
	/** @exclude */
	public static inline var KEY_ROOM_ID:String="r";					// The room id
	
	/** @exclude */
	public static inline var KEY_USER_ID:String="u";					// The sender(????????????????????????)
	
	/** @exclude */
	public static inline var KEY_MESSAGE:String="m";					// The actual message
	
	/** @exclude */
	public static inline var KEY_MESSAGE_TYPE:String="t";				// The message type
	
	/** @exclude */
	public static inline var KEY_RECIPIENT:String="rc";				// The recipient(for sendObject and sendPrivateMessage)
	
	/** @exclude */
	public static inline var KEY_RECIPIENT_MODE:String="rm";			// For admin/mod messages, indicate toUser, toRoom, toGroup, toZone
	
	/** @exclude */ 
	public static inline var KEY_XTRA_PARAMS:String="p";				// Extra custom parameters(mandatory for sendObject)
	
	/** @exclude */ 
	public static inline var KEY_SENDER_DATA:String="sd";				// The sender User data(when cross room message)
	
	/** @exclude */ 
	public static inline var KEY_AOI:String="aoi";						// Custom AOI for MMO messages
	
	/** @exclude */ 
	private var _type:Int = -1;
	
	/** @exclude */ 
	private var _room:Room;
	
	/** @exclude */ 
	private var _user:User;
	
	/** @exclude */ 
	private var _message:String;
	
	/** @exclude */  									
	private var _params:ISFSObject;
	
	/** @exclude */ 
	private var _sendMode:Int = -1;
	
	/** @exclude */ 
	private var _aoi:Vec3D;
	
	
	public function new()
	{
		super(BaseRequest.GenericMessage);
	}

	
}