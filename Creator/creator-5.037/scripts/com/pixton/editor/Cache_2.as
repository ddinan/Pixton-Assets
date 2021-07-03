package com.pixton.editor
{
   import flash.display.BitmapData;
   
   public final class Cache
   {
      
      private static var cache:Object = {};
       
      
      public function Cache()
      {
         super();
      }
      
      public static function save(param1:String, param2:Number, param3:BitmapData) : void
      {
         if(cache[param1] == null)
         {
            cache[param1] = {};
         }
         cache[param1][param2.toString()] = param3;
      }
      
      public static function load(param1:String, param2:Number) : BitmapData
      {
         if(cache[param1] != null && cache[param1][param2.toString()] != null)
         {
            return cache[param1][param2.toString()];
         }
         return null;
      }
   }
}
