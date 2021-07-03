package com.pixton.editor
{
   import flash.net.SharedObject;
   
   public final class AppState
   {
      
      private static const TIMEOUT:uint = 604800 * 1000;
       
      
      public function AppState()
      {
         super();
      }
      
      private static function isAvailable() : Boolean
      {
         return !Main.isPropPreview() && !Main.isCharCreate() && !Main.isHiResRender();
      }
      
      public static function save(param1:Object) : void
      {
         if(!isAvailable())
         {
            return;
         }
         var _loc2_:SharedObject = getSO();
         _loc2_.data.time = new Date().time;
         var _loc3_:Object = Comic.self.getIDData();
         _loc2_.data.state = param1;
         _loc2_.data.format = Main.format;
         _loc2_.data.key = _loc3_.key;
         _loc2_.data.scene = _loc3_.scene;
         try
         {
            _loc2_.flush(10000);
         }
         catch(myError:Error)
         {
         }
      }
      
      private static function getSO() : SharedObject
      {
         return SharedObject.getLocal("app-state");
      }
      
      public static function exists(param1:String = null) : Boolean
      {
         var _loc2_:SharedObject = getSO();
         if(_loc2_.data.time == null)
         {
            return false;
         }
         var _loc3_:Number = new Date().time;
         if(_loc3_ - _loc2_.data.time > TIMEOUT)
         {
            return false;
         }
         var _loc4_:Object = Comic.self.getIDData();
         return _loc2_.data.key == _loc4_.key && _loc2_.data.format == Main.format && (param1 == null || _loc2_.data.scene == param1);
      }
      
      public static function getPanelKey() : String
      {
         var _loc1_:SharedObject = getSO();
         return _loc1_.data.scene;
      }
      
      public static function restore() : Object
      {
         var _loc1_:SharedObject = getSO();
         return _loc1_.data.state;
      }
      
      public static function clear() : void
      {
         if(!isAvailable())
         {
            return;
         }
         var _loc1_:SharedObject = getSO();
         _loc1_.clear();
      }
   }
}
