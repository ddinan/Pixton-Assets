package com.pixton.editor
{
   import flash.display.MovieClip;
   
   public final class SkinManager
   {
      
      private static var parts:Array;
      
      private static var map:Object;
       
      
      public function SkinManager()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         var _loc2_:Object = null;
         parts = [];
         map = {};
         for each(_loc2_ in param1.skins)
         {
            map[_loc2_.type.toString()] = parts.length;
            parts.push(_loc2_);
         }
      }
      
      public static function getInfo(param1:uint) : Object
      {
         return parts[map[param1.toString()]];
      }
      
      public static function getDefinition(param1:String, param2:String) : Class
      {
         var _loc3_:String = "com.pixton." + param1 + param2;
         if(Utils.hasDefinition(_loc3_))
         {
            return Utils.getDefinition(_loc3_);
         }
         return null;
      }
      
      public static function newInstance(param1:String, param2:String) : MovieClip
      {
         var _loc3_:Class = getDefinition(param1,param2);
         return new _loc3_();
      }
      
      public static function allLocked() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in parts)
         {
            if(_loc1_.locked != true)
            {
               return false;
            }
         }
         return true;
      }
   }
}
