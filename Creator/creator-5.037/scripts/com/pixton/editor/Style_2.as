package com.pixton.editor
{
   public final class Style
   {
      
      private static var key:String;
      
      private static var info:Object;
       
      
      public function Style()
      {
         super();
      }
      
      public static function init(param1:String) : void
      {
         key = param1;
      }
      
      public static function load(param1:Object) : void
      {
         info = param1;
      }
      
      public static function exists() : Boolean
      {
         return !Utils.empty(key);
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
         return info[param1];
      }
      
      public static function getName() : String
      {
         if(Platform._get("styleExclusive_bool") == 1)
         {
            return _get("name");
         }
         return "Pixton";
      }
   }
}
