package com.pixton.team
{
   import com.pixton.editor.Comic;
   import com.pixton.editor.Confirm;
   import com.pixton.editor.L;
   import com.pixton.editor.Main;
   import com.pixton.editor.Utils;
   import flash.events.NetStatusEvent;
   import flash.events.SyncEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.SharedObject;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public final class Red5
   {
      
      private static const TRY_INTERVAL:uint = 3000;
      
      private static const NULL_VALUE:String = "$null$";
      
      public static var sharingServer:String;
      
      public static var comicKey:String;
      
      private static var netConnection:NetConnection;
      
      private static var sharedObjects:Object = {};
      
      private static var _connected:Boolean = false;
      
      private static var _disconnected:Boolean = false;
      
      private static var errorIssued:Boolean = false;
      
      private static var _firstAttempt:Boolean = true;
      
      private static var lastAttempt:uint = 0;
      
      private static var timeout:int = -1;
      
      private static var _server:String = "rtmp://pixton.com";
       
      
      public function Red5()
      {
         super();
      }
      
      public static function init() : void
      {
         requireConnection();
      }
      
      private static function requireConnection() : void
      {
         var now:uint = 0;
         var elapsed:uint = 0;
         if(Main.useNode)
         {
            if(_connected)
            {
               return;
            }
            Utils.javascript("Pixton.so.init");
         }
         else
         {
            if(netConnection != null)
            {
               return;
            }
            now = getTimer();
            elapsed = now - lastAttempt;
            if(lastAttempt > 0 && elapsed < TRY_INTERVAL)
            {
               timeout = setTimeout(requireConnection,TRY_INTERVAL);
               return;
            }
            lastAttempt = now;
            if(timeout > -1)
            {
               clearTimeout(timeout);
               timeout = -1;
            }
            netConnection = new NetConnection();
            netConnection.objectEncoding = ObjectEncoding.AMF3;
            netConnection.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
            netConnection.client = {
               "onBWDone":function(... rest):void
               {
               },
               "onBWCheck":function(... rest):Number
               {
                  return 0;
               }
            };
            netConnection.connect(sharingServer);
         }
      }
      
      public static function stopTrackingPanel(param1:String, param2:String) : void
      {
         deleteObject(param1,param2,Team.P_PANEL_INDEX);
         deleteObject(param1,param2,Team.P_PANEL_LIST);
         deleteObject(param1,param2,Team.P_PANEL_LOCK);
         deleteObject(param1,param2,Team.P_PANEL_SAVED);
         deleteObject(param1,param2,Team.P_PANEL_STATE);
         deleteObject(param1,param2,Team.P_PANEL_V);
         deleteObject(param1,param2,Team.P_PANEL_XY);
         deleteObject(param1,param2,Team.P_PANEL_SIZES);
      }
      
      public static function putObject(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:Object = null;
         requireConnection();
         if(param4 == null)
         {
            param4 = "value";
         }
         if((_loc6_ = requireObject(param1,param2,param3)) == null)
         {
            return;
         }
         if(Main.useNode)
         {
            setProperty(_loc6_,param4,param5);
            Utils.javascript("Pixton.so.setData",{
               "key":_loc6_.key,
               "property":param4,
               "value":escape(param5)
            });
         }
         else
         {
            SharedObject(_loc6_).setProperty(param4,param5);
         }
      }
      
      private static function setProperty(param1:Object, param2:String, param3:String) : void
      {
         param1.data[param2] = param3;
      }
      
      private static function getObject(param1:String, param2:String, param3:String, param4:String) : String
      {
         requireConnection();
         if(param4 == null)
         {
            param4 = "value";
         }
         var _loc5_:Object;
         if((_loc5_ = requireObject(param1,param2,param3)) == null)
         {
            return null;
         }
         return _loc5_.data[param4];
      }
      
      private static function getName(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:Array = [param1.replace("_","-")];
         if(param2 == null)
         {
            _loc4_.push(NULL_VALUE);
         }
         else
         {
            _loc4_.push(param2);
         }
         if(param3 == null)
         {
            _loc4_.push(NULL_VALUE);
         }
         else
         {
            _loc4_.push(param3);
         }
         return _loc4_.join("_");
      }
      
      private static function extractName(param1:String) : Array
      {
         var _loc2_:Array = param1.split("_");
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] == NULL_VALUE)
            {
               _loc2_[_loc4_] = null;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function requireObject(param1:String, param2:String, param3:String, param4:Boolean = true) : Object
      {
         var _loc6_:SharedObject = null;
         requireConnection();
         if(!_connected)
         {
            return null;
         }
         var _loc5_:String = getName(param1,param2,param3);
         if(sharedObjects[_loc5_] == null && param4)
         {
            if(Main.useNode)
            {
               sharedObjects[_loc5_] = {
                  "key":_loc5_,
                  "data":{}
               };
               Utils.javascript("Pixton.so.load",_loc5_);
            }
            else
            {
               _loc6_ = SharedObject.getRemote(_loc5_,netConnection.uri,true);
               Utils.addListener(_loc6_,SyncEvent.SYNC,onSync);
               _loc6_.connect(netConnection);
               _loc6_.setProperty("s1",param1);
               _loc6_.setProperty("s2",param2);
               _loc6_.setProperty("tv",param3);
               sharedObjects[_loc5_] = _loc6_;
            }
         }
         return sharedObjects[_loc5_];
      }
      
      public static function receivePanelUpdate(param1:String, param2:String, param3:String, param4:String, param5:Boolean = false) : void
      {
         Main.onTeamUpdate(param2,param1,param4,param5);
      }
      
      public static function receivePanelList(param1:String) : void
      {
         Main.onTeamUpdate(Team.P_PANEL_LIST,null,param1);
      }
      
      public static function getData(param1:String, param2:String, param3:String, param4:String) : String
      {
         return getObject(param1,param2,param3,param4);
      }
      
      public static function startSharing() : void
      {
         var _loc1_:* = null;
         requireObject(comicKey,null,Team.P_COMIC);
         requireObject(comicKey,null,Team.P_PANEL_LIST);
         requireObject(comicKey,null,Team.P_PANEL_SIZES);
         Team.onPanelList(Comic.getSceneKeys());
         for(_loc1_ in TeamUser.map)
         {
            requireObject(_loc1_,null,Team.P_CHARACTER_LIST);
            requireObject(_loc1_,null,Team.P_PROPSET_LIST);
            requireObject(_loc1_,null,Team.P_PHOTO_LIST);
         }
      }
      
      private static function resetConnection() : void
      {
         if(netConnection != null)
         {
            netConnection.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
            netConnection = null;
         }
      }
      
      private static function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Closed":
               if(_firstAttempt)
               {
                  onConnectionError();
               }
               resetConnection();
               requireConnection();
               break;
            case "NetConnection.Connect.Failed":
            case "NetConnection.Connect.InvalidApp":
               if(_disconnected)
               {
               }
               onConnectionError(Utils.toString(param1.info));
               resetConnection();
               _connected = false;
               _disconnected = true;
               sharedObjects = {};
               break;
            case "NetConnection.Connect.Success":
               if(errorIssued)
               {
                  errorIssued = false;
                  Utils.notifyAdmin("Team Comics working again: " + Utils.toString(param1.info),true);
               }
               onConnected();
         }
      }
      
      public static function onConnected(param1:String = null) : void
      {
         if(param1 != null)
         {
            Red5._server = param1;
         }
         _connected = true;
         _disconnected = false;
         _firstAttempt = false;
         Team.startSharing();
      }
      
      public static function onConnectionError(param1:String = "") : void
      {
         if(!errorIssued)
         {
            Confirm.alert(L.text("error-team-conn",Red5._server),false);
            errorIssued = true;
            Utils.notifyAdmin("Team Comics connection error: " + param1,true);
         }
      }
      
      private static function deleteObject(param1:String, param2:String, param3:String, param4:String = null) : void
      {
         var _loc6_:String = null;
         if(param4 == null)
         {
            param4 = "value";
         }
         var _loc5_:Object;
         if((_loc5_ = requireObject(param1,param2,param3,false)) != null)
         {
            _loc6_ = getName(param1,param2,param3);
            if(Main.useNode)
            {
               Utils.javascript("Pixton.so.clear",_loc6_);
            }
            else
            {
               Utils.removeListener(_loc5_,SyncEvent.SYNC,onSync);
               _loc5_.clear();
               _loc5_.close();
            }
            sharedObjects[_loc6_] = null;
         }
      }
      
      private static function onSync(param1:SyncEvent) : *
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc2_:* = SharedObject(param1.target);
         var _loc3_:String = _loc2_.data.s1;
         var _loc4_:String = _loc2_.data.s2;
         var _loc5_:String = _loc2_.data.tv;
         for each(_loc8_ in param1.changeList)
         {
            if(_loc8_.code != "change")
            {
               continue;
            }
            _loc6_ = _loc8_.name;
            _loc7_ = _loc2_.data[_loc6_];
            switch(_loc5_)
            {
               case Team.P_CHARACTER:
               case Team.P_PROPSET:
               case Team.P_PHOTO:
                  Main.onTeamUpdate(_loc5_,_loc3_,_loc7_);
                  break;
               case Team.P_CHARACTER_LIST:
               case Team.P_PROPSET_LIST:
               case Team.P_PHOTO_LIST:
               case Team.P_PANEL_LIST:
               case Team.P_PANEL_SIZES:
                  Main.onTeamUpdate(_loc5_,_loc6_,_loc7_);
                  break;
               default:
                  receivePanelUpdate(_loc4_,_loc5_,_loc6_,_loc7_);
                  break;
            }
         }
      }
      
      public static function onSyncJS(param1:Object) : void
      {
         var _loc10_:* = null;
         param1.value = unescape(param1.value);
         var _loc2_:String = param1.key;
         if(param1.properties != null)
         {
            for(_loc10_ in param1.properties)
            {
               onSyncJS({
                  "key":_loc2_,
                  "property":_loc10_,
                  "value":param1.properties[_loc10_],
                  "force":param1.force
               });
            }
            return;
         }
         var _loc3_:String = param1.property;
         var _loc4_:String = param1.value;
         var _loc5_:Array;
         var _loc6_:String = (_loc5_ = extractName(_loc2_))[0];
         var _loc7_:String = _loc5_[1];
         var _loc8_:String = _loc5_[2];
         var _loc9_:Object = requireObject(_loc6_,_loc7_,_loc8_);
         setProperty(_loc9_,_loc3_,_loc4_);
         switch(_loc8_)
         {
            case Team.P_CHARACTER:
            case Team.P_PROPSET:
            case Team.P_PHOTO:
               Main.onTeamUpdate(_loc8_,_loc6_,_loc4_,param1.force);
               break;
            case Team.P_CHARACTER_LIST:
            case Team.P_PROPSET_LIST:
            case Team.P_PHOTO_LIST:
            case Team.P_PANEL_LIST:
            case Team.P_PANEL_SIZES:
               Main.onTeamUpdate(_loc8_,_loc3_,_loc4_,param1.force);
               break;
            default:
               receivePanelUpdate(_loc7_,_loc8_,_loc3_,_loc4_,param1.force);
         }
      }
   }
}
