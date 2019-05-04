package com.smartfoxserver.v2.util;
/**
*  Class only used to convert flash byteArray to haxe crypto array and back
**/
class ByteArrayConverter {
	#if flash
	public static function toFlashByteArray(byteArray:com.hurlant.util.ByteArray):flash.utils.ByteArray {
		var byteData = new flash.utils.ByteArray();
		for (byte in byteArray.toBytesArray()) byteData.writeByte(byte);
		return byteData;
	}
	
	public static function fromFlashByteArray(byteArray:flash.utils.ByteArray):com.hurlant.util.ByteArray {
		var byteData = new com.hurlant.util.ByteArray();
		var byte:Int;
		byteArray.position = 0;
		while (byteArray.position < byteArray.length) {
			byteData.writeByte(byteArray.readByte());
		}
		return byteData;
	}
	#end
}
