package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public final class Ghost extends MovieClip
   {
       
      
      var topLeft:Object;
      
      public function Ghost(param1:Bitmap, param2:Number, param3:Number, param4:Number)
      {
         super();
         addChild(param1);
         param1.x = -param2;
         param1.y = -param3;
         mouseEnabled = false;
         mouseChildren = false;
         this.alpha = param4;
         this.topLeft = {
            "x":param1.x,
            "y":param1.y
         };
      }
   }
}
