package com.pixton.editor
{
   import com.pixton.character.BodyPart;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Camera;
   import flash.media.Video;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public final class VideoRecorder
   {
      
      private static const ASPECT:Number = 0.75;
      
      private static const ZOOM:Number = 1.5;
      
      private static const INTERVAL_SAMPLE:Number = 1000;
      
      public static var isAllowed:Boolean = false;
      
      private static var videoContainer:MovieClip;
      
      private static var video:Video;
      
      private static var photo:MovieClip;
      
      private static var target:BodyPart;
      
      private static var targetCharacter:Character;
      
      private static var targetColor:Array;
      
      private static var bmd:BitmapData;
      
      private static var interval:uint = 0;
      
      private static var avgColor:Array;
      
      private static var charColor:Array;
      
      private static var ct:ColorTransform;
      
      private static var cam:Camera;
       
      
      public function VideoRecorder()
      {
         super();
      }
      
      public static function hide() : void
      {
         if(videoContainer == null || videoContainer.parent == null)
         {
            return;
         }
         clearInterval(interval);
         interval = 0;
         video.attachCamera(null);
         video.mask = null;
         photo.parent.removeChild(videoContainer);
      }
      
      public static function show(param1:Character) : void
      {
         if(!isAllowed)
         {
            return;
         }
         var _loc2_:String = "head";
         targetCharacter = param1;
         target = param1.bodyParts.getPart(_loc2_);
         photo = target.getPhoto();
         if(videoContainer == null)
         {
            videoContainer = new MovieClip();
         }
         if(cam == null)
         {
            cam = Camera.getCamera();
            cam.setQuality(0,100);
         }
         var _loc3_:Rectangle = photo.getBounds(photo.parent);
         var _loc4_:Number = _loc3_.width;
         var _loc5_:Number = _loc3_.height;
         if(_loc4_ * ASPECT < _loc5_)
         {
            _loc4_ = _loc5_ / ASPECT;
         }
         else
         {
            _loc5_ = _loc4_ * ASPECT;
         }
         if(video != null)
         {
            videoContainer.removeChild(video);
         }
         video = new Video(_loc4_ * ZOOM,_loc5_ * ZOOM);
         videoContainer.addChild(video);
         video.attachCamera(cam);
         video.scaleX = -1 * targetCharacter.flipX;
         videoContainer.x = _loc3_.x + _loc3_.width * 0.5 + _loc4_ * 0.5 + _loc4_ * (ZOOM - 1) * 0.5;
         videoContainer.y = _loc3_.y + 0 - _loc5_ * (ZOOM - 1) * 0.5;
         photo.parent.addChildAt(videoContainer,photo.parent.getChildIndex(photo));
         video.cacheAsBitmap = true;
         photo.cacheAsBitmap = true;
         video.mask = photo;
         if(interval == 0)
         {
            interval = setInterval(updateColor,INTERVAL_SAMPLE);
         }
         targetColor = Palette.getColor(targetCharacter.bodyParts.getColor(Globals.SKIN_COLOR));
      }
      
      private static function updateColor() : void
      {
         var _loc5_:Point = null;
         if(bmd != null)
         {
            bmd.dispose();
         }
         var _loc1_:Array = [];
         _loc1_[0] = target.getAnchor("c0");
         _loc1_[1] = target.getAnchor("c1");
         _loc1_[2] = target.getAnchor("c2");
         var _loc2_:Array = [];
         _loc2_[0] = Utils.getLocation(_loc1_[0],videoContainer);
         _loc2_[1] = Utils.getLocation(_loc1_[1],videoContainer);
         _loc2_[2] = Utils.getLocation(_loc1_[2],videoContainer);
         var _loc3_:Array = [];
         bmd = new BitmapData(1,1,false);
         var _loc4_:Matrix = new Matrix();
         video.mask = null;
         for each(_loc5_ in _loc2_)
         {
            _loc4_.identity();
            _loc4_.translate(_loc5_.x,-_loc5_.y);
            _loc4_.scale(-1,1);
            bmd.draw(video,_loc4_);
            _loc3_.push(Palette.hexToRGB(bmd.getPixel(0,0)));
         }
         video.mask = photo;
         avgColor = Palette.averageColors(_loc3_[0],_loc3_[1],_loc3_[2]);
         charColor = Palette.getColor(targetCharacter.bodyParts.getColor(Globals.SKIN_COLOR));
         ct = new ColorTransform(charColor[Palette.R] / avgColor[Palette.R],charColor[Palette.G] / avgColor[Palette.G],charColor[Palette.B] / avgColor[Palette.B]);
         videoContainer.transform.colorTransform = ct;
      }
   }
}
