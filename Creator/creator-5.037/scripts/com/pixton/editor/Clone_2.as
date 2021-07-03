package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class Clone
   {
       
      
      private var bmd:BitmapData;
      
      private var matrix:Matrix;
      
      private var target:DisplayObject;
      
      private var container:MovieClip;
      
      private var innerRect:Rectangle;
      
      private var r:Rectangle;
      
      private var bm:Bitmap;
      
      private var p:Point;
      
      private var dS:Number;
      
      public function Clone(param1:DisplayObject)
      {
         super();
         this.target = param1;
         this.container = Editor.getContainer(param1);
         this.bm = new Bitmap();
         this.matrix = new Matrix();
      }
      
      public function blur(param1:Number = 0, param2:Number = 0) : void
      {
         this.target.visible = param1 == 0;
         if(this.target.visible)
         {
            if(this.bm.parent != null)
            {
               this.container.removeChild(this.bm);
            }
         }
         else
         {
            this.target.visible = true;
            if(this.bm.parent == null)
            {
               this.container.addChild(this.bm);
            }
         }
      }
   }
}
