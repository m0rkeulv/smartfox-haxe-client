SmartFoxServer 2X Haxe client API
=======================

Haxe openfl translation of the as3 client for the Smartfox server http://www.smartfoxserver.com/

**WARNING : HTML5 support is a work in progress!**

Tested on flash, windows, ios and android targets.

You can have a look at https://github.com/boorik/smartfox-haxe-fullstack to check a sample project that use the api and haxe all the way.

Pull requests are welcome

Let me know how it works on other targets

Instructions:
=====
Installation
```
haxelib git smartfox-haxe-client https://github.com/chapatiz/smartfox-haxe-client
```

add in your project.xml :
```
<haxelib name="smartfox-haxe-client"/>
```

Then you can use it like the as3 api, check the as3 exemples there :
http://docs2x.smartfoxserver.com/ExamplesFlash/introduction

TODO:
====
* test app
* improve typing
* make it framework agnostic pure haxe without openfl dependency
* make it work with html5 target
