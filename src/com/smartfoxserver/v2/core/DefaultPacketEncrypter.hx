package com.smartfoxserver.v2.core;

/**
 * ...
 * @author vincent blanchet
 */

import com.hurlant.crypto.Crypto;
#if flash
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.pad.IPad;
import com.hurlant.crypto.pad.PKCS5;
import com.hurlant.crypto.symmetric.mode.IVMode;
import com.smartfoxserver.v2.util.ByteArrayConverter;
#else
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.symmetric.PKCS5;
import com.hurlant.crypto.symmetric.IVMode;
#end



import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.util.CryptoKey;

import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

class DefaultPacketEncrypter implements IPacketEncrypter
{
	private var bitSwarm:BitSwarmClient;
	private static var ALGORITHM:String = "aes-cbc";
	
	public function new(bitSwarm:BitSwarmClient)
	{
		this.bitSwarm = bitSwarm;
	}
	public function encrypt(data:ByteArray):Void
	{
		var ck:CryptoKey = bitSwarm.cryptoKey;
		
		/*
		trace("IV  : \n" + DefaultObjectDumpFormatter.hexDump(ck.iv))
		trace("KEY : \n" + DefaultObjectDumpFormatter.hexDump(ck.key))
		trace("DATA: \n" + DefaultObjectDumpFormatter.hexDump(data))
		*/

		var padding:IPad = new PKCS5();
		#if flash
			var cipher:ICipher = Crypto.getCipher(ALGORITHM,cast ByteArrayConverter.fromFlashByteArray(ck.key), padding);
			var ivmode:IVMode = cast(cipher, IVMode);
			ivmode.IV = ByteArrayConverter.fromFlashByteArray(ck.iv);
			//hackish way to encrypt/decrypt replacing data at the end
			var dataTmp = ByteArrayConverter.fromFlashByteArray(data);
			cipher.encrypt(dataTmp);
			data.position = 0;
			dataTmp.position = 0;
			while (dataTmp.position < dataTmp.length) data.writeByte(dataTmp.readByte());
		#else
			
			var cipher:ICipher = Crypto.getCipher(ALGORITHM,cast ck.key,cast padding);
			var ivmode:IVMode = cast(cipher, IVMode);
			ivmode.IV = cast ck.iv;
			cipher.encrypt(cast data);
		#end
		
		
		
	}
	
	public function decrypt(data:ByteArray):Void
	{
		var ck:CryptoKey = bitSwarm.cryptoKey;
			
		var padding:IPad = new PKCS5();
		#if flash
			var cipher:ICipher = Crypto.getCipher(ALGORITHM,cast ByteArrayConverter.fromFlashByteArray(ck.key), padding);
			var ivmode:IVMode = cast(cipher, IVMode);
			ivmode.IV = ByteArrayConverter.fromFlashByteArray(ck.iv);
			//hackish way to encrypt/decrypt replacing data at the end
			var dataTmp = ByteArrayConverter.fromFlashByteArray(data);
			cipher.decrypt(dataTmp);
			data.position = 0;
			dataTmp.position = 0;
			while (dataTmp.position < dataTmp.length) data.writeByte(dataTmp.readByte());
		#else
		var cipher:ICipher = Crypto.getCipher(ALGORITHM, cast ck.key,cast padding);
		var ivmode:IVMode = cast(cipher, IVMode);
		ivmode.IV = cast ck.iv;
		cipher.decrypt(cast data);
		#end
		
		
		
	}
}
	
