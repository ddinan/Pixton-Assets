package com.pixton.editor
{
   public final class EditorConfig
   {
      
      private static var configData:Object;
      
      private static var hasTrue:Boolean = false;
      
      private static var hasFalse:Boolean = false;
       
      
      public function EditorConfig()
      {
         super();
      }
      
      static function init(param1:Object) : void
      {
         var _loc2_:* = null;
         if(param1.config != null)
         {
            configData = param1.config;
            for(_loc2_ in configData)
            {
               if(configData[_loc2_] === false)
               {
                  hasFalse = true;
                  if(hasTrue)
                  {
                     throw new Error("Editor config mode is true-only; found false.");
                  }
               }
               if(configData[_loc2_] === true)
               {
                  hasTrue = true;
                  if(hasFalse)
                  {
                     throw new Error("Editor config mode is false-only; found true.");
                  }
               }
            }
         }
      }
      
      static function has(param1:String) : Boolean
      {
         return configData == null || hasFalse && configData[param1] == null || hasTrue && configData[param1] != null;
      }
   }
}
