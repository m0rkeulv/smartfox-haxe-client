SmartFoxServer 2X Haxe client API
=======================

Haxe openfl translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/

**NOTE : This fork is using Haxe code instead of JS externs for HTML5**

The original repo might be more up to date, check it out here:

https://github.com/boorik/smartfox-haxe-client



----------------------------------
CURRENTLY WORKING WITH :

haxe: 4.0.5

lime: 7.6.3

openfl: 8.9.5

crypto: 0.3.0 


----------------------------------


Instructions:
=====
Installation
```
haxelib git smartfox-haxe-client https://github.com/m0rkeulv/smartfox-haxe-client
```

add in your project.xml :
```
<haxelib name="smartfox-haxe-client"/>
```

Then you can use it like the as3 api, check the as3 exemples there :
http://docs2x.smartfoxserver.com/ExamplesFlash/introduction


## Changelog:
### 0.2.6
 - attempt to make code stricter typed / use less dynamic
### 0.2.5
 - replaced haxe-crypto has been replaced with HaxeFoundation/crypto
 - deleted passwordUtil as MD5 really should not be used.
