package com.smartfoxserver.v2.core;

/**
 * ...
 * @author vincent blanchet
 */

import haxe.crypto.mode.Mode;
import haxe.crypto.Aes;
import haxe.crypto.padding.Padding;


import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
import com.smartfoxserver.v2.util.CryptoKey;

import openfl.utils.ByteArray;

class DefaultPacketEncrypter implements IPacketEncrypter
{
	private var aes:Aes = new Aes();
	private var bitSwarm:BitSwarmClient;
	
	private static var ALGORITHM:Mode = Mode.CBC;
	private static var PADDING:Padding = Padding.PKCS7;
	
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

		
		aes.init(ck.key, ck.iv);
		
		
		var encrypted = aes.encrypt(ALGORITHM, data, PADDING);
		
		data.clear();
		data.writeBytes(encrypted);

	}
	
	public function decrypt(data:ByteArray):Void
	{
		var ck:CryptoKey = bitSwarm.cryptoKey;

		aes.init(ck.key, ck.iv);
		
		var encrypted = aes.decrypt(ALGORITHM,  data, PADDING);

		data.clear();
		data.writeBytes(encrypted);
		
		
		
	}
}
	
