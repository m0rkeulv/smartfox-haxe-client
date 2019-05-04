package com.smartfoxserver.v2.util;
/**
*   Converts between openFL and haxe-crypto ByteArrays
**/
import com.hurlant.util.Endian;
class ByteArrayConverter {

	public static function toOpenFlByteArray(byteArray:com.hurlant.util.ByteArray):openfl.utils.ByteArray {
		var byteData = new openfl.utils.ByteArray();
		byteData.endian = byteArray.endian == Endian.LITTLE_ENDIAN
						?  openfl.utils.Endian.LITTLE_ENDIAN : openfl.utils.Endian.BIG_ENDIAN;
		for (byte in byteArray.toBytesArray()) byteData.writeByte(byte);
		return byteData;
	}

	public static function fromOpenFLByteArray(byteArray:openfl.utils.ByteArray):com.hurlant.util.ByteArray {
		var byteData = new com.hurlant.util.ByteArray();
		byteData.endian = byteArray.endian == openfl.utils.Endian.LITTLE_ENDIAN
						?  com.hurlant.util.Endian.LITTLE_ENDIAN: com.hurlant.util.Endian.BIG_ENDIAN;
		var byte:Int;
		byteArray.position = 0;
		while (byteArray.position < byteArray.length) {
			byteData.writeByte(byteArray.readByte());
		}
		return byteData;
	}
}
