SmartFoxServer 2X Haxe client API
=======================

Haxe openfl translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/

**NOTE : This fork is using Haxe code instead of JS externs for HTML5**

The original repo might be more up to date, check it out here:

https://github.com/boorik/smartfox-haxe-client



----------------------------------
CURRENTLY WORKING WITH :

haxe: 4.0.2

lime: 7.6.3

openfl: 8.9.5

haxe-crypto: 0.0.7

- Note: 
Hashlink has strict casting rules and SSL wont work with haxe-crypto 0.0.7.
You can find a fork with this fixed here:
https://github.com/m0rkeulv/haxe-crypto

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
