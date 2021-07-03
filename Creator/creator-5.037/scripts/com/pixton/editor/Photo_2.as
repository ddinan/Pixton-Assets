package com.pixton.editor
{
   import com.pixton.preloader.Status;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Photo extends Prop
   {
       
      
      var cacheKey:String = "";
      
      var fileName:String;
      
      var source:String;
      
      private var tween:PixtonTween;
      
      private var bitmap:Bitmap;
      
      private var imageContainer:MovieClip;
      
      public function Photo()
      {
         super();
         Editor.onNewPhoto();
      }
      
      function onLoadImage(param1:Event = null) : void
      {
         var _loc2_:BitmapData = null;
         if(param1 != null)
         {
            _loc2_ = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
            this.placeImage(_loc2_);
            Cache.save(this.cacheKey,id,_loc2_);
            Status.reset();
            if(Main.isAutoRender())
            {
               this.bitmap.alpha = 1;
            }
            else
            {
               this.bitmap.alpha = 0;
               this.tween = new PixtonTween(this.bitmap,"alpha",1,0,PickerItem.FADE_DURATION);
            }
         }
         Editor.onPhotoLoaded();
      }
      
      function placeImage(param1:BitmapData) : Bitmap
      {
         this.bitmap = new Bitmap(param1);
         this.bitmap.smoothing = true;
         this.requireContainer();
         this.imageContainer.addChild(this.bitmap);
         this.imageContainer.graphics.clear();
         if(this is WebPhoto)
         {
            this.imageContainer.x = -Math.round(this.bitmap.width * 0.5);
            this.imageContainer.y = -Math.round(this.bitmap.height * 0.5);
         }
         return this.bitmap;
      }
      
      function drawPlaceholderBox(param1:Number, param2:Number) : void
      {
         this.requireContainer();
         this.imageContainer.x = -Math.round(param1 * 0.5);
         this.imageContainer.y = -Math.round(param2 * 0.5);
         Lib.drawPlaceHolder(this.imageContainer,param1,param2,true);
      }
      
      private function requireContainer() : void
      {
         if(this.imageContainer == null)
         {
            this.imageContainer = new MovieClip();
            vector.addChild(this.imageContainer);
         }
      }
      
      override function canSilhouette() : Boolean
      {
         return false;
      }
      
      override function isAlphable() : Boolean
      {
         return true;
      }
      
      override function hasFill(param1:uint) : Boolean
      {
         return param1 == 0;
      }
      
      override function setColor(param1:int, param2:*, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         this.imageContainer.alpha = getAlpha() / 100;
         if(param2 == 0)
         {
            return;
         }
         if(param1 == -1)
         {
            this.setColor(0,param2[0],param3,param4);
            return;
         }
         if(!param3)
         {
            _colorID[param1] = param2;
         }
         if(param2 is Array)
         {
            _loc5_ = param2;
         }
         else
         {
            _loc5_ = [(_loc6_ = Palette.getColor(param2))[0],_loc6_[1],_loc6_[2]];
         }
         if(param2 == Palette.TRANSPARENT_ID)
         {
            Palette.setTint(this);
         }
         else
         {
            Palette.setTint(this,_loc5_);
         }
      }
   }
}
