package com.pixton.editor
{
   import com.gskinner.geom.ColorMatrix;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class FX
   {
      
      public static const SATURATION:uint = 0;
      
      public static const BLOTCH:uint = 1;
      
      public static const CONVOLUTION:uint = 2;
      
      private static const NO_FX:int = 0;
      
      private static const FACTOR:uint = 2;
      
      public static const GLOW_AMOUNT_MIN:int = 0;
      
      public static const GLOW_AMOUNT_MAX:int = 20;
      
      public static const BLUR_AMOUNT_MIN:int = 0;
      
      public static const BLUR_AMOUNT_MAX:int = 25;
      
      public static const BLUR_ANGLE_MIN:int = -180;
      
      public static const BLUR_ANGLE_MAX:int = 180;
      
      private static var blurFilter:BlurFilter;
      
      private static var glowFilter:GlowFilter;
      
      private static var shadowFilter:DropShadowFilter;
      
      private static var fx:Array = [SATURATION,BLOTCH,CONVOLUTION];
       
      
      private var _filters:Object;
      
      private var reference:MovieClip;
      
      public function FX(param1:MovieClip)
      {
         super();
         this.reference = param1;
         this._filters = {};
      }
      
      public static function glow(param1:MovieClip, param2:Number = 2, param3:uint = 16777215, param4:Number = 4, param5:int = 1, param6:Boolean = false, param7:Boolean = false) : void
      {
         if(param2 > 0)
         {
            if(param2 < 2)
            {
               param2 = 1.4;
            }
            replaceFilter(param1,new GlowFilter(param3,1,param2,param2,param4,param5,param6,param7));
         }
         else
         {
            removeFilter(param1,GlowFilter);
         }
      }
      
      public static function motionBlur(param1:Moveable, param2:Object = null, param3:Object = null) : void
      {
         var _loc4_:Clone = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         if(param1.parent == null)
         {
            return;
         }
         if(param2 == null)
         {
            if(param1.hasClone())
            {
               (_loc4_ = param1.getClone()).blur();
            }
         }
         else
         {
            _loc4_ = param1.getClone();
            _loc5_ = param1.parent.localToGlobal(new Point(param2.x,param2.y));
            _loc6_ = param1.parent.localToGlobal(new Point(param3.x,param3.y));
            if((_loc7_ = Math.min(Point.distance(_loc5_,_loc6_),BLUR_AMOUNT_MAX)) > 1)
            {
               _loc4_.blur(_loc7_ * Utils.scaleFactor,Math.atan2(_loc6_.y - _loc5_.y,_loc6_.x - _loc5_.x));
            }
            else
            {
               _loc4_.blur();
            }
         }
      }
      
      public static function replaceFilter(param1:MovieClip, param2:BitmapFilter, param3:Class = null) : void
      {
         var _loc5_:uint = 0;
         var _loc7_:BitmapFilter = null;
         var _loc4_:Array;
         var _loc6_:uint = (_loc4_ = param1.filters).length;
         var _loc8_:Boolean = false;
         if(param3 == null && param2 != null)
         {
            param3 = Utils.getClass(param2);
         }
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc4_[_loc5_] is param3)
            {
               if(param2 == null)
               {
                  _loc4_.splice(_loc5_,1);
                  break;
               }
               _loc4_[_loc5_] = param2;
               _loc8_ = true;
            }
            _loc5_++;
         }
         if(param2 != null && !_loc8_)
         {
            _loc4_.push(param2);
         }
         param1.filters = _loc4_;
      }
      
      public static function removeFilter(param1:MovieClip, param2:Class) : void
      {
         replaceFilter(param1,null,param2);
      }
      
      public static function blur(param1:MovieClip, param2:Number) : void
      {
         if(param2 > 1)
         {
            replaceFilter(param1,new BlurFilter(param2 * Utils.scaleFactor,param2 * Utils.scaleFactor,BitmapFilterQuality.HIGH));
         }
         else
         {
            removeFilter(param1,BlurFilter);
         }
      }
      
      public static function adjustColor(param1:Array, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:ColorMatrix = null;
         for each(_loc5_ in param1)
         {
            if(param2 == 0 && param3 == 0 && param4 == 0)
            {
               FX.removeFilter(_loc5_,ColorMatrixFilter);
            }
            else
            {
               (_loc6_ = new ColorMatrix()).adjustColor(param2,param3,param4,0);
               FX.replaceFilter(_loc5_,new ColorMatrixFilter(_loc6_));
            }
         }
      }
      
      public function toggle(param1:MovieClip, param2:uint) : void
      {
         if(this.getFilter(param1,param2) == NO_FX)
         {
            this.setFilter(param1,param2,1);
         }
         else
         {
            this.setFilter(param1,param2,NO_FX);
         }
      }
      
      public function register(... rest) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc5_:Bitmap = null;
         var _loc4_:uint = 0;
         while(_loc4_ < rest.length)
         {
            _loc3_ = rest[_loc4_];
            _loc2_ = _loc3_.name;
            this._filters[_loc2_] = {};
            this._filters[_loc2_].target = _loc3_;
            this._filters[_loc2_].value = {};
            _loc5_ = new Bitmap();
            _loc3_.parent.parent.addChild(_loc5_);
            _loc5_.parent.setChildIndex(_loc5_,_loc3_.parent.parent.getChildIndex(_loc3_.parent) - 1);
            this._filters[_loc2_].clone = _loc5_;
            _loc4_++;
         }
      }
      
      private function getInfo(param1:*) : Object
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = param1.name;
         }
         return this._filters[_loc2_];
      }
      
      public function getFilter(param1:MovieClip, param2:uint) : int
      {
         var _loc3_:Object = this.getInfo(param1);
         if(_loc3_.value[param2] == null)
         {
            return NO_FX;
         }
         return _loc3_.value[param2];
      }
      
      public function setFilter(param1:MovieClip, param2:uint, param3:int) : void
      {
         var _loc4_:Object;
         (_loc4_ = this.getInfo(param1)).value[param2] = param3;
         this.update();
      }
      
      public function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:uint = 0;
         var _loc6_:ColorMatrix = null;
         for(_loc4_ in this._filters)
         {
            _loc1_ = [];
            _loc2_ = this.getInfo(_loc4_);
            for each(_loc5_ in fx)
            {
               _loc3_ = _loc2_.value[_loc5_];
               if(_loc3_ == NO_FX)
               {
                  continue;
               }
               switch(_loc5_)
               {
                  case SATURATION:
                     (_loc6_ = new ColorMatrix()).adjustColor(0,0,_loc3_ * 25,0);
                     _loc1_.push(new ColorMatrixFilter(_loc6_));
                     break;
                  case BLOTCH:
                     _loc1_.push(new BlurFilter(_loc3_,_loc3_,3));
                     break;
                  case CONVOLUTION:
                     break;
               }
            }
            Bitmap(_loc2_.clone).filters = _loc1_;
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         for(_loc3_ in this._filters)
         {
            _loc2_ = this.getInfo(_loc3_);
            _loc2_.clone.visible = param1;
            _loc2_.target.visible = !param1;
         }
      }
      
      public function recapture() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._filters)
         {
            this.updateClone(_loc1_);
         }
      }
      
      private function updateClone(param1:String) : void
      {
         var _loc2_:Object = this.getInfo(param1);
         var _loc3_:Bitmap = _loc2_.clone;
         var _loc4_:MovieClip = _loc2_.target as MovieClip;
         var _loc5_:BitmapData = new BitmapData(this.reference.width,this.reference.height,true,0);
         var _loc6_:Matrix = new Matrix();
         var _loc7_:Rectangle = _loc4_.getBounds(this.reference);
         _loc6_.scale(_loc4_.scaleX,_loc4_.scaleY);
         _loc6_.translate(_loc4_.x,_loc4_.y);
         _loc6_.rotate(Utils.d2r(_loc4_.rotation + _loc4_.parent.rotation));
         _loc6_.translate(_loc4_.parent.x,_loc4_.parent.y);
         _loc5_.draw(_loc4_,_loc6_);
         _loc5_.threshold(_loc5_,new Rectangle(0,0,this.reference.width,this.reference.height),new Point(0,0),">",4473924,16777215,16777215,true);
         _loc3_.bitmapData = _loc5_;
      }
      
      public function getActive(param1:MovieClip, param2:uint) : Boolean
      {
         return this.getFilter(param1,param2) != NO_FX;
      }
   }
}
