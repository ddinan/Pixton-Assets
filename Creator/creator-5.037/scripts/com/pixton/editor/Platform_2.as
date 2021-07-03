package com.pixton.editor
{
   public final class Platform
   {
      
      private static var key:String;
      
      private static var info:Object;
       
      
      public function Platform()
      {
         super();
      }
      
      public static function init(param1:String) : void
      {
         key = param1;
      }
      
      public static function exists() : Boolean
      {
         return !Utils.empty(key);
      }
      
      public static function load(param1:Object) : void
      {
         info = param1;
         if(param1 != null)
         {
            init(param1.key_str);
         }
      }
      
      public static function _get(param1:String = null) : *
      {
         if(param1 == "key")
         {
            return key;
         }
         if(info == null || info[param1] == null)
         {
            return null;
         }
         if(param1 == "anon")
         {
            return info[param1] == 1;
         }
         return info[param1];
      }
   }
}
