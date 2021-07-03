package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.system.Capabilities;
   import flash.text.TextField;
   
   public final class Debug
   {
      
      public static var ACTIVE:Boolean = false;
      
      public static var txtDebug:TextField;
       
      
      public function Debug()
      {
         super();
      }
      
      public static function trace(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Error = null;
         if(!ACTIVE)
         {
            return;
         }
         if(param2 && Capabilities.isDebugger)
         {
            _loc3_ = new Error();
            param1 = _loc3_.getStackTrace();
         }
         if(txtDebug != null)
         {
            txtDebug.appendText(" | " + param1);
         }
         Utils.javascript("console.log",param1.replace("/","//"));
      }
      
      public static function log(param1:String) : void
      {
         if(!ACTIVE)
         {
            return;
         }
         Debug.trace("LOG: " + param1);
      }
      
      public static function traceStack(param1:String = null) : void
      {
         if(param1 == null)
         {
            param1 = "Trace stack";
         }
         var _loc2_:Error = new Error();
         Debug.trace(param1 + ": " + _loc2_.getStackTrace());
      }
      
      public static function traceDisplayList(param1:MovieClip, param2:uint = 0) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:uint = param1.numChildren;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            traceDisplayList(param1.getChildAt(_loc4_) as MovieClip,param2 + 1);
            _loc4_++;
         }
      }
   }
}
