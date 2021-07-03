package com.pixton.editor
{
   public final class L
   {
      
      public static const ENGLISH:uint = 1;
      
      public static var indexID:uint = 0;
      
      public static var id:uint = 0;
      
      public static var multiLangID:uint;
      
      public static var showKeypad:Boolean = true;
      
      private static var textMap:Object;
       
      
      public function L()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         textMap = param1;
      }
      
      public static function isReady() : Boolean
      {
         return textMap != null;
      }
      
      public static function isEnglish() : Boolean
      {
         return indexID == ENGLISH;
      }
      
      public static function text(param1:String, ... rest) : String
      {
         var i:uint = 0;
         var key:String = param1;
         var args:Array = rest;
         if(textMap == null || textMap[key] == null)
         {
            return key.replace("-"," ");
         }
         if(args != null && args.length > 0)
         {
            i = 0;
            return textMap[key].replace(/\{[^\}]*\}/g,function():*
            {
               return args[i++];
            }).replace("\r\n","\n");
         }
         return textMap[key].replace("\r\n","\n");
      }
   }
}
