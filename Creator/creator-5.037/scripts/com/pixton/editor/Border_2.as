package com.pixton.editor
{
   import com.pixton.team.TeamRole;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public final class Border extends MovieClip
   {
      
      public static const NUM_SHAPES:uint = 2;
      
      public static const SIZE_MIN:Number = 0;
      
      public static const SIZE_MAX:Number = 20;
      
      public static const SQUARE:uint = 0;
      
      public static const ROUNDED:uint = 1;
      
      public static const TOP:uint = 0;
      
      public static const RIGHT:uint = 1;
      
      public static const BOTTOM:uint = 2;
      
      public static const LEFT:uint = 3;
      
      public static var cornerOffsets:Array = [{
         "x":0,
         "y":0
      },{
         "x":0,
         "y":0
      },{
         "x":0,
         "y":0
      },{
         "x":0,
         "y":0
      }];
      
      private static var _allowed:Boolean = false;
      
      public static var locked:Boolean = false;
       
      
      private var comicCorners:Array;
      
      private var _shape:uint;
      
      private var _thickness:uint;
      
      private var _colorID:uint;
      
      private var _saturation:int;
      
      private var _brightness:int;
      
      private var _contrast:int;
      
      private var A:Object;
      
      private var B:Object;
      
      private var C:Object;
      
      private var D:Object;
      
      public function Border()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.shape = SQUARE;
         this.thickness = 1;
         this.setColor(Palette.BLACK_ID);
         this.setSaturation(0);
         this.setBrightness(0);
         this.setContrast(0);
      }
      
      static function canEdit() : Boolean
      {
         return _allowed && TeamRole.can(TeamRole.PANELS) && !locked;
      }
      
      static function canMove() : Boolean
      {
         return canEdit();
      }
      
      static function canView() : Boolean
      {
         return _allowed;
      }
      
      static function setAllowed(param1:Boolean) : void
      {
         _allowed = param1;
      }
      
      public static function setCornerOffset(param1:uint, param2:Number, param3:Number) : void
      {
         cornerOffsets[param1] = {
            "x":Math.round(param2),
            "y":Math.round(param3)
         };
      }
      
      public function set shape(param1:uint) : void
      {
         this._shape = param1;
         this.onChange();
      }
      
      public function get shape() : uint
      {
         return this._shape;
      }
      
      public function set thickness(param1:uint) : void
      {
         this._thickness = param1;
         this.onChange();
      }
      
      public function get thickness() : uint
      {
         return !!canView() ? uint(this._thickness) : uint(0);
      }
      
      public function setColor(param1:*) : void
      {
         this._colorID = param1;
         this.onChange();
      }
      
      public function getColor() : uint
      {
         return this._colorID;
      }
      
      public function isDefaultColor() : Boolean
      {
         return this.getColor() == Palette.BLACK_ID;
      }
      
      public function setSaturation(param1:int, param2:Boolean = true) : void
      {
         param1 = Utils.limit(param1,-100,100);
         this._saturation = param1;
         if(param2)
         {
            this.onChange();
         }
      }
      
      public function getSaturation() : int
      {
         return this._saturation;
      }
      
      public function setBrightness(param1:int, param2:Boolean = true) : void
      {
         this._brightness = param1;
         if(param2)
         {
            this.onChange();
         }
      }
      
      public function getBrightness() : int
      {
         return this._brightness;
      }
      
      public function setContrast(param1:int, param2:Boolean = true) : void
      {
         this._contrast = param1;
         if(param2)
         {
            this.onChange();
         }
      }
      
      public function getContrast() : int
      {
         return this._contrast;
      }
      
      public function getColorHex() : uint
      {
         return Palette.RGBtoHex(Palette.getColor(this.getColor()));
      }
      
      private function onChange() : void
      {
         dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,this));
      }
      
      function draw(param1:MovieClip, param2:Number, param3:Number, param4:MovieClip = null) : void
      {
         var _loc6_:uint = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:* = undefined;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:* = undefined;
         var _loc40_:Array = null;
         var _loc41_:Array = null;
         var _loc5_:Boolean = true;
         if(param1 == null)
         {
            param1 = this;
            _loc5_ = false;
            _loc6_ = this.getColorHex();
         }
         var _loc7_:Graphics;
         (_loc7_ = param1.graphics).clear();
         var _loc8_:Number = Math.floor(this.thickness * 0.5);
         var _loc10_:Number = !!(_loc9_ = param1.name == "selectorMask") ? Number(0) : Number(cornerOffsets[0].x);
         var _loc11_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[0].y);
         var _loc12_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[1].x);
         var _loc13_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[1].y);
         var _loc14_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[2].x);
         var _loc15_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[2].y);
         var _loc16_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[3].x);
         var _loc17_:Number = !!_loc9_ ? Number(0) : Number(cornerOffsets[3].y);
         var _loc18_:Number = this.thickness % 2 == 0 || param1 != this ? Number(0) : Number(1);
         this.A = {
            "x":_loc10_ - _loc8_ + param2 - _loc18_,
            "y":_loc11_ + _loc8_
         };
         this.B = {
            "x":_loc12_ - _loc8_ + param2 - _loc18_,
            "y":_loc13_ - _loc8_ + param3 - _loc18_
         };
         this.C = {
            "x":_loc14_ + _loc8_,
            "y":_loc15_ - _loc8_ + param3 - _loc18_
         };
         this.D = {
            "x":_loc16_ + _loc8_,
            "y":_loc17_ + _loc8_
         };
         _loc7_.beginFill(16711680,0);
         if(!_loc5_ && this.thickness > 0)
         {
            _loc7_.lineStyle(this.thickness,_loc6_,1,true,"normal","square","miter");
         }
         if(this.shape == SQUARE || _loc9_)
         {
            _loc7_.moveTo(this.A.x,this.A.y);
            _loc7_.lineTo(this.B.x,this.B.y);
            _loc7_.lineTo(this.C.x,this.C.y);
            _loc7_.lineTo(this.D.x,this.D.y);
            _loc7_.lineTo(this.A.x,this.A.y);
         }
         else if(this.shape == ROUNDED)
         {
            _loc19_ = (this.B.x + this.A.x) * 0.5;
            _loc20_ = (this.B.y + this.A.y) * 0.5;
            _loc21_ = (this.C.x + this.B.x) * 0.5;
            _loc22_ = (this.C.y + this.B.y) * 0.5;
            _loc23_ = (this.D.x + this.C.x) * 0.5;
            _loc24_ = (this.D.y + this.C.y) * 0.5;
            _loc25_ = (this.A.x + this.D.x) * 0.5;
            _loc26_ = (this.A.y + this.D.y) * 0.5;
            _loc27_ = Math.PI / 2;
            _loc28_ = param2 * 0.5;
            _loc29_ = param3 * 0.5;
            _loc34_ = 0;
            _loc7_.moveTo(_loc19_,_loc20_);
            _loc39_ = 0;
            while(_loc39_ < 4)
            {
               _loc34_ += _loc27_;
               switch(_loc39_)
               {
                  case 0:
                     _loc37_ = _loc21_;
                     _loc38_ = _loc22_;
                     _loc30_ = Math.abs(_loc19_ - _loc28_);
                     _loc31_ = Math.abs(_loc22_ - _loc29_);
                     break;
                  case 1:
                     _loc37_ = _loc23_;
                     _loc38_ = _loc24_;
                     _loc30_ = Math.abs(_loc23_ - _loc28_);
                     _loc31_ = Math.abs(_loc22_ - _loc29_);
                     break;
                  case 2:
                     _loc37_ = _loc25_;
                     _loc38_ = _loc26_;
                     _loc30_ = Math.abs(_loc23_ - _loc28_);
                     _loc31_ = Math.abs(_loc26_ - _loc29_);
                     break;
                  case 3:
                     _loc37_ = _loc19_;
                     _loc38_ = _loc20_;
                     _loc30_ = Math.abs(_loc19_ - _loc28_);
                     _loc31_ = Math.abs(_loc26_ - _loc29_);
                     break;
               }
               _loc32_ = _loc30_ / Math.cos(_loc27_ / 2);
               _loc33_ = _loc31_ / Math.cos(_loc27_ / 2);
               _loc35_ = _loc28_ + Math.cos(_loc34_ - _loc27_ / 2) * _loc32_;
               _loc36_ = _loc29_ + Math.sin(_loc34_ - _loc27_ / 2) * _loc33_;
               _loc7_.curveTo(_loc35_,_loc36_,_loc37_,_loc38_);
               _loc39_++;
            }
         }
         _loc7_.endFill();
         if(param4 != null && this.comicCorners != null)
         {
            _loc7_.lineStyle(1,Palette.RGBtoHex(Palette.colorLine),0.5,true,"normal","square","miter");
            switch(param4.name)
            {
               case "cornerNE":
                  _loc41_ = [[this.D,this.A],[this.A,this.B]];
                  break;
               case "cornerSE":
                  _loc41_ = [[this.A,this.B],[this.B,this.C]];
                  break;
               case "cornerSW":
                  _loc41_ = [[this.B,this.C],[this.C,this.D]];
                  break;
               case "cornerNW":
                  _loc41_ = [[this.C,this.D],[this.D,this.A]];
            }
            if((_loc40_ = this.getIntersections(_loc41_[0][0],_loc41_[0][1],true)) != null)
            {
               _loc7_.moveTo(_loc40_[0].x,_loc40_[0].y);
               _loc7_.lineTo(_loc40_[1].x,_loc40_[1].y);
            }
            if((_loc40_ = this.getIntersections(_loc41_[1][0],_loc41_[1][1])) != null)
            {
               _loc7_.moveTo(_loc40_[0].x,_loc40_[0].y);
               _loc7_.lineTo(_loc40_[1].x,_loc40_[1].y);
            }
         }
      }
      
      function getBorderData(param1:MovieClip) : Object
      {
         var _loc2_:Point = param1.globalToLocal(this.localToGlobal(new Point(this.A.x,this.A.y)));
         var _loc3_:Point = param1.globalToLocal(this.localToGlobal(new Point(this.B.x,this.B.y)));
         var _loc4_:Point = param1.globalToLocal(this.localToGlobal(new Point(this.C.x,this.C.y)));
         var _loc5_:Point = param1.globalToLocal(this.localToGlobal(new Point(this.D.x,this.D.y)));
         return {
            "Ax":_loc2_.x,
            "Ay":_loc2_.y,
            "Bx":_loc3_.x,
            "By":_loc3_.y,
            "Cx":_loc4_.x,
            "Cy":_loc4_.y,
            "Dx":_loc5_.x,
            "Dy":_loc5_.y
         };
      }
      
      function setComicCorners(param1:Object) : void
      {
         var _loc2_:Point = this.globalToLocal(Comic.self.localToGlobal(new Point(Comic.maxWidth,0)));
         var _loc3_:Point = this.globalToLocal(Comic.self.localToGlobal(new Point(Comic.maxWidth,param1.maxY)));
         var _loc4_:Point = this.globalToLocal(Comic.self.localToGlobal(new Point(0,param1.maxY)));
         var _loc5_:Point = this.globalToLocal(Comic.self.localToGlobal(new Point(0,0)));
         this.comicCorners = [_loc2_,_loc3_,_loc4_,_loc5_];
      }
      
      public function hasSquareCorners() : Boolean
      {
         return !this.comicCorners || this.A.x == this.B.x && this.C.x == this.D.x && this.A.y == this.D.y && this.B.y == this.C.y;
      }
      
      private function getIntersections(param1:Object, param2:Object, param3:Boolean = false) : Array
      {
         var _loc4_:uint = 0;
         var _loc7_:Object = null;
         if(this.comicCorners == null)
         {
            return null;
         }
         var _loc5_:uint = this.comicCorners.length;
         var _loc6_:Array = !!param3 ? [0,2,1,3] : [1,3,0,2];
         var _loc8_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc7_ = Utils.getIntersection(param1,param2,this.comicCorners[_loc6_[_loc4_]],this.comicCorners[Utils.wrap(_loc6_[_loc4_] + 1,_loc5_)])) != null)
            {
               _loc8_.push(_loc7_);
            }
            _loc4_++;
         }
         if(_loc8_.length > 1)
         {
            return _loc8_;
         }
         return null;
      }
      
      private function cornerOffsetsExist() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            if(cornerOffsets[_loc1_].x != 0 || cornerOffsets[_loc1_].y != 0)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function getData() : String
      {
         return Utils.encode({
            "t":this.thickness,
            "s":this.shape,
            "c":cornerOffsets,
            "k":this.getColor(),
            "sa":this.getSaturation(),
            "br":this.getBrightness(),
            "co":this.getContrast()
         });
      }
      
      public function setData(param1:String) : void
      {
         var _loc2_:Object = null;
         if(param1 != null)
         {
            _loc2_ = Utils.decode(param1);
            this.shape = _loc2_.s;
            this.thickness = _loc2_.t;
            cornerOffsets = _loc2_.c;
            this.setColor(_loc2_.k);
            if(_loc2_.sa != null)
            {
               this.setSaturation(_loc2_.sa,false);
               this.setBrightness(_loc2_.br,false);
               this.setContrast(_loc2_.co,false);
            }
            else
            {
               this.setSaturation(0,false);
               this.setBrightness(0,false);
               this.setContrast(0,false);
            }
         }
         else
         {
            this.setSaturation(0,false);
            this.setBrightness(0,false);
            this.setContrast(0,false);
         }
      }
      
      function updateFilters(param1:Array) : void
      {
         FX.adjustColor(param1,this.getBrightness(),this.getContrast(),this.getSaturation());
      }
   }
}
