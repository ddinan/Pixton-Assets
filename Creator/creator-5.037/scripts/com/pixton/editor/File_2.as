package com.pixton.editor
{
   public final class File
   {
      
      public static const BUCKET_NONE:uint = 0;
      
      public static const BUCKET_STATIC:uint = 1;
      
      public static const BUCKET_DYNAMIC:uint = 2;
      
      public static const BUCKET_ASSET:uint = 3;
      
      public static const BUCKET_STREAMING:uint = 4;
      
      public static var LOCAL_BUCKET:String = "";
       
      
      public function File()
      {
         super();
      }
      
      public static function v(param1:uint) : String
      {
         if(param1 == 0)
         {
            return "";
         }
         return "_v" + param1 + "_";
      }
   }
}
