package com.pixton.editor
{
   public final class Training
   {
      
      private static var _isActive:Boolean = false;
       
      
      public function Training()
      {
         super();
      }
      
      public static function setActive(param1:Boolean) : void
      {
         _isActive = param1;
      }
      
      public static function isActive() : Boolean
      {
         return _isActive;
      }
   }
}
