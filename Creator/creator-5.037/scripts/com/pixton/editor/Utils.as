package com.pixton.editor
{
   import com.adobe.images.JPGEncoder;
   import com.adobe.images.PNGEncoder;
   import com.adobe.serialization.json.JSON;
   import com.gamua.flox.utils.Base64;
   import com.pixton.preloader.Status;
   import fl.transitions.TweenEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.IBitmapDrawable;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import org.sepy.io.Serializer;
   
   public final class Utils
   {
      
      public static const EXT_PNG:String = ".png";
      
      public static const EXT_JSON:String = ".json";
      
      private static const DEBUG_REMOTE:Boolean = true;
      
      private static const DEBUG_LOAD:Boolean = true;
      
      public static const SCREEN_CAPTURE_MODE:Boolean = false;
      
      public static const MONITOR:Boolean = false;
      
      public static const WRAP_360:uint = 360;
      
      public static const SNAP_ANGLE:uint = 45;
      
      public static const IMAGE_JPG:uint = 0;
      
      public static const IMAGE_PNG:uint = 1;
      
      public static const NO_SCALE:uint = 0;
      
      public static const EXACT_FIT:uint = 1;
      
      public static const SHOW_ALL:uint = 2;
      
      public static const DEFAULT_PADDING:uint = 2;
      
      private static const JPG_QUALITY:uint = 95;
      
      private static const JPG_QUALITY_LOW:uint = 80;
      
      private static const TWEEN_DURATION:Number = 0.2;
      
      private static const COLOR_SHIFT:Number = 0.5;
      
      private static const ARROW_ANGLE:uint = 150;
      
      private static const ARROW_LENGTH:Number = 6;
      
      private static const AMF_GATEWAY:String = "editor/amfphp/gateway";
      
      private static const useLocalRelPaths:Boolean = true;
      
      private static const _IMAGE_DIR_DEPTH:uint = 4;
      
      private static const VALID_URL_RE:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
      
      public static var server:String;
      
      public static var userData:Object;
      
      public static var bitmapMax:uint = 0;
      
      public static var bitmapTotal:uint = 0;
      
      public static var staticServer:String;
      
      public static var staticServerBase:String;
      
      public static var dynamicServer:String;
      
      public static var assetServer:String;
      
      public static var streamingServer:String;
      
      public static var recordingServer:String;
      
      public static var masterServer:String;
      
      public static var userName:String;
      
      public static var base:String;
      
      public static var scaleFactor:Number = 1;
      
      private static var listeners:Object = {};
      
      private static var lastTime:Number;
      
      private static var scrapBMD:BitmapData;
      
      private static var scrapBM:Bitmap;
      
      private static var netConnection:NetConnection;
      
      private static var sendAndLoadClosure:Function;
      
      private static var latestMethod:String = "";
       
      
      public function Utils()
      {
         super();
      }
      
      public static function monitorMemory(param1:String = "Memory") : void
      {
         if(!MONITOR)
         {
            return;
         }
         javascript("Pixton.monitor",param1 + ": " + Math.round(System.totalMemory / 1000));
      }
      
      private static function requireConnection() : void
      {
         if(netConnection != null)
         {
            return;
         }
         netConnection = new NetConnection();
         netConnection.objectEncoding = ObjectEncoding.AMF3;
         var _loc1_:String = server + base + AMF_GATEWAY + "?u=" + userName;
         netConnection.connect(_loc1_);
         Debug.trace("Connect: " + _loc1_);
      }
      
      public static function remote(param1:String, param2:Object = null, param3:Function = null, param4:Boolean = false, param5:Function = null, param6:Function = null) : *
      {
         var errorHandler:Function = null;
         var responder:Responder = null;
         var args:String = null;
         var o:* = undefined;
         var method:String = param1;
         var data:Object = param2;
         var handler:Function = param3;
         var showProgress:Boolean = param4;
         var onComplete:Function = param5;
         var onError:Function = param6;
         requireConnection();
         if(data == null)
         {
            data = {};
         }
         if(userData != null)
         {
            data.username = userData.username;
            data.password = userData.password;
         }
         if(method == "notifyAdmin" || method == "keepAlive")
         {
            errorHandler = function(param1:*):void
            {
            };
         }
         else
         {
            errorHandler = function(param1:*):void
            {
               if(onError != null)
               {
                  onRemoteError(param1,false);
                  onError(param1);
               }
               else
               {
                  onRemoteError(param1);
               }
               if(handler != null)
               {
                  handler({"error":true});
               }
            };
         }
         addListener(netConnection,NetStatusEvent.NET_STATUS,errorHandler);
         addListener(netConnection,IOErrorEvent.IO_ERROR,errorHandler);
         addListener(netConnection,AsyncErrorEvent.ASYNC_ERROR,errorHandler);
         addListener(netConnection,SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         if(onComplete == null)
         {
            responder = new Responder(handler,errorHandler);
         }
         else
         {
            responder = new Responder(function(param1:Object):void
            {
               if(DEBUG_REMOTE)
               {
                  Debug.trace("Remote: " + Utils.toString(param1).substr(0,32) + "...");
               }
               param1.onComplete = onComplete;
               handler(param1);
            },errorHandler);
         }
         latestMethod = method;
         netConnection.call("Editor." + method,responder,data);
         Debug.trace("REMOTE: " + method);
         if(Debug.ACTIVE && method != "log" && method != "teamLog")
         {
            args = "";
            if(data != null)
            {
               for(o in data)
               {
                  if(String(data[o]).length <= 255)
                  {
                     args += o + "=" + data[o] + "&";
                  }
               }
            }
            if(DEBUG_REMOTE)
            {
               Debug.trace(method + ": " + base + "editor/load?method=" + method + "&" + args);
            }
         }
      }
      
      private static function onRemoteError(param1:*, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         if(param1 is NetStatusEvent)
         {
            if(param1.info.code != "NetConnection.Connect.NetworkChange")
            {
               if(param1.info.code != "NetConnection.Call.BadVersion")
               {
                  _loc3_ = "NetStatusEvent: " + param1.info.code;
                  for(_loc4_ in param1.info)
                  {
                     _loc3_ += "; " + _loc4_ + ": " + param1.info[_loc4_];
                  }
               }
            }
         }
         else if(param1 is IOErrorEvent)
         {
            _loc3_ = "IOErrorEvent: " + param1.toString();
         }
         else if(param1 is AsyncErrorEvent)
         {
            _loc3_ = "AsyncErrorEvent: " + param1.toString();
         }
         else if(param1 is SecurityErrorEvent)
         {
            _loc3_ = "SecurityErrorEvent: " + param1.toString();
         }
         else
         {
            _loc3_ = "Other Error";
         }
         Status.reset();
         if(_loc3_ != null)
         {
            for(_loc5_ in param1)
            {
               if(_loc5_ is String)
               {
                  _loc3_ += "; " + _loc5_ + " = " + param1[_loc5_];
               }
               else
               {
                  _loc3_ += "; " + _loc5_.toString();
               }
            }
         }
         if(param2 && L.isReady())
         {
            if(DEBUG_REMOTE)
            {
               Debug.trace("onRemoteError");
            }
            alert(L.text("error-try-again"));
         }
      }
      
      public static function notifyAdmin(param1:String, param2:Boolean = false) : void
      {
         if(latestMethod == "notifyAdmin")
         {
            return;
         }
         remote("notifyAdmin",{
            "message":latestMethod + ": " + param1,
            "sendEmail":(!!param2 ? 1 : 0)
         });
      }
      
      public static function load(param1:String, param2:Function = null, param3:Boolean = true, param4:uint = 0, param5:Function = null) : Loader
      {
         var _loc6_:Loader = new Loader();
         var _loc7_:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain,!!Globals.IDE ? null : SecurityDomain.currentDomain);
         if(param5 != null)
         {
            addListener(_loc6_.contentLoaderInfo,IOErrorEvent.IO_ERROR,param5);
            addListener(_loc6_.contentLoaderInfo,SecurityErrorEvent.SECURITY_ERROR,param5);
         }
         else
         {
            addListener(_loc6_.contentLoaderInfo,IOErrorEvent.IO_ERROR,Utils.handler);
            addListener(_loc6_.contentLoaderInfo,SecurityErrorEvent.SECURITY_ERROR,Utils.handler);
         }
         if(param2 != null)
         {
            addListener(_loc6_.contentLoaderInfo,Event.COMPLETE,param2,false,false);
         }
         if(param3 && Main.isInitComplete())
         {
            addListener(_loc6_.contentLoaderInfo,ProgressEvent.PROGRESS,Utils.updateProgress);
         }
         var _loc8_:String = "";
         if(param1.match(/^https?:\/\//))
         {
            _loc8_ = "";
         }
         else if(param4 == File.BUCKET_NONE)
         {
            _loc8_ = server;
         }
         else if(param4 == File.BUCKET_STATIC)
         {
            if(useLocalRelPaths && Globals.IDE && !param1.match(/editor\//))
            {
               _loc8_ = "../../static/";
            }
            else
            {
               _loc8_ = staticServer;
            }
         }
         else if(param4 == File.BUCKET_DYNAMIC)
         {
            if(useLocalRelPaths && Globals.IDE && !param1.match(/editor\//) && !param1.match(/character\//) && !param1.match(/propset\//))
            {
               _loc8_ = "../../dynamic/";
            }
            else
            {
               _loc8_ = dynamicServer;
            }
         }
         else if(param4 == File.BUCKET_ASSET)
         {
            if(useLocalRelPaths && Globals.IDE && !param1.match(/editor\//))
            {
               _loc8_ = "../../dynamic/";
            }
            else
            {
               _loc8_ = assetServer;
            }
         }
         else if(param4 == File.BUCKET_STREAMING)
         {
            _loc8_ = streamingServer;
         }
         if(DEBUG_LOAD)
         {
            Debug.trace("LOAD " + _loc8_ + param1);
         }
         _loc6_.load(new URLRequest(_loc8_ + param1),_loc7_);
         return _loc6_;
      }
      
      public static function sendAndLoad(param1:String, param2:Function = null, param3:Boolean = true, param4:Boolean = false) : void
      {
         sendAndLoadClosure = param2;
         var _loc5_:URLRequest = new URLRequest(param1);
         var _loc6_:URLLoader = new URLLoader();
         if(param4)
         {
            _loc6_.dataFormat = URLLoaderDataFormat.VARIABLES;
         }
         else
         {
            _loc6_.dataFormat = URLLoaderDataFormat.TEXT;
         }
         _loc6_.addEventListener(Event.COMPLETE,handlePost);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,Utils.handler);
         _loc5_.method = URLRequestMethod.GET;
         _loc6_.load(_loc5_);
         if(DEBUG_REMOTE)
         {
            Debug.trace("sendAndLoad: " + param1);
         }
      }
      
      private static function handlePost(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         if(DEBUG_REMOTE)
         {
            Debug.trace("Loaded: " + _loc2_.data.substr(0,32) + "...");
         }
         sendAndLoadClosure(_loc2_.data);
         sendAndLoadClosure = null;
      }
      
      public static function loadXML(param1:String, param2:Function) : void
      {
         var urlPrefix:String = null;
         var path:String = param1;
         var closure:Function = param2;
         if(useLocalRelPaths && Globals.IDE)
         {
            urlPrefix = "../../dynamic/";
         }
         else
         {
            urlPrefix = dynamicServer;
         }
         var loader:URLLoader = new URLLoader();
         loader.load(new URLRequest(urlPrefix + path));
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            closure(JSON.decode(param1.target.data));
         });
      }
      
      public static function updateProgress(param1:ProgressEvent) : void
      {
         if(param1.bytesTotal > 0)
         {
            Status.setProgress(param1.bytesLoaded / param1.bytesTotal);
         }
      }
      
      public static function handler(param1:Object) : void
      {
         switch(param1.type)
         {
            case IOErrorEvent.IO_ERROR:
               break;
            case SecurityErrorEvent.SECURITY_ERROR:
         }
         removeListener(param1.target,param1.type,handler);
      }
      
      public static function send(param1:String, param2:Object) : void
      {
         var _loc6_:* = null;
         var _loc3_:URLLoader = new URLLoader();
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(server + param1)).method = URLRequestMethod.POST;
         var _loc5_:URLVariables = new URLVariables();
         for(_loc6_ in param2)
         {
            _loc5_[_loc6_] = param2[_loc6_];
         }
         _loc4_.data = _loc5_;
         _loc3_.load(_loc4_);
      }
      
      public static function hasDefinition(param1:String) : Boolean
      {
         return ApplicationDomain.currentDomain.hasDefinition(param1);
      }
      
      public static function getDefinition(param1:String) : Class
      {
         if(hasDefinition(param1))
         {
            return ApplicationDomain.currentDomain.getDefinition(param1) as Class;
         }
         return null;
      }
      
      public static function getClassName(param1:Object) : String
      {
         return getQualifiedClassName(param1);
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getClassName(param1)));
      }
      
      public static function getAsset(param1:String) : MovieClip
      {
         var _loc2_:Class = getDefinition(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         return new _loc2_() as MovieClip;
      }
      
      public static function mergeObjects(param1:Object, ... rest) : Object
      {
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         for each(_loc3_ in rest)
         {
            if(_loc3_ != null)
            {
               for(_loc4_ in _loc3_)
               {
                  if(_loc3_[_loc4_] != null)
                  {
                     param1[_loc4_] = _loc3_[_loc4_];
                  }
               }
            }
         }
         return param1;
      }
      
      public static function mergeArrays(... rest) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Array)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc2_.push(_loc4_);
               }
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      static function toUnique(param1:Array) : Array
      {
         var a:Array = param1;
         return a.filter(function(param1:*, param2:Number, param3:Array):*
         {
            return param3.indexOf(param1) == param2;
         });
      }
      
      public static function unique(param1:Array, param2:String = null) : void
      {
         if(param2 == null)
         {
            param1.sort();
         }
         else
         {
            param1.sortOn(param2,Array.NUMERIC);
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            while(_loc3_ < param1.length + 1 && (param2 == null && param1[_loc3_] == param1[_loc3_ + 1] || param2 != null && param1[_loc3_ + 1] != null && param1[_loc3_][param2] == param1[_loc3_ + 1][param2]))
            {
               param1.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      public static function getSnapshotData(param1:MovieClip, param2:Boolean = false) : Object
      {
         var _loc3_:BitmapData = renderImage(param1,param1.scaleX);
         if(param2)
         {
            return encodedJPG(_loc3_,param1.scaleX);
         }
         return encodedPNG(_loc3_,param1.scaleX);
      }
      
      public static function getSnapshot(param1:MovieClip) : Bitmap
      {
         var _loc2_:BitmapData = renderImage(param1,param1.scaleX);
         return new Bitmap(_loc2_);
      }
      
      public static function renderImage(param1:MovieClip, param2:Number = 1, param3:MovieClip = null, param4:* = null, param5:Number = -1, param6:Number = -1, param7:Number = 0, param8:Boolean = false) : BitmapData
      {
         var _loc9_:BitmapData = null;
         var _loc10_:Matrix = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Rectangle = null;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         if(param5 > 0 && param6 > 0)
         {
            _loc16_ = param5;
            _loc17_ = param6;
            if((_loc15_ = param1.getBounds(param1)).width / _loc15_.height > (param5 - param7 * 2) / (param6 - param7 * 2))
            {
               _loc12_ = _loc11_ = (param5 - param7 * 2) / _loc15_.width;
               if(param8)
               {
                  _loc17_ = _loc15_.height * _loc11_ + param7 * 2;
               }
            }
            else
            {
               _loc11_ = _loc12_ = (param6 - param7 * 2) / _loc15_.height;
               if(param8)
               {
                  _loc16_ = _loc15_.width * _loc11_ + param7 * 2;
               }
            }
            _loc9_ = new BitmapData(_loc16_,_loc17_,true,0);
            (_loc10_ = new Matrix()).translate(-_loc15_.x,-_loc15_.y);
            _loc10_.scale(_loc11_,_loc12_);
            _loc10_.translate((_loc16_ - _loc15_.width * _loc11_) * 0.5,(_loc17_ - _loc15_.height * _loc12_) * 0.5);
            _loc9_.draw(param1,_loc10_);
         }
         else if(param4 == null)
         {
            _loc10_ = new Matrix(param1.scaleX,0,0,param1.scaleY);
            if(param1 is Panel)
            {
               if(Comic.hasPanelTitles())
               {
                  _loc10_.translate(0,Comic.PANEL_TITLE_HEIGHT);
               }
            }
            if(param1.width > 0 && param1.height > 0)
            {
               (_loc9_ = new BitmapData(param1.width,param1.height,true,0)).draw(param1,_loc10_);
            }
         }
         else
         {
            if(param4 is MovieClip)
            {
               param5 = Math.round(MovieClip(param4).width * param2);
               param6 = Math.round(MovieClip(param4).height * param2);
               _loc11_ = 0;
               _loc12_ = 0;
            }
            else
            {
               if(!(param4 is Rectangle))
               {
                  return null;
               }
               param5 = Rectangle(param4).width;
               param6 = Rectangle(param4).height;
               _loc11_ = Rectangle(param4).x;
               _loc12_ = Rectangle(param4).y;
            }
            if(param5 > 0 && param6 > 0)
            {
               _loc10_ = param3.transform.matrix;
               param3.scaleX = param2;
               param3.scaleY = param2;
               _loc9_ = new BitmapData(param5,param6,param4 is MovieClip,param4 is MovieClip ? uint(0) : uint(16777215));
               _loc13_ = -_loc11_;
               _loc14_ = -_loc12_;
               _loc9_.draw(param1,new Matrix(1,0,0,1,_loc13_,_loc14_));
               param3.transform.matrix = _loc10_;
            }
         }
         return _loc9_;
      }
      
      static function limitScale(param1:Number, param2:MovieClip) : Number
      {
         var _loc3_:Number = Math.ceil(param2.width * param1);
         var _loc4_:Number = Math.ceil(param2.height * param1);
         var _loc5_:Number = _loc3_ * _loc4_;
         var _loc6_:Number = param1;
         if(_loc5_ > bitmapTotal)
         {
            _loc6_ = Math.min(_loc6_,param1 * bitmapTotal / _loc5_);
         }
         if(_loc3_ > bitmapMax)
         {
            _loc6_ = Math.min(_loc6_,param1 * bitmapMax / _loc3_);
         }
         if(_loc4_ > bitmapMax)
         {
            _loc6_ = Math.min(_loc6_,param1 * bitmapMax / _loc4_);
         }
         return _loc6_;
      }
      
      public static function encodedImage(param1:BitmapData, param2:Number, param3:int = -1, param4:Boolean = true) : Object
      {
         if(param3 == IMAGE_JPG)
         {
            return encodedJPG(param1,param2,param4);
         }
         return encodedPNG(param1,param2,param4);
      }
      
      public static function encodedJPG(param1:BitmapData, param2:Number, param3:Boolean = true) : Object
      {
         var _loc4_:uint = param2 == 1 ? uint(JPG_QUALITY) : uint(JPG_QUALITY_LOW);
         var _loc5_:JPGEncoder;
         var _loc6_:ByteArray = (_loc5_ = new JPGEncoder(_loc4_)).encode(param1);
         if(param3)
         {
            _loc6_.position = 0;
            _loc6_.compress();
         }
         var _loc7_:Object;
         (_loc7_ = {}).s = param2;
         _loc7_.imageWidth = param1.width;
         _loc7_.imageHeight = param1.height;
         if(param3)
         {
            _loc7_.data = Base64.encodeByteArray(_loc6_);
         }
         else
         {
            _loc7_.data = _loc6_;
         }
         _loc7_.t = IMAGE_JPG;
         return _loc7_;
      }
      
      public static function encodedPNG(param1:BitmapData, param2:Number, param3:Boolean = true) : Object
      {
         var _loc4_:ByteArray = PNGEncoder.encode(param1);
         if(param3)
         {
            _loc4_.position = 0;
            _loc4_.compress();
         }
         var _loc5_:Object;
         (_loc5_ = {}).s = param2;
         _loc5_.imageWidth = param1.width;
         _loc5_.imageHeight = param1.height;
         if(param3)
         {
            _loc5_.data = Base64.encodeByteArray(_loc4_);
         }
         else
         {
            _loc5_.data = _loc4_;
         }
         _loc5_.t = IMAGE_PNG;
         return _loc5_;
      }
      
      public static function capture(param1:Sprite, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:int = param4 - param2;
         var _loc7_:int = param5 - param3;
         var _loc8_:BitmapData;
         (_loc8_ = new BitmapData(_loc6_,_loc7_,false)).draw(param1,new Matrix(1,0,0,1,-param2,-param3));
         var _loc9_:uint = JPG_QUALITY;
         var _loc10_:JPGEncoder;
         var _loc11_:ByteArray = (_loc10_ = new JPGEncoder(_loc9_)).encode(_loc8_);
         var _loc12_:URLRequest;
         (_loc12_ = new URLRequest("__capture.php")).method = URLRequestMethod.POST;
         var _loc13_:URLVariables;
         (_loc13_ = new URLVariables()).imageData = Base64.encodeByteArray(_loc11_);
         _loc12_.data = _loc13_;
         navigateToURL(_loc12_,"_blank");
      }
      
      public static function setColor(param1:Object, param2:Array = null, param3:Number = 0, param4:Boolean = false, param5:Number = 1) : void
      {
         if(isNaN(param3))
         {
            param3 = 0;
         }
         if(param2 == null)
         {
            param1.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else if(param3 == -1)
         {
            param1.transform.colorTransform = new ColorTransform(param2[Palette.R] / 255,param2[Palette.G] / 255,param2[Palette.B] / 255,1,0,0,0,0);
         }
         else if(param2[Palette.A] != null)
         {
            param1.transform.colorTransform = new ColorTransform(param3,param3,param3,0,(1 - param3) * param2[Palette.R],(1 - param3) * param2[Palette.G],(1 - param3) * param2[Palette.B],param2[Palette.A]);
         }
         else
         {
            param1.transform.colorTransform = new ColorTransform(param3,param3,param3,!!param4 ? Number(1) : Number(0),(1 - param3) * param2[Palette.R],(1 - param3) * param2[Palette.G],(1 - param3) * param2[Palette.B],!!param4 ? Number(0) : Number(param5 * 255));
         }
      }
      
      public static function r2d(param1:Number) : Number
      {
         return param1 * 180 / Math.PI;
      }
      
      public static function d2r(param1:Number) : Number
      {
         return param1 * Math.PI / 180;
      }
      
      public static function matchPosition(param1:Object, param2:Object, param3:Boolean = false) : void
      {
         var _loc5_:Point = null;
         if(param1.parent == null)
         {
            return;
         }
         var _loc4_:Point = new Point(param2.x,param2.y);
         if(param2 is MovieClip)
         {
            _loc5_ = param1.parent.globalToLocal(param2.parent.localToGlobal(_loc4_));
         }
         else
         {
            _loc5_ = param1.parent.globalToLocal(_loc4_);
         }
         param1.x = _loc5_.x;
         param1.y = _loc5_.y + (!!param3 ? Main.self.y : 0);
      }
      
      public static function startsWith(param1:String, param2:String) : Boolean
      {
         return param1.substr(0,param2.length) == param2;
      }
      
      public static function startsWithArr(param1:String, param2:Array) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            if(_loc3_ == param1.substr(0,_loc3_.length))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function inArray(param1:Object, param2:Array) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            if(_loc3_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getIndex(param1:DisplayObject) : int
      {
         if(param1.parent == null)
         {
            return -1;
         }
         return param1.parent.getChildIndex(param1);
      }
      
      public static function rearrange(param1:DisplayObject, param2:Boolean = true, param3:int = -1, param4:DisplayObject = null, param5:Class = null) : void
      {
         if(param2)
         {
            if(param3 == 1)
            {
               param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
            }
            else
            {
               param1.parent.setChildIndex(param1,0);
            }
         }
         else
         {
            if(param4 == null)
            {
               param4 = getOverlapping(param1 as MovieClip,param3,param5);
            }
            if(param4 != null)
            {
               param1.parent.setChildIndex(param1,param4.parent.getChildIndex(param4));
            }
         }
      }
      
      public static function getOverlapping(param1:MovieClip, param2:int, param3:Class = null) : DisplayObject
      {
         var _loc5_:uint = 0;
         var _loc7_:DisplayObject = null;
         var _loc10_:uint = 0;
         var _loc4_:DisplayObjectContainer;
         var _loc6_:uint = (_loc4_ = param1.parent).numChildren;
         var _loc8_:uint = _loc4_.getChildIndex(param1);
         var _loc9_:uint = param2 == 1 ? uint(_loc6_ - _loc8_ - 1) : uint(_loc8_);
         _loc5_ = 0;
         while(_loc5_ < _loc9_)
         {
            _loc10_ = _loc8_ + param2 * (_loc5_ + 1);
            _loc7_ = _loc4_.getChildAt(_loc10_);
            if(!(param3 != null && !(_loc7_ is param3)))
            {
               if(Collision.isColliding(param1,_loc7_,_loc4_,true))
               {
                  return _loc7_;
               }
            }
            _loc5_++;
         }
         return null;
      }
      
      public static function drawArc(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         switch(param5)
         {
            case 1:
               param1.curveTo(-param4 + param2,-Math.tan(Math.PI / 8) * param4 + param3,-Math.sin(Math.PI / 4) * param4 + param2,-Math.sin(Math.PI / 4) * param4 + param3);
               param1.curveTo(-Math.tan(Math.PI / 8) * param4 + param2,-param4 + param3,param2,-param4 + param3);
               break;
            case 2:
               param1.curveTo(Math.tan(Math.PI / 8) * param4 + param2,-param4 + param3,Math.sin(Math.PI / 4) * param4 + param2,-Math.sin(Math.PI / 4) * param4 + param3);
               param1.curveTo(param4 + param2,-Math.tan(Math.PI / 8) * param4 + param3,param4 + param2,param3);
               break;
            case 3:
               param1.curveTo(param4 + param2,Math.tan(Math.PI / 8) * param4 + param3,Math.sin(Math.PI / 4) * param4 + param2,Math.sin(Math.PI / 4) * param4 + param3);
               param1.curveTo(Math.tan(Math.PI / 8) * param4 + param2,param4 + param3,param2,param4 + param3);
               break;
            case 4:
               param1.curveTo(-Math.tan(Math.PI / 8) * param4 + param2,param4 + param3,-Math.sin(Math.PI / 4) * param4 + param2,Math.sin(Math.PI / 4) * param4 + param3);
               param1.curveTo(-param4 + param2,Math.tan(Math.PI / 8) * param4 + param3,-param4 + param2,param3);
         }
      }
      
      public static function getPoint(param1:Point, param2:Point, param3:Number) : Point
      {
         return new Point(param1.x + param2.x - param1.x * param3,param1.y + param2.y - param1.y * param3);
      }
      
      public static function addListener(param1:Object, param2:Object, param3:Function, param4:Boolean = false, param5:Boolean = true) : void
      {
         if(param4 && param1.hasEventListener(param2))
         {
            return;
         }
         param1.addEventListener(param2,param3,false,0,param5);
         trackListener(param1,param2);
      }
      
      public static function removeListener(param1:Object, param2:Object, param3:Function, param4:Boolean = true) : void
      {
         if(param4 && !param1.hasEventListener(param2))
         {
            return;
         }
         if(param3 != null)
         {
            param1.removeEventListener(param2,param3,false);
         }
         trackListener(param1,param2,false);
      }
      
      private static function trackListener(param1:Object, param2:Object, param3:Boolean = true) : void
      {
         var _loc4_:String = null;
         if(!Debug.ACTIVE)
         {
            return;
         }
         if(param1 is MovieClip || param1 is Sprite)
         {
            _loc4_ = param1 + (param1.name != null ? " (" + param1.name + "): " : ": ") + param2;
         }
         else
         {
            _loc4_ = param1 + ": " + param2;
         }
         if(param3)
         {
            if(listeners[_loc4_] == undefined || isNaN(listeners[_loc4_]))
            {
               listeners[_loc4_] = 0;
            }
            ++listeners[_loc4_];
         }
         else
         {
            --listeners[_loc4_];
            if(listeners[_loc4_] == 0 || listeners[_loc4_] == undefined || isNaN(listeners[_loc4_]))
            {
               delete listeners[_loc4_];
            }
         }
      }
      
      public static function showListeners() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         Debug.trace("");
         for(_loc2_ in listeners)
         {
            Debug.trace(_loc1_ + ": " + _loc2_ + ": " + listeners[_loc2_]);
            _loc1_++;
         }
      }
      
      public static function fit(param1:MovieClip, param2:MovieClip, param3:uint = 0, param4:Boolean = false, param5:Object = null, param6:Number = 2, param7:Number = 1) : void
      {
         var _loc10_:Rectangle = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Rectangle = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc8_:int = param1.scaleX < 0 ? -1 : 1;
         var _loc9_:int = param1.scaleY < 0 ? -1 : 1;
         if(param5 == null)
         {
            _loc10_ = param1.getBounds(param2.parent);
         }
         else if(param5 is Array)
         {
            _loc10_ = getUnionRect(param5 as Array,param2.parent as MovieClip);
         }
         else
         {
            _loc10_ = param5.getBounds(param2.parent);
         }
         _loc11_ = param2.getBounds(param2.parent);
         if(param3 == EXACT_FIT)
         {
            _loc13_ = (_loc11_.width - param6 * 2) / _loc10_.width;
            _loc14_ = (_loc11_.height - param6 * 2) / _loc10_.height;
         }
         else if(param3 == SHOW_ALL)
         {
            _loc15_ = _loc10_.width / _loc10_.height;
            _loc16_ = _loc11_.width / _loc11_.height;
            if(_loc15_ > _loc16_)
            {
               _loc13_ = _loc14_ = (_loc11_.height - param6 * 2) / _loc10_.height;
            }
            else
            {
               _loc14_ = _loc13_ = (_loc11_.width - param6 * 2) / _loc10_.width;
            }
         }
         else
         {
            _loc14_ = _loc13_ = Math.min((_loc11_.width - param6 * 2) / _loc10_.width,(_loc11_.height - param6 * 2) / _loc10_.height);
         }
         param1.scaleX = _loc13_ * _loc8_ * param7;
         param1.scaleY = _loc14_ * _loc9_ * param7;
         if(param5 == null)
         {
            _loc12_ = param1.getBounds(param1.parent);
         }
         else if(param5 is Array)
         {
            _loc12_ = getUnionRect(param5 as Array,param1.parent as MovieClip);
         }
         else
         {
            _loc12_ = param5.getBounds(param1.parent);
         }
         param1.x = param2.x + param1.x - _loc12_.x + (_loc11_.width - _loc12_.width) * 0.5;
         if(param4)
         {
            param1.y = param2.y + param1.y - _loc12_.y + _loc11_.height - _loc12_.height - param6;
         }
         else
         {
            param1.y = param2.y + param1.y - _loc12_.y + (_loc11_.height - _loc12_.height) * 0.5;
         }
      }
      
      public static function getUnionRect(param1:Array, param2:MovieClip) : Rectangle
      {
         var _loc3_:Rectangle = null;
         var _loc4_:MovieClip = null;
         for each(_loc4_ in param1)
         {
            if(_loc3_ == null)
            {
               _loc3_ = _loc4_.getBounds(param2);
            }
            else
            {
               _loc3_ = _loc3_.union(_loc4_.getBounds(param2));
            }
         }
         return _loc3_;
      }
      
      public static function toString(param1:Object) : String
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         if(param1 is Boolean || param1 is String || param1 is Number)
         {
            return String(param1);
         }
         _loc2_ = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_ + ": { " + toString(param1[_loc3_]) + " }");
         }
         return _loc2_.join(", ");
      }
      
      public static function tween(param1:DisplayObject, param2:String, param3:Number, param4:Number = NaN, param5:Number = 0, param6:Function = null) : PixtonTween
      {
         if(isNaN(param5))
         {
            param5 = 0;
         }
         if(isNaN(param4))
         {
            param4 = param1[param2];
         }
         if(param5 == 0)
         {
            param5 = TWEEN_DURATION;
         }
         if(!param1.visible)
         {
            param1.visible = true;
         }
         var _loc7_:PixtonTween = new PixtonTween(param1,param2,param3,param4,param5);
         if(param6 != null)
         {
            addListener(_loc7_.tween,TweenEvent.MOTION_FINISH,param6);
         }
         return _loc7_;
      }
      
      public static function getIntersect(... rest) : Object
      {
         var _loc2_:Number = rest[2] - rest[0];
         var _loc3_:Number = rest[3] - rest[1];
         var _loc4_:Number = rest[6] - rest[4];
         var _loc5_:Number = rest[7] - rest[5];
         var _loc6_:Number = _loc4_ * _loc3_ - _loc5_ * _loc2_;
         var _loc7_:Number = (_loc4_ * (rest[5] - rest[1]) + _loc5_ * (rest[0] - rest[4])) / _loc6_;
         return {
            "x":rest[0] + _loc7_ * _loc2_,
            "y":rest[1] + _loc7_ * _loc3_
         };
      }
      
      public static function getBounds(param1:Array) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc4_:Object = null;
         var _loc3_:Object = {};
         for each(_loc4_ in param1)
         {
            _loc2_ = _loc4_.getBounds(param1[0].parent);
            if(_loc3_.x == null || _loc2_.x < _loc3_.x)
            {
               _loc3_.x = _loc2_.x;
            }
            if(_loc3_.y == null || _loc2_.y < _loc3_.y)
            {
               _loc3_.y = _loc2_.y;
            }
            if(_loc3_.maxX == null || _loc2_.x + _loc2_.width > _loc3_.maxX)
            {
               _loc3_.maxX = _loc2_.x + _loc2_.width;
            }
            if(_loc3_.maxY == null || _loc2_.y + _loc2_.height > _loc3_.maxY)
            {
               _loc3_.maxY = _loc2_.y + _loc2_.height;
            }
         }
         return new Rectangle(_loc3_.x,_loc3_.y,_loc3_.maxX - _loc3_.x,_loc3_.maxY - _loc3_.y);
      }
      
      public static function drawBorder(param1:MovieClip, param2:Object, param3:uint = 0) : void
      {
         param1.graphics.clear();
         param1.graphics.lineStyle(1,param3,1);
         param1.graphics.moveTo(0,0);
         param1.graphics.lineTo(param2.width - 1,0);
         param1.graphics.lineTo(param2.width - 1,param2.height);
         param1.graphics.lineTo(0,param2.height);
         param1.graphics.lineTo(0,0);
      }
      
      public static function alert(param1:String) : void
      {
         javascript("Pixton.alert",param1);
      }
      
      public static function javascript(param1:*, param2:* = null, param3:* = null, param4:* = null) : *
      {
         if(ExternalInterface.available && !Status.isLocal())
         {
            return ExternalInterface.call(param1,param2,param3,param4);
         }
         return true;
      }
      
      public static function distanceBetween(param1:Object, param2:Object) : Number
      {
         return Math.sqrt(Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      public static function distance(param1:Object, param2:Point) : Number
      {
         var _loc3_:Point = null;
         if(param1 is MovieClip)
         {
            _loc3_ = param1.localToGlobal(new Point(0,0));
         }
         else
         {
            _loc3_ = param1 as Point;
         }
         return Point.distance(_loc3_,param2);
      }
      
      public static function getPosition(param1:DisplayObject, param2:DisplayObject, param3:Number = 0, param4:Number = 0, param5:DisplayObject = null) : Object
      {
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(isNaN(param3))
         {
            param3 = 0;
         }
         if(isNaN(param4))
         {
            param4 = 0;
         }
         if(param5 != null && (param3 != 0 || param4 != 0))
         {
            _loc7_ = d2r(param5.rotation);
            _loc8_ = Math.sin(_loc7_);
            _loc9_ = Math.cos(_loc7_);
            _loc10_ = param4 * _loc8_ + param3 * _loc9_;
            _loc11_ = param3 * _loc8_ + param4 * _loc9_;
            param3 = -_loc10_;
            param4 = _loc11_;
         }
         _loc6_ = param2.globalToLocal(param1.parent.localToGlobal(new Point(param1.x + param3,param1.y + param4)));
         return {
            "x":_loc6_.x,
            "y":_loc6_.y
         };
      }
      
      public static function getEventPoint(param1:MouseEvent, param2:DisplayObject) : Object
      {
         var _loc3_:Point = param2.globalToLocal(param1.target.localToGlobal(new Point(param1.localX,param1.localY)));
         return {
            "x":_loc3_.x,
            "y":_loc3_.y
         };
      }
      
      public static function randomString(param1:uint = 8, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc6_:uint = 0;
         var _loc4_:String = "";
         var _loc5_:uint = !!param2 ? uint(10) : uint(36);
         var _loc7_:uint = 0;
         while(_loc7_ < param1)
         {
            if((_loc6_ = 1 + Math.floor(Math.random() * (_loc5_ - 1))) > 10)
            {
               _loc3_ = String.fromCharCode(_loc6_ + 86);
            }
            else
            {
               _loc3_ = String.fromCharCode(_loc6_ + 47);
            }
            _loc4_ += _loc3_;
            _loc7_++;
         }
         return _loc4_;
      }
      
      public static function normalize(param1:Number, param2:Number, param3:uint = 4) : Number
      {
         var _loc4_:uint = 0;
         var _loc5_:Number = 0;
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            _loc5_ += param1 + Math.random() * (param2 - param1);
            _loc4_++;
         }
         return _loc5_ / param3;
      }
      
      public static function limit(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function wrap(param1:Number, param2:uint = 360) : Number
      {
         while(param1 < 0 || param1 >= param2)
         {
            param1 = (param1 + param2) % param2;
         }
         return param1;
      }
      
      public static function getIntersection(param1:Object, param2:Object, param3:Object, param4:Object) : Object
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc7_:Number = (param2.y - param1.y) / (param2.x - param1.x);
         var _loc8_:Number = param1.y - _loc7_ * param1.x;
         var _loc9_:Number = (param4.y - param3.y) / (param4.x - param3.x);
         var _loc10_:Number = param3.y - _loc9_ * param3.x;
         if(_loc7_ == _loc9_)
         {
            return null;
         }
         _loc11_ = Utils.wrap(Utils.r2d(Math.atan2(param2.y - param1.y,param2.x - param1.x)));
         _loc12_ = Utils.wrap(Utils.r2d(Math.atan2(param4.y - param3.y,param4.x - param3.x)));
         if(Math.abs(_loc11_ - _loc12_) < 5)
         {
            return null;
         }
         if(param2.x == param1.x)
         {
            _loc5_ = param1.x;
            _loc6_ = _loc9_ * _loc5_ + _loc10_;
         }
         else if(param4.x == param3.x)
         {
            _loc5_ = param3.x;
            _loc6_ = _loc7_ * _loc5_ + _loc8_;
         }
         else
         {
            _loc5_ = (_loc10_ - _loc8_) / (_loc7_ - _loc9_);
            _loc6_ = _loc7_ * _loc5_ + _loc8_;
         }
         return {
            "x":_loc5_,
            "y":_loc6_
         };
      }
      
      public static function getControlPoint(param1:Object, param2:Object, param3:Object, param4:Number = 0.5, param5:Boolean = false) : Object
      {
         var _loc6_:Object = {
            "x":(param1.x + param2.x) * 0.5,
            "y":(param1.y + param2.y) * 0.5
         };
         var _loc7_:Number = distanceBetween(param1,param2) * param4;
         var _loc8_:Number = Utils.d2r(Utils.r2d(Math.atan2(param2.y - param1.y,param2.x - param1.x)) + 90);
         var _loc9_:Number = _loc7_ * Math.cos(_loc8_);
         var _loc10_:Number = _loc7_ * Math.sin(_loc8_);
         var _loc11_:Object = {
            "x":_loc6_.x + _loc9_,
            "y":_loc6_.y + _loc10_
         };
         var _loc12_:Object = {
            "x":_loc6_.x - _loc9_,
            "y":_loc6_.y - _loc10_
         };
         var _loc13_:Number = distanceBetween(_loc11_,param3);
         var _loc14_:Number = distanceBetween(_loc12_,param3);
         if(!param5)
         {
         }
         if(param4 >= 0 && _loc13_ < _loc14_ || param4 < 0 && _loc13_ >= _loc14_)
         {
            return _loc12_;
         }
         return _loc11_;
      }
      
      public static function pointInside(param1:Object, param2:DisplayObject, param3:Boolean = false) : Boolean
      {
         if(scrapBMD == null)
         {
            scrapBMD = new BitmapData(300,300,true,0);
         }
         else
         {
            scrapBMD.fillRect(new Rectangle(0,0,300,300),0);
         }
         var _loc4_:Rectangle = param2.getBounds(param2);
         scrapBMD.draw(param2,new Matrix(1,0,0,1,-_loc4_.x,-_loc4_.y));
         if(param3 && param2.stage)
         {
            if(scrapBM == null)
            {
               scrapBM = new Bitmap();
               param2.stage.addChild(scrapBM);
            }
            scrapBM.bitmapData = scrapBMD.clone();
            scrapBM.bitmapData.setPixel(param1.x - _loc4_.x,param1.y - _loc4_.y,16776960);
         }
         return (scrapBMD.getPixel32(param1.x - _loc4_.x,param1.y - _loc4_.y) >> 24 & 255) == 255;
      }
      
      public static function swap(param1:Array, param2:Object, param3:Object) : void
      {
         var _loc4_:Object = param1[param2];
         param1[param2] = param1[param3];
         param1[param3] = _loc4_;
      }
      
      public static function getIntersection2(param1:Object, param2:Object, param3:Object, param4:Object) : Object
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Object = {};
         var _loc8_:Number;
         if((_loc8_ = (param2.x - param1.x) * (param4.y - param3.y) - (param2.y - param1.y) * (param4.x - param3.x)) == 0)
         {
            return null;
         }
         var _loc9_:Number;
         _loc5_ = (_loc9_ = (param1.y - param3.y) * (param4.x - param3.x) - (param1.x - param3.x) * (param4.y - param3.y)) / _loc8_;
         var _loc10_:Number;
         _loc6_ = (_loc10_ = (param1.y - param3.y) * (param2.x - param1.x) - (param1.x - param3.x) * (param2.y - param1.y)) / _loc8_;
         var _loc11_:Number = 0;
         if(_loc5_ < -_loc11_ || _loc5_ > 1 + _loc11_ || _loc6_ < -_loc11_ || _loc6_ > 1 + _loc11_)
         {
            return null;
         }
         return {
            "x":param1.x + _loc5_ * (param2.x - param1.x),
            "y":param1.y + _loc5_ * (param2.y - param1.y)
         };
      }
      
      public static function normalizeAngle(param1:Number) : Number
      {
         if(param1 < 180)
         {
            while(param1 < -180)
            {
               param1 += 360;
            }
         }
         else if(param1 >= 180)
         {
            while(param1 >= 180)
            {
               param1 -= 360;
            }
         }
         return param1;
      }
      
      public static function markTime(param1:String) : void
      {
         var _loc2_:Number = getTimer();
         var _loc3_:Number = !!isNaN(lastTime) ? Number(0) : Number(_loc2_ - lastTime);
         lastTime = _loc2_;
      }
      
      public static function useHand(param1:MovieClip, param2:Boolean = true) : void
      {
         param1.buttonMode = param2 && !SCREEN_CAPTURE_MODE;
         param1.useHandCursor = param2 && !SCREEN_CAPTURE_MODE;
      }
      
      public static function getMidPoint(param1:Object, param2:Object) : Object
      {
         return {
            "x":(param1.x + param2.x) * 0.5,
            "y":(param1.y + param2.y) * 0.5
         };
      }
      
      public static function getDistance(param1:Object, param2:Object) : Number
      {
         return Math.sqrt(Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      public static function drawArrow(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         if(param2 == param4 && param3 == param5)
         {
            return;
         }
         var _loc6_:Graphics = param1.graphics;
         var _loc7_:Number = d2r(ARROW_ANGLE);
         var _loc8_:Number = ARROW_LENGTH / param1.scaleX;
         var _loc9_:Object = {
            "x":(param2 + param4) * 0.5,
            "y":(param3 + param5) * 0.5
         };
         var _loc10_:Number = Math.atan2(param5 - param3,param4 - param2);
         _loc6_.moveTo(param2,param3);
         _loc6_.lineTo(param4,param5);
         _loc6_.moveTo(_loc9_.x,_loc9_.y);
         _loc6_.lineTo(_loc9_.x + Math.cos(_loc10_ + _loc7_) * _loc8_,_loc9_.y + Math.sin(_loc10_ + _loc7_) * _loc8_);
         _loc6_.moveTo(_loc9_.x,_loc9_.y);
         _loc6_.lineTo(_loc9_.x + Math.cos(_loc10_ - _loc7_) * _loc8_,_loc9_.y + Math.sin(_loc10_ - _loc7_) * _loc8_);
      }
      
      public static function random(param1:Number = 2) : Number
      {
         return (Math.random() - 0.5) * param1;
      }
      
      public static function clone(param1:*) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         if(param1 is Array)
         {
            _loc5_ = [];
            _loc3_ = param1.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc5_[_loc2_] = clone(param1[_loc2_]);
               _loc2_++;
            }
         }
         else
         {
            if(!(typeof param1 == "object" && param1 != null))
            {
               return param1;
            }
            _loc5_ = {};
            for(_loc4_ in param1)
            {
               _loc5_[_loc4_] = clone(param1[_loc4_]);
            }
         }
         return _loc5_;
      }
      
      public static function encode(param1:Object) : String
      {
         return com.adobe.serialization.json.JSON.encode(param1);
      }
      
      public static function decode(param1:String) : Object
      {
         var ret:Object = null;
         var ba:ByteArray = null;
         var data:String = param1;
         try
         {
            ret = com.adobe.serialization.json.JSON.decode(data);
         }
         catch(error:Error)
         {
            try
            {
               ba = Base64.decodeToByteArray(data);
               ba.position = 0;
               ba.uncompress();
               ba.position = 0;
               ret = ba.readObject();
            }
            catch(error2:Error)
            {
               try
               {
                  ret = Serializer.unserialize(data);
               }
               catch(error3:Error)
               {
                  ret = null;
               }
            }
         }
         return ret;
      }
      
      public static function invalidate(param1:DisplayObject) : void
      {
         if(param1.stage != null)
         {
            param1.stage.invalidate();
         }
      }
      
      public static function toFixed(param1:Number, param2:uint) : Number
      {
         return Number(param1.toFixed(param2));
      }
      
      public static function _get(param1:String, param2:Object, param3:* = null) : *
      {
         if(param2 == null || param2[param1] == null)
         {
            return param3;
         }
         return param2[param1];
      }
      
      public static function initObject(param1:Object, ... rest) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:String = null;
         var _loc4_:uint = rest.length;
         if(param1 == null)
         {
            param1 = {};
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = rest[_loc3_].toString();
            if(param1[_loc5_] == null)
            {
               param1[_loc5_] = {};
            }
            param1 = param1[_loc5_];
            _loc3_++;
         }
      }
      
      public static function keepInside(param1:*, param2:Rectangle, param3:Number = 10) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Point = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:Object = null;
         var _loc9_:uint = 0;
         if(!(param1 is Array))
         {
            param1 = [param1];
         }
         for each(_loc6_ in param1)
         {
            _loc4_ = _loc6_.getBounds(_loc6_.stage);
            _loc7_ = (_loc5_ = _loc6_.localToGlobal(new Point(0,0))).x;
            _loc8_ = _loc5_.y;
            if(_loc5_.x < param2.topLeft.x + param3)
            {
               _loc7_ = param2.topLeft.x + param3;
            }
            else if(_loc5_.x > param2.bottomRight.x - param3)
            {
               _loc7_ = param2.bottomRight.x - param3;
            }
            if(_loc5_.y < param2.topLeft.y + param3)
            {
               _loc8_ = param2.topLeft.y + param3;
            }
            else if(_loc5_.y > param2.bottomRight.y - param3)
            {
               _loc8_ = param2.bottomRight.y - param3;
            }
            if(_loc7_ == _loc5_.x && _loc8_ == _loc5_.y)
            {
               _loc9_++;
            }
            _loc5_ = _loc6_.parent.globalToLocal(new Point(_loc7_,_loc8_));
            _loc10_ = {
               "target":_loc6_,
               "point":_loc5_
            };
         }
         if(_loc9_ == 0 && _loc10_ != null)
         {
            _loc6_ = _loc10_.target;
            _loc5_ = _loc10_.point;
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
         }
      }
      
      public static function shuffle(param1:Array) : void
      {
         var a:Array = param1;
         var randomize:Function = function(param1:*, param2:*):Number
         {
            return Math.round(Math.random() * 2) - 1;
         };
         a.sort(randomize);
      }
      
      public static function arrayToInts(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(parseInt(_loc3_));
         }
         return _loc2_;
      }
      
      public static function formatNumber(param1:*) : *
      {
         var _loc4_:String = null;
         param1 = parseInt(param1);
         if(param1 == 0)
         {
            return param1;
         }
         var _loc2_:String = "";
         var _loc3_:int = Math.abs(Math.log(param1 < 0 ? Number(-param1) : Number(param1)) * Math.LOG10E / 3);
         if(_loc3_ < 1)
         {
            return param1;
         }
         _loc4_ = String(param1);
         return formatNumber(_loc4_.substr(0,_loc4_.length - 3)) + "," + _loc4_.substr(_loc4_.length - 3,3);
      }
      
      public static function trim(param1:String) : String
      {
         var _loc2_:String = param1;
         var _loc3_:RegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
         if(_loc3_.test(_loc2_))
         {
            _loc2_ = _loc2_.replace(_loc3_,"$2");
         }
         else
         {
            _loc3_ = /^(\s+)$/;
            if(_loc3_.test(_loc2_))
            {
               _loc2_ = "";
            }
         }
         return _loc2_;
      }
      
      public static function makePath(param1:String) : String
      {
         return server + base + param1;
      }
      
      public static function explode(param1:Object) : String
      {
         var _loc3_:* = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_ + " = " + param1[_loc3_]);
         }
         return _loc2_.join(", ");
      }
      
      public static function transposePosition(param1:Object, param2:MovieClip, param3:MovieClip) : void
      {
         var _loc4_:Point = new Point(param1.x,param1.y);
         var _loc5_:Point = param3.globalToLocal(param2.localToGlobal(_loc4_));
         param1.x = _loc5_.x;
         param1.y = _loc5_.y;
         param1.rotation += param2.parent.rotation - param3.parent.rotation;
      }
      
      public static function empty(param1:*) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         if(param1 is Array)
         {
            return param1.length == 0;
         }
         if(param1 is String)
         {
            return param1 == "";
         }
         return param1 == 0;
      }
      
      public static function isEmptyObj(param1:Object) : Boolean
      {
         var _loc3_:* = null;
         var _loc2_:uint = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         return _loc2_ == 0;
      }
      
      public static function getResampledBitmapData(param1:IBitmapDrawable, param2:Number, param3:Number) : BitmapData
      {
         var _loc4_:BitmapData = null;
         if(param1 is DisplayObject)
         {
            _loc4_ = getBitmapDataFromDisplayObject(DisplayObject(param1));
         }
         else
         {
            if(!(param1 is BitmapData))
            {
               return null;
            }
            _loc4_ = param1 as BitmapData;
         }
         var _loc5_:Matrix;
         (_loc5_ = new Matrix()).scale(param2 / _loc4_.width,param3 / _loc4_.height);
         var _loc6_:BitmapData;
         (_loc6_ = new BitmapData(param2,param3,true,0)).draw(_loc4_,_loc5_,null,null,null,true);
         if(param1 is DisplayObject)
         {
            _loc4_.dispose();
         }
         return _loc6_;
      }
      
      public static function getResampledBitmap(param1:IBitmapDrawable, param2:Number, param3:Number) : Bitmap
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(getResampledBitmapData(param1,param2,param3))).smoothing = true;
         return _loc4_;
      }
      
      protected static function getBitmapDataFromDisplayObject(param1:DisplayObject) : BitmapData
      {
         var _loc2_:Rectangle = DisplayObject(param1).getBounds(DisplayObject(param1));
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         var _loc4_:Matrix;
         (_loc4_ = new Matrix()).translate(-_loc2_.x,-_loc2_.y);
         _loc3_.draw(param1,_loc4_,null,null,null,true);
         return _loc3_;
      }
      
      public static function rectGlobalToLocal(param1:Rectangle, param2:MovieClip) : Rectangle
      {
         var _loc3_:Point = param2.globalToLocal(new Point(param1.x,param1.y));
         var _loc4_:Point = param2.globalToLocal(new Point(param1.bottomRight.x,param1.bottomRight.y));
         return new Rectangle(_loc3_.x,_loc3_.y,_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
      }
      
      public static function getLocation(param1:MovieClip, param2:MovieClip) : Point
      {
         return param2.globalToLocal(param1.localToGlobal(new Point(0,0)));
      }
      
      public static function ucFirst(param1:String) : String
      {
         return param1.substr(0,1).toUpperCase() + param1.substr(1);
      }
      
      public static function isValidURL(param1:String) : Boolean
      {
         return param1.match(VALID_URL_RE) != null;
      }
      
      public static function directify(param1:String) : *
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < _IMAGE_DIR_DEPTH)
         {
            _loc2_.push(param1.substr(_loc3_,1));
            _loc3_++;
         }
         return _loc2_.join("/") + "/";
      }
      
      public static function v(param1:uint) : String
      {
         if(param1 == 0)
         {
            return "";
         }
         return "_v" + param1 + "_";
      }
      
      public static function onNetError(param1:String = null) : void
      {
         var _loc2_:Boolean = javascript("Pixton.isOnline");
         if(Main.isSuper() && param1)
         {
            Utils.alert(param1);
         }
         else
         {
            Utils.alert(L.text(!!_loc2_ ? "editor-err-general" : "editor-err-offline"));
         }
      }
      
      public static function mcContains(param1:Object, param2:Object) : Boolean
      {
         if(param1.parent == null)
         {
            return false;
         }
         if(param1 == param2)
         {
            return true;
         }
         return mcContains(param1.parent,param2);
      }
   }
}
