package com.pixton.editor
{
   import flash.system.Capabilities;
   
   public final class OS
   {
      
      private static var name:String;
      
      private static var _isLinux:Boolean = false;
      
      private static var _isWindows:Boolean = false;
       
      
      public function OS()
      {
         super();
      }
      
      public static function init() : void
      {
         name = Capabilities.os;
         _isLinux = name.substr(0,5) == "Linux";
         _isWindows = name.substr(0,3) == "Win";
      }
      
      public static function canInvalidate() : Boolean
      {
         return !_isLinux;
      }
      
      public static function canTypeAccents() : Boolean
      {
         return _isWindows;
      }
   }
}
