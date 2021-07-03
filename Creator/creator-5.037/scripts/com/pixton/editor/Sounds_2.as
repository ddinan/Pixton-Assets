package com.pixton.editor
{
   import flash.events.NetStatusEvent;
   import flash.media.Sound;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   
   public final class Sounds
   {
      
      private static var nc:NetConnection;
      
      private static var ns:NetStream;
      
      private static var onConnectFunc:Function;
      
      private static var urlToPlay:String;
       
      
      public function Sounds()
      {
         super();
      }
      
      public static function play(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:Sound = null;
         if(Utils.streamingServer.substr(0,4) == "http")
         {
            _loc2_ = new URLRequest(Utils.streamingServer + "sound/" + param1 + ".mp3");
            _loc3_ = new Sound(_loc2_);
            _loc3_.play();
         }
         else
         {
            loadSound("mp3:" + File.LOCAL_BUCKET + "sound/" + param1);
         }
      }
      
      public static function playText(param1:String) : void
      {
      }
      
      private static function loadSound(param1:String) : void
      {
         urlToPlay = param1;
         requireConnection(startStreaming);
      }
      
      private static function requireConnection(param1:Function) : void
      {
         var onConnectFunc:Function = param1;
         Sounds.onConnectFunc = onConnectFunc;
         if(nc != null)
         {
            onConnectFunc();
         }
         else
         {
            nc = new NetConnection();
            NetConnection.prototype.onBWDone = function(param1:*):*
            {
            };
            nc.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
            nc.connect(Utils.streamingServer,false);
         }
      }
      
      private static function startStreaming() : void
      {
         if(ns == null)
         {
            ns = new NetStream(nc);
            NetStream.prototype.onPlayStatus = function(param1:*):*
            {
            };
            ns.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
         }
         ns.play(urlToPlay);
      }
      
      private static function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               onConnectFunc();
               break;
            case "NetConnection.Connect.Closed":
               Utils.alert(L.text("sound-error"));
               nc = null;
         }
      }
   }
}
