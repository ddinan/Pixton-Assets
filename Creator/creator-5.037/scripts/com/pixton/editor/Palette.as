package com.pixton.editor
{
   import com.gskinner.geom.ColorMatrix;
   import com.pixton.preloader.Status;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   
   public final class Palette
   {
      
      public static const WHITE:Array = [255,255,255];
      
      public static const GRAY:Array = [128,128,128];
      
      public static const BLACK:Array = [0,0,0];
      
      public static var RED:Array = [244,67,54];
      
      public static var RED_OVER:Array = [244,67,54];
      
      public static var GREEN:Array = [100,221,23];
      
      public static var GREEN_OVER:Array = [100,221,23];
      
      public static const SKIN:uint = 0;
      
      public static const HAIR:uint = 1;
      
      public static const OTHER:uint = 2;
      
      public static const SILHOUETTE_COLOR:int = -1;
      
      public static const RANGE_SKIN:uint = 0;
      
      public static const BLACK_ID:uint = 24;
      
      public static const WHITE_ID:uint = 151;
      
      public static const GRAY_ID:uint = 147;
      
      public static const OFF_WHITE_ID:uint = 152;
      
      public static const TRANSPARENT_ID:uint = 193;
      
      private static const FACTOR_LIGHTEN:Number = 1.5;
      
      private static const FACTOR_DARKEN:Number = 0.7;
      
      static const NUM_GRADIENTS:Number = 5;
      
      static const GRADIENT_NONE:uint = 0;
      
      static const GRADIENT_LINEAR_LIGHT:uint = 1;
      
      static const GRADIENT_LINEAR_DARK:uint = 2;
      
      static const GRADIENT_RADIAL_LIGHT:uint = 3;
      
      static const GRADIENT_RADIAL_DARK:uint = 4;
      
      static const GRADIENT_MAX:uint = 4;
      
      public static const R:uint = 0;
      
      public static const G:uint = 1;
      
      public static const B:uint = 2;
      
      public static const A:uint = 3;
      
      public static var colorByID:Object;
      
      public static var colorByType:Object;
      
      public static var colors:Array;
      
      public static var solidColors:Array;
      
      public static var colorLink:Array;
      
      public static var colorHot:Array;
      
      public static var colorBkgd:Array;
      
      public static var colorLine:Array;
      
      public static var colorPage:Array;
      
      public static var colorHeader:Array;
      
      public static var colorText3:Array;
      
      public static var colorBkgdHex:uint;
      
      public static var colorText:uint;
      
      public static var colorText4:uint;
      
      public static var colorLinkStr:uint;
      
      public static var colorHeaderText:uint;
      
      private static var cacheLighten:Object = {};
       
      
      public function Palette()
      {
         super();
      }
      
      public static function init(param1:Array) : void
      {
         var _loc2_:* = undefined;
         colorByID = {};
         colorByType = {};
         colors = [];
         solidColors = [];
         for each(_loc2_ in param1)
         {
            if(colorByType[_loc2_.t] == null)
            {
               colorByType[_loc2_.t] = [];
            }
            colorByID[_loc2_.id] = _loc2_.v.split(",");
            colorByID[_loc2_.id][R] = uint(colorByID[_loc2_.id][R]);
            colorByID[_loc2_.id][G] = uint(colorByID[_loc2_.id][G]);
            colorByID[_loc2_.id][B] = uint(colorByID[_loc2_.id][B]);
            colorByType[_loc2_.t].push(_loc2_.id);
            colors.push(_loc2_.id);
            if(_loc2_.id != TRANSPARENT_ID)
            {
               solidColors.push(_loc2_.id);
            }
         }
      }
      
      public static function load(param1:Object) : void
      {
         colorBkgdHex = stringToHex(param1.c_bkgd);
         colorHot = hexToRGB(stringToHex(param1.c_hot));
         colorLink = hexToRGB(stringToHex(param1.c_link));
         colorBkgd = hexToRGB(colorBkgdHex);
         colorLine = hexToRGB(stringToHex(param1.c_line));
         colorPage = hexToRGB(stringToHex(param1.c_page));
         colorHeader = hexToRGB(stringToHex(param1.c_header));
         colorText3 = hexToRGB(stringToHex(param1.c_text3));
         colorText = stringToHex(param1.c_text);
         colorText4 = stringToHex(param1.c_text4);
         colorHeaderText = stringToHex(param1.c_header_text);
         colorLinkStr = stringToHex(param1.c_link);
         Editor.COLOR = [hexToRGB(stringToHex(param1.c_yellow)),hexToRGB(stringToHex(param1.c_main)),hexToRGB(stringToHex(param1.c_move)),hexToRGB(stringToHex(param1.c_expr)),hexToRGB(stringToHex(param1.c_looks)),hexToRGB(stringToHex(param1.c_colors)),hexToRGB(stringToHex(param1.c_scale)),hexToRGB(stringToHex(param1.c_border))];
         Editor.COLOR_OVER = [hexToRGB(stringToHex(param1.c_yellow_over)),hexToRGB(stringToHex(param1.c_main_over)),hexToRGB(stringToHex(param1.c_move_over)),hexToRGB(stringToHex(param1.c_expr_over)),hexToRGB(stringToHex(param1.c_looks_over)),hexToRGB(stringToHex(param1.c_colors_over)),hexToRGB(stringToHex(param1.c_scale_over)),hexToRGB(stringToHex(param1.c_border_over))];
         Status.setColor(colorText,colorBkgdHex);
         GREEN = hexToRGB(stringToHex(param1.c_green));
         GREEN_OVER = hexToRGB(stringToHex(param1.c_green_over));
         RED = hexToRGB(stringToHex(param1.c_red));
         RED_OVER = hexToRGB(stringToHex(param1.c_red_over));
      }
      
      public static function getRandomColor(param1:uint, param2:int = -1) : uint
      {
         var _loc3_:uint = 0;
         if(param1 == Globals.HAIR_COLOR || param2 > Globals.HUMAN && param1 == Globals.SKIN_COLOR)
         {
            _loc3_ = HAIR;
            return colorByType[_loc3_][Math.floor(Math.random() * colorByType[_loc3_].length)];
         }
         if(param1 == Globals.SKIN_COLOR || param1 == Globals.LIP_COLOR)
         {
            _loc3_ = SKIN;
            if(Math.random() < 0.8)
            {
               return colorByType[_loc3_][Math.floor(Utils.normalize(0,4,1))];
            }
            return colorByType[_loc3_][Math.floor(Utils.normalize(4,colorByType[_loc3_].length,1))];
         }
         _loc3_ = OTHER;
         return colorByType[_loc3_][Math.floor(Math.random() * colorByType[_loc3_].length)];
      }
      
      public static function getDefaultColor(param1:int, param2:int = -1) : uint
      {
         switch(param1)
         {
            case SILHOUETTE_COLOR:
               return WHITE_ID;
            case Globals.SKIN_COLOR:
               if(param2 == Globals.HUMAN)
               {
                  return 4;
               }
               if(param2 == Globals.BIRD)
               {
                  return 20;
               }
               return 19;
               break;
            case Globals.LIP_COLOR:
               if(param2 == Globals.HUMAN)
               {
                  return 4;
               }
               if(param2 == Globals.BIRD)
               {
                  return 18;
               }
               return 19;
               break;
            case Globals.HAIR_COLOR:
               if(param2 == Globals.HUMAN)
               {
                  return 20;
               }
               if(param2 == Globals.BIRD)
               {
                  return 21;
               }
               return 15;
               break;
            case Globals.PANT_COLOR:
               return param2 == Globals.HUMAN ? uint(20) : uint(146);
            case Globals.SHIRT_COLOR:
               if(param2 == Globals.HUMAN)
               {
                  return 14;
               }
               if(param2 == Globals.BIRD)
               {
                  return WHITE_ID;
               }
               return 20;
               break;
            case Globals.IRIS_COLOR:
               if(param2 == Globals.HUMAN)
               {
                  return 56;
               }
               if(param2 == Globals.BIRD)
               {
                  return 18;
               }
               return 21;
               break;
            case Globals.ACCESSORY_COLOR:
               return param2 == Globals.HUMAN ? uint(21) : uint(WHITE_ID);
            case Globals.SHOE_COLOR:
               if(param2 == Globals.BIRD)
               {
                  return 19;
               }
               return 21;
               break;
            case Globals.HAT_COLOR:
               return param2 == Globals.HUMAN ? uint(134) : uint(21);
            case Globals.EYELID_COLOR:
               return param2 == Globals.HUMAN ? uint(188) : uint(WHITE_ID);
            case Globals.GLOVE_COLOR:
               return param2 == Globals.BIRD ? uint(20) : uint(WHITE_ID);
            default:
               return WHITE_ID;
         }
      }
      
      public static function getColor(param1:uint) : Array
      {
         if(colorByID[param1] == null)
         {
            return getColor(WHITE_ID);
         }
         return colorByID[param1];
      }
      
      public static function getColors(param1:Boolean) : Array
      {
         if(param1)
         {
            return colors;
         }
         return solidColors;
      }
      
      public static function isBright(param1:Array) : Boolean
      {
         var _loc2_:uint = param1[R];
         var _loc3_:uint = param1[G];
         var _loc4_:uint = param1[B];
         var _loc5_:Number;
         return (_loc5_ = Math.sqrt(0.241 * _loc2_ * _loc2_ + 0.691 * _loc3_ * _loc3_ + 0.068 * _loc4_ * _loc4_)) > 130;
      }
      
      public static function stringToHex(param1:String) : uint
      {
         if(param1.substr(0,1) == "#")
         {
            param1 = param1.substr(1);
         }
         return parseInt("0x" + param1);
      }
      
      public static function hexToRGB(param1:uint) : Array
      {
         return [(param1 & 16711680) >> 16,(param1 & 65280) >> 8,param1 & 255];
      }
      
      public static function RGBtoHex(param1:Array) : uint
      {
         if(param1 == null)
         {
            return 0;
         }
         return param1[R] << 16 ^ param1[G] << 8 ^ param1[B];
      }
      
      private static function shiftColor(param1:Array, param2:Array, param3:Number) : Array
      {
         var _loc4_:uint = 0;
         var _loc5_:Array = [];
         _loc4_ = R;
         while(_loc4_ <= B)
         {
            _loc5_[_loc4_] = param1[_loc4_] + (param2[_loc4_] - param1[_loc4_]) * param3;
            _loc4_++;
         }
         return _loc5_;
      }
      
      public static function setSaturation(param1:MovieClip, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : void
      {
         var _loc6_:ColorMatrix = null;
         if(param2 != 0)
         {
            (_loc6_ = new ColorMatrix()).adjustColor(param3,param4,param2 * 100,param5);
            FX.replaceFilter(param1,new ColorMatrixFilter(_loc6_));
         }
         else
         {
            FX.removeFilter(param1,ColorMatrixFilter);
         }
      }
      
      public static function setTint(param1:MovieClip, param2:Array = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param2 == null || param2[A] == 0)
         {
            setSaturation(param1);
            Utils.setColor(param1);
         }
         else
         {
            setSaturation(param1,-1);
            Utils.setColor(param1,param2,-1);
         }
      }
      
      public static function averageColors(... rest) : Array
      {
         var _loc5_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:uint = rest.length;
         for each(_loc5_ in rest)
         {
            _loc2_ += _loc5_[R];
            _loc3_ += _loc5_[G];
            _loc4_ += _loc5_[B];
         }
         return [_loc2_ / _loc6_,_loc3_ / _loc6_,_loc4_ / _loc6_];
      }
      
      public static function rgb2hex(param1:Array) : uint
      {
         return param1[R] << 16 ^ param1[G] << 8 ^ param1[B];
      }
      
      public static function hex2rgb(param1:Number) : Array
      {
         return [(param1 & 16711680) >> 16,(param1 & 65280) >> 8,param1 & 255];
      }
      
      public static function hsl2rgb(param1:Array) : Array
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc2_:Number = param1[0];
         var _loc3_:Number = param1[1];
         var _loc5_:Number;
         var _loc6_:Number = _loc5_ = Number(param1[2]);
         var _loc7_:Number = _loc4_;
         var _loc8_:Number;
         if((_loc8_ = _loc4_ <= 0.5 ? Number(_loc4_ * (1 + _loc3_)) : Number(_loc4_ + _loc3_ - _loc4_ * _loc3_)) > 0)
         {
            _loc9_ = _loc4_ + _loc4_ - _loc8_;
            _loc10_ = (_loc8_ - _loc9_) / _loc8_;
            _loc2_ *= 6;
            _loc11_ = Math.floor(_loc2_);
            _loc12_ = _loc2_ - _loc11_;
            _loc13_ = _loc8_ * _loc10_ * _loc12_;
            _loc14_ = _loc9_ + _loc13_;
            _loc15_ = _loc8_ - _loc13_;
            switch(_loc11_)
            {
               case 0:
                  _loc5_ = _loc8_;
                  _loc6_ = _loc14_;
                  _loc7_ = _loc9_;
                  break;
               case 1:
                  _loc5_ = _loc15_;
                  _loc6_ = _loc8_;
                  _loc7_ = _loc9_;
                  break;
               case 2:
                  _loc5_ = _loc9_;
                  _loc6_ = _loc8_;
                  _loc7_ = _loc14_;
                  break;
               case 3:
                  _loc5_ = _loc9_;
                  _loc6_ = _loc15_;
                  _loc7_ = _loc8_;
                  break;
               case 4:
                  _loc5_ = _loc14_;
                  _loc6_ = _loc9_;
                  _loc7_ = _loc8_;
                  break;
               case 5:
                  _loc5_ = _loc8_;
                  _loc6_ = _loc9_;
                  _loc7_ = _loc15_;
            }
         }
         return [Math.round(_loc5_ * 255),Math.round(_loc6_ * 255),Math.round(_loc7_ * 255)];
      }
      
      public static function rgb2hsl(param1:Array) : Array
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc5_:Number = param1[R] / 255;
         var _loc6_:Number = param1[G] / 255;
         var _loc7_:Number = param1[B] / 255;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc8_ = Math.max(_loc5_,_loc6_);
         _loc8_ = Math.max(_loc8_,_loc7_);
         _loc9_ = Math.min(_loc5_,_loc6_);
         if((_loc4_ = ((_loc9_ = Math.min(_loc9_,_loc7_)) + _loc8_) / 2) <= 0)
         {
            return [0,0,0];
         }
         _loc3_ = _loc10_ = _loc8_ - _loc9_;
         if(_loc3_ > 0)
         {
            _loc3_ /= _loc4_ <= 0.5 ? _loc8_ + _loc9_ : 2 - _loc8_ - _loc9_;
            _loc11_ = (_loc8_ - _loc5_) / _loc10_;
            _loc12_ = (_loc8_ - _loc6_) / _loc10_;
            _loc13_ = (_loc8_ - _loc7_) / _loc10_;
            if(_loc5_ == _loc8_)
            {
               _loc2_ = _loc6_ == _loc9_ ? Number(5 + _loc13_) : Number(1 - _loc12_);
            }
            else if(_loc6_ == _loc8_)
            {
               _loc2_ = _loc7_ == _loc9_ ? Number(1 + _loc11_) : Number(3 - _loc13_);
            }
            else
            {
               _loc2_ = _loc5_ == _loc9_ ? Number(3 + _loc12_) : Number(5 - _loc11_);
            }
            _loc2_ /= 6;
            return [_loc2_,_loc3_,_loc4_];
         }
         return [1,1,1];
      }
      
      public static function lightenRGB(param1:Array) : Array
      {
         if(param1 == RED)
         {
            return [255,113,91];
         }
         return [Math.min(255,param1[R] + 20),Math.min(255,param1[G] + 19),Math.min(255,param1[B] + 18)];
      }
      
      public static function lighten(param1:Number, param2:Number = 0) : Number
      {
         var _loc3_:Array = null;
         if(cacheLighten[param1 + "_" + param2] == null)
         {
            if(param2 == 0)
            {
               param2 = FACTOR_LIGHTEN;
            }
            _loc3_ = rgb2hsl(hex2rgb(param1));
            if(_loc3_[0] == 0 && _loc3_[1] == 0 && _loc3_[2] == 0)
            {
               cacheLighten[param1 + "_" + param2] = 6710886;
            }
            else
            {
               _loc3_[2] = Math.max(0,Math.min(1,_loc3_[2] * param2));
               cacheLighten[param1 + "_" + param2] = rgb2hex(hsl2rgb(_loc3_));
            }
         }
         return cacheLighten[param1 + "_" + param2];
      }
      
      public static function darken(param1:Number) : Number
      {
         var _loc2_:Array = rgb2hsl(hex2rgb(param1));
         _loc2_[2] = Math.max(0,Math.min(1,_loc2_[2] * FACTOR_DARKEN));
         return rgb2hex(hsl2rgb(_loc2_));
      }
      
      public static function getColorsByRange(param1:uint) : Array
      {
         switch(param1)
         {
            case RANGE_SKIN:
               return [2,3,5,7,18,19];
            default:
               return null;
         }
      }
      
      public static function getColorsByType(param1:uint, param2:int = -1) : Array
      {
         return colorByType[param1];
      }
   }
}
