package com.smartfoxserver.v2.core;

/**
 * ...
 * @author vincent blanchet
 */

import com.smartfoxserver.v2.util.ByteArrayConverter;

import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.pad.IPad;
import com.hurlant.crypto.pad.PKCS5;
import com.hurlant.crypto.symmetric.mode.IVMode;
import com.hurlant.crypto.symmetric.ICipher;

import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.util.CryptoKey;

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
		var padding:IPad = new PKCS5();
		
		/*
		trace("IV  : \n" + DefaultObjectDumpFormatter.hexDump(ck.iv))
		trace("KEY : \n" + DefaultObjectDumpFormatter.hexDump(ck.key))
		trace("DATA: \n" + DefaultObjectDumpFormatter.hexDump(data))
		*/

		var ckKey  = ByteArrayConverter.fromOpenFLByteArray(ck.key);
		var ckIv = ByteArrayConverter.fromOpenFLByteArray(ck.iv);
		
			var cipher:ICipher = Crypto.getCipher(ALGORITHM, ckKey, padding);
			var ivmode:IVMode = cast(cipher, IVMode);
			ivmode.IV = ckIv;
			//hackish way to encrypt/decrypt replacing data at the end
			var dataTmp = ByteArrayConverter.fromOpenFLByteArray(data);
			cipher.encrypt(dataTmp);
		
			data.position = 0;
			dataTmp.position = 0;
			while (dataTmp.position < dataTmp.length) data.writeByte(dataTmp.readByte());

		
		
	}
	
	public function decrypt(data:ByteArray):Void
	{
		var ck:CryptoKey = bitSwarm.cryptoKey;
		var padding:IPad = new PKCS5();
		
		var ckKey  = ByteArrayConverter.fromOpenFLByteArray(ck.key);
		var ckIv = ByteArrayConverter.fromOpenFLByteArray(ck.iv);

		var cipher:ICipher = Crypto.getCipher(ALGORITHM, ckKey, padding);
		var ivmode:IVMode = cast(cipher, IVMode);
		ivmode.IV = ckIv;
		//hackish way to encrypt/decrypt replacing data at the end
		var dataTmp = ByteArrayConverter.fromOpenFLByteArray(data);
		cipher.decrypt(dataTmp);

		data.position = 0;
		dataTmp.position = 0;
		while (dataTmp.position < dataTmp.length) data.writeByte(dataTmp.readByte());
		
		
		
	}
}
	
