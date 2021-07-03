package com.pixton.animate
{
   import com.pixton.editor.Character;
   import com.pixton.editor.Dialog;
   import com.pixton.editor.Editor;
   import com.pixton.editor.L;
   import com.pixton.editor.Moveable;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Prop;
   import com.pixton.editor.Utils;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class Channel extends MovieClip
   {
      
      public static const CELL_WIDTH:uint = 10;
      
      public static const CELL_HEIGHT:uint = 16;
      
      public static const CELL_GROUP_SIZE:uint = 12;
      
      public static const CELL_INNER_HEIGHT:uint = CELL_HEIGHT - 2;
      
      public static const BACK:Boolean = false;
      
      public static const NEXT:Boolean = true;
      
      private static const CELL_PADDING:uint = 0;
      
      private static const MAX_NAME_LENGTH:uint = 16;
      
      private static const COLOR_INACTIVE:uint = 13421772;
      
      private static const COLOR_ACTIVE:uint = 3355443;
      
      private static const COLOR_BKGD:uint = 16053492;
      
      private static const COLOR_FIXED:uint = 0;
      
      private static const CELL_ALPHA:Number = 0.2;
      
      private static const LOOPED_ALPHA:Number = 0.2;
      
      private static const FIXED_INSET:uint = 2;
      
      private static const FOOT_Y_TOLERANCE:Number = 5;
      
      private static const FOOT_R_TOLERANCE:Number = 5;
      
      public static var cellsUsed:int = -1;
      
      public static var visibleCells:uint = 0;
      
      public static var cellOffset:uint = 0;
       
      
      public var txtName:TextField;
      
      public var target:Object;
      
      public var targetID:uint;
      
      public var targetName:String;
      
      public var targetZOrder:uint;
      
      private var data:Array;
      
      private var map:Array;
      
      public function Channel(param1:Object)
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         super();
         this.target = param1;
         this.targetID = Animation.getTargetType(param1);
         this.data = [];
         this.txtName.wordWrap = false;
         this.txtName.multiline = false;
         this.targetZOrder = uint.MAX_VALUE;
         if(param1 is Editor)
         {
            this.setName(L.text("scene"));
         }
         else
         {
            if(param1.parent != null)
            {
               this.targetZOrder = uint.MAX_VALUE - param1.parent.getChildIndex(param1);
            }
            if(param1 is Character)
            {
               _loc2_ = Character(param1).getName();
               if(_loc2_ == Character.defaultName)
               {
                  _loc2_ = L.text("character");
               }
               this.setName(_loc2_);
            }
            else if(param1 is Prop)
            {
               this.setName(Prop(param1).getName());
            }
            else if(param1 is Dialog)
            {
               _loc3_ = Dialog(param1).text;
               if(_loc3_ == "")
               {
                  this.setName(L.text("text"));
               }
               else
               {
                  _loc3_ = _loc3_.replace(/ ?(\r|\n)+ ?/," ");
                  if(_loc3_.length > MAX_NAME_LENGTH)
                  {
                     _loc3_ = _loc3_.substr(0,MAX_NAME_LENGTH) + "-";
                  }
                  this.setName(_loc3_);
               }
            }
         }
         this.remap();
         this.redraw();
      }
      
      private function remap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         this.map = [];
         this.data.sortOn("m",Array.NUMERIC);
         _loc2_ = this.data.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc8_ = (_loc7_ = this.data[_loc1_]).m;
            _loc10_ = [];
            _loc7_.k.sortOn("p",Array.NUMERIC);
            _loc6_ = _loc7_.k.length;
            _loc7_.n = Math.min(_loc7_.n,Animation.maxFrames);
            _loc5_ = 0;
            _loc4_ = _loc7_.n;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc9_ = {};
               if(_loc5_ < _loc6_ && _loc7_.k[_loc5_].p == _loc3_)
               {
                  _loc9_.kfi = _loc5_;
                  _loc9_.kfo = _loc7_.k[_loc5_];
                  _loc5_++;
               }
               _loc10_[_loc3_] = _loc9_;
               _loc3_++;
            }
            this.map[_loc8_] = {
               "i":_loc1_,
               "n":_loc4_,
               "f":_loc10_
            };
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc8_ = (_loc7_ = this.data[_loc1_]).m;
            _loc4_ = _loc7_.n;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               (_loc9_ = this.map[_loc8_].f[_loc3_]).kf = [];
               _loc9_.kf[0] = this.getAdjacentKeyframe(_loc8_,_loc3_,BACK,2);
               _loc9_.kf[1] = this.getAdjacentKeyframe(_loc8_,_loc3_,BACK,1);
               _loc9_.kf[2] = this.getAdjacentKeyframe(_loc8_,_loc3_,NEXT,1);
               _loc9_.kf[3] = this.getAdjacentKeyframe(_loc8_,_loc3_,NEXT,2);
               _loc9_.kfw = [];
               _loc9_.kfw[0] = this.getAdjacentKeyframe(_loc8_,_loc3_,BACK,2,true);
               _loc9_.kfw[1] = this.getAdjacentKeyframe(_loc8_,_loc3_,BACK,1,true);
               _loc9_.kfw[2] = this.getAdjacentKeyframe(_loc8_,_loc3_,NEXT,1,true);
               _loc9_.kfw[3] = this.getAdjacentKeyframe(_loc8_,_loc3_,NEXT,2,true);
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      private function getAdjacentKeyframe(param1:uint, param2:uint, param3:Boolean, param4:uint, param5:Boolean = false) : int
      {
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = this.map[param1].n;
         var _loc9_:uint;
         var _loc10_:int = _loc9_ = this.data[this.map[param1].i].k.length;
         var _loc11_:int = param3 == BACK ? -1 : 1;
         _loc6_ = _loc7_ = param3 == BACK ? uint(param2) : uint(param2 + 1);
         while(_loc6_ < _loc8_)
         {
            if(this.map[param1].f[_loc6_].kfi != null)
            {
               _loc10_ = this.map[param1].f[_loc6_].kfi;
               break;
            }
            _loc6_ += _loc11_;
         }
         if(param4 > 1)
         {
            _loc10_ += (param4 - 1) * _loc11_;
         }
         if(param5)
         {
            return Utils.wrap(_loc10_,_loc9_);
         }
         return Utils.limit(_loc10_,0,_loc9_ - 1);
      }
      
      private function setName(param1:String) : void
      {
         this.txtName.text = param1.toUpperCase();
         this.targetName = param1;
      }
      
      public function getNumRows() : uint
      {
         return this.data.length;
      }
      
      public function getHeight() : Number
      {
         return this.getNumRows() * CELL_HEIGHT;
      }
      
      public function autoAlignHandProp(param1:Object, param2:uint) : Object
      {
         var _loc4_:Point = null;
         var _loc3_:uint = Animation.MODE_DEFAULT;
         if(param1 == null)
         {
            param1 = Editor.self.getNearestHandData(this.target as Prop);
         }
         else
         {
            _loc4_ = this.target.parent.globalToLocal(param1.hand.localToGlobal(new Point(param1.x,param1.y)));
            this.target.x = _loc4_.x;
            this.target.y = _loc4_.y;
            Animation.self.autoSave(this.target,_loc3_);
         }
         return param1;
      }
      
      public function autoAlignFeet(param1:Object, param2:uint) : Object
      {
         var _loc9_:Number = NaN;
         this.target.redraw(true);
         var _loc3_:uint = Animation.MODE_DEFAULT;
         var _loc4_:Object;
         var _loc5_:Number = (_loc4_ = Animation.getAlignData(this.target)).foot1.y - _loc4_.foot2.y;
         var _loc6_:Number = Math.abs(_loc4_.foot1.rotation - -90);
         var _loc7_:Number = Math.abs(_loc4_.foot2.rotation - -90);
         var _loc8_:Number = _loc6_ - _loc7_;
         if(Math.abs(_loc5_) > FOOT_Y_TOLERANCE)
         {
            if(_loc5_ > 0)
            {
               _loc4_.grounded = "foot1";
            }
            else
            {
               _loc4_.grounded = "foot2";
            }
         }
         else if(Math.abs(_loc8_) > FOOT_R_TOLERANCE)
         {
            if(_loc6_ < _loc7_)
            {
               _loc4_.grounded = "foot1";
            }
            else
            {
               _loc4_.grounded = "foot2";
            }
         }
         else if(param1 == null)
         {
            if(_loc5_ > 0)
            {
               _loc4_.grounded = "foot1";
            }
            else
            {
               _loc4_.grounded = "foot2";
            }
         }
         else
         {
            _loc4_.grounded = param1.grounded;
         }
         if(param1 != null)
         {
            _loc9_ = _loc4_[_loc4_.grounded].x - param1[_loc4_.grounded].x;
            this.target.x -= _loc9_;
            _loc4_.foot1.x -= _loc9_;
            _loc4_.foot2.x -= _loc9_;
            Animation.self.autoSave(this.target,_loc3_);
         }
         return _loc4_;
      }
      
      public function autoSave(param1:uint, param2:Object, param3:uint, param4:uint, param5:uint) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:* = null;
         var _loc13_:Number = NaN;
         var _loc14_:Object = null;
         var _loc8_:Boolean = false;
         var _loc12_:Object = {};
         if((_loc9_ = this.getKeyframe(param1,param5)) == null)
         {
            _loc14_ = this.updateScene(param5,false,true);
            _loc10_ = this.target.getInterpolatedPositionData(_loc14_[param1].keyframes,_loc14_[param1].ratio);
         }
         else
         {
            _loc10_ = this.target is Character ? (param1 == Animation.MODE_DEFAULT ? _loc9_.d.p : _loc9_.d.px.t) : _loc9_.d;
         }
         param2 = this.target is Character ? (param1 == Animation.MODE_DEFAULT ? param2.p : param2.px.t) : param2;
         for(_loc11_ in param2)
         {
            if((_loc13_ = param2[_loc11_] - _loc10_[_loc11_]) != 0)
            {
               _loc12_[_loc11_] = _loc13_;
               _loc8_ = true;
            }
         }
         if(_loc8_)
         {
            _loc7_ = param3 + param4;
            _loc6_ = param3;
            while(_loc6_ < _loc7_)
            {
               if((_loc9_ = this.getKeyframe(param1,_loc6_)) != null)
               {
                  _loc10_ = this.target is Character ? (param1 == Animation.MODE_DEFAULT ? _loc9_.d.p : _loc9_.d.px.t) : _loc9_.d;
                  for(_loc11_ in _loc12_)
                  {
                     _loc10_[_loc11_] += _loc12_[_loc11_];
                  }
               }
               _loc6_++;
            }
         }
      }
      
      public function targetHidden(param1:uint, param2:Boolean) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = Animation.MODE_DEFAULT;
         if(this.isEmpty(_loc3_))
         {
            return false;
         }
         if(this.map[_loc3_].f[param1] == null)
         {
            _loc4_ = this.map[_loc3_].n - 1;
            return this.data[this.map[_loc3_].i].k[this.map[_loc3_].f[_loc4_].kf[1]].d.hh == 1;
         }
         return this.data[this.map[_loc3_].i].k[this.map[_loc3_].f[param1].kf[1]].d.hh == 1;
      }
      
      private function getNumCells(param1:uint) : uint
      {
         return this.map[param1].n;
      }
      
      private function getKeyframeIndex(param1:uint, param2:uint) : int
      {
         if(this.map[param1] == null || this.map[param1].f[param2] == null)
         {
            return -1;
         }
         if(this.map[param1].f[param2].kfi == null)
         {
            return -1;
         }
         return this.map[param1].f[param2].kfi;
      }
      
      function getKeyframe(param1:uint, param2:uint) : Object
      {
         if(this.map[param1].f[param2] == null)
         {
            return null;
         }
         return this.map[param1].f[param2].kfo;
      }
      
      private function getKeyframes(param1:uint, param2:int = -1, param3:int = -1) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         if(param2 == -1 || param3 == -1)
         {
            return this.data[this.map[param1].i].k;
         }
         if((_loc4_ = this.data[this.map[param1].i].k.slice(param2,param3 + 1)).length > 0)
         {
            _loc5_ = _loc4_[0].p;
            for each(_loc6_ in _loc4_)
            {
               _loc6_.p -= _loc5_;
            }
         }
         return _loc4_;
      }
      
      public function numEmptyFramesAfter(param1:uint) : uint
      {
         var _loc2_:Object = null;
         var _loc4_:int = 0;
         var _loc3_:int = -1;
         for each(_loc2_ in this.data)
         {
            _loc4_ = this.getFrame(_loc2_.m,param1);
            if((_loc3_ == -1 || _loc4_ < _loc3_) && _loc4_ > -1)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_ > -1)
         {
            return _loc3_ - param1;
         }
         return 0;
      }
      
      public function getFrame(param1:uint, param2:uint, param3:Boolean = true, param4:Boolean = true) : int
      {
         var _loc6_:int = 0;
         var _loc8_:uint = 0;
         var _loc5_:Array;
         var _loc7_:uint = (_loc5_ = this.data[this.map[param1].i].k).length;
         if(this.map[param1].f[param2] == null)
         {
            _loc6_ = param3 == BACK ? int(_loc7_ - 1) : int(_loc7_);
         }
         else
         {
            _loc5_ = this.map[param1].f[param2].kf;
            if(param3 == BACK)
            {
               if(this.map[param1].f[param2].kfi == null)
               {
                  _loc6_ = _loc5_[1];
               }
               else
               {
                  _loc6_ = _loc5_[0];
               }
            }
            else if(_loc5_[2] == _loc5_[1])
            {
               _loc6_ = _loc7_;
            }
            else
            {
               _loc6_ = _loc5_[2];
            }
         }
         if(_loc6_ == _loc7_)
         {
            if(param4 && param2 < this.map[param1].n - 1)
            {
               return this.map[param1].n - 1;
            }
            return Animation.maxFrames - 1;
         }
         return this.data[this.map[param1].i].k[_loc6_].p;
      }
      
      public function getFrameAllModes(param1:uint, param2:Boolean) : int
      {
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = param2 == Channel.BACK ? uint(0) : uint(Animation.maxFrames - 1);
         for each(_loc3_ in this.data)
         {
            _loc4_ = this.getFrame(_loc3_.m,param1,param2,false);
            if(param2 == Channel.BACK && _loc4_ > _loc5_ || param2 == Channel.NEXT && _loc4_ < _loc5_)
            {
               _loc5_ = _loc4_;
            }
         }
         return _loc5_;
      }
      
      public function getIndexByPosition(param1:uint, param2:uint, param3:Boolean = false, param4:Boolean = false) : uint
      {
         if(param3 == BACK)
         {
            if(this.map[param1].f[param2].kfi == null)
            {
               return this.map[param1].f[param2].kf[1];
            }
            return this.map[param1].f[param2].kf[!!param4 ? 1 : 0];
         }
         if(param2 > this.data[this.map[param1].i].k[this.data[this.map[param1].i].k.length - 1].p)
         {
            return this.data[this.map[param1].i].k.length;
         }
         if(this.map[param1].f[param2].kfi == null)
         {
            return this.map[param1].f[param2].kf[2];
         }
         return this.map[param1].f[param2].kf[!!param4 ? 1 : 2];
      }
      
      public function getRowNum(param1:uint) : uint
      {
         return this.map[param1].i;
      }
      
      public function insertCell(param1:int, param2:uint, param3:Boolean, param4:uint = 1) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         if(param1 == -1)
         {
            _loc7_ = this.data.length;
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               this.insertCell(this.data[_loc5_].m,param2,param3,param4);
               _loc5_++;
            }
         }
         else
         {
            _loc7_ = (_loc8_ = this.getKeyframes(param1)).length;
            if(param2 < this.map[param1].n)
            {
               _loc6_ = Math.max(this.getIndexByPosition(param1,param2,NEXT,true),1);
               if(!param3)
               {
                  if(param2 + param4 > this.map[param1].n)
                  {
                     param4 = this.map[param1].n - param2;
                  }
                  _loc5_ = _loc6_;
                  while(_loc5_ < _loc7_)
                  {
                     if(_loc8_[_loc5_].p > param2 + param4 - 1)
                     {
                        break;
                     }
                     _loc5_++;
                  }
                  _loc8_.splice(_loc6_,_loc5_ - _loc6_);
                  _loc7_ = _loc8_.length;
               }
               _loc5_ = _loc6_;
               while(_loc5_ < _loc7_)
               {
                  _loc8_[_loc5_].p += param4 * (!!param3 ? 1 : -1);
                  _loc5_++;
               }
               this.data[this.map[param1].i].n += param4 * (!!param3 ? 1 : -1);
            }
            else if(param3)
            {
               this.data[this.map[param1].i].n = param2 + param4;
            }
         }
         this.remap();
         this.redraw();
      }
      
      private function requireMode(param1:uint) : void
      {
         if(this.isEmpty(param1))
         {
            this.newMode(param1);
            this.remap();
         }
      }
      
      public function saveKeyframe(param1:uint, param2:uint, param3:Object, param4:Object = null, param5:Object = null, param6:uint = 0, param7:Boolean = false) : void
      {
         var _loc8_:* = null;
         this.requireMode(param1);
         var _loc9_:Object = {
            "p":param2,
            "d":Utils.clone(param3)
         };
         if(param7 && this.target is Dialog && param2 == 0)
         {
            _loc9_.d.hh = 1;
         }
         var _loc10_:Object = this.getPositionData(_loc9_);
         if(param4 != null)
         {
            for(_loc8_ in param5)
            {
               _loc10_[_loc8_] += param4[_loc8_];
            }
         }
         if(param5 != null && param6 > 0)
         {
            for(_loc8_ in param5)
            {
               _loc10_[_loc8_] += param5[_loc8_] * param6;
            }
         }
         var _loc11_:Array = this.getKeyframes(param1);
         if(param2 > 0 && _loc11_.length == 0)
         {
            this.saveKeyframe(param1,0,Utils.clone(param3),null,null,0,true);
         }
         if(this.map[param1].f[param2] != null && this.map[param1].f[param2].kfi != null)
         {
            _loc11_[this.map[param1].f[param2].kfi] = _loc9_;
         }
         else
         {
            _loc11_.push(_loc9_);
            if(this.data[this.map[param1].i].n <= param2)
            {
               this.data[this.map[param1].i].n = param2 + 1;
            }
            this.remap();
         }
      }
      
      public function deleteKeyframe(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = this.getKeyframeIndex(param1,param2);
         var _loc4_:Array;
         (_loc4_ = this.getKeyframes(param1)).splice(_loc3_,1);
         this.remap();
      }
      
      public function clearCells(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         if(param2 < 1)
         {
            param2 = 1;
         }
         var _loc5_:uint = Math.min(param2 + param3,this.map[param1].n);
         _loc4_ = param2;
         while(_loc4_ < _loc5_)
         {
            if(this.hasKeyframe(param1,_loc4_))
            {
               this.deleteKeyframe(param1,_loc4_);
            }
            _loc4_++;
         }
         if(this.map[param1].n - 1 <= param2 + param3)
         {
            this.data[this.map[param1].i].n = param2;
            this.remap();
         }
      }
      
      public function clear(param1:int = -1) : void
      {
         var _loc2_:Object = null;
         if(param1 > -1)
         {
            this.clearStream(param1);
         }
         else
         {
            for each(_loc2_ in this.data)
            {
               this.clearStream(_loc2_.m);
            }
         }
         if(param1 == -1 || param1 == Animation.MODE_DEFAULT)
         {
            if(this.target is Moveable)
            {
               Moveable(this.target).setHidden(false);
            }
         }
         this.redraw();
      }
      
      private function clearStream(param1:uint) : void
      {
         if(!this.map[param1])
         {
            return;
         }
         this.data.splice(this.map[param1].i,1);
         this.remap();
      }
      
      public function getNumKeyframes(param1:int) : uint
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         if(param1 > -1)
         {
            return (_loc4_ = this.getKeyframes(param1)).length;
         }
         _loc3_ = 0;
         for each(_loc2_ in this.data)
         {
            _loc3_ += this.getNumKeyframes(_loc2_.m);
         }
         return _loc3_;
      }
      
      public function copyKeyframes(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:Object = null;
         var _loc5_:uint = Math.min(Animation.maxFrames,param2 + param3);
         _loc4_ = param2;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ + param3 == Animation.maxFrames)
            {
               break;
            }
            if((_loc6_ = this.getKeyframe(param1,_loc4_)) != null)
            {
               this.saveKeyframe(param1,_loc4_ + param3,Utils.clone(_loc6_.d));
            }
            _loc4_++;
         }
         if(param2 + param3 * 2 > this.map[param1].n)
         {
            this.data[this.map[param1].i].n = Math.min(param2 + param3 * 2,Animation.maxFrames);
            this.remap();
         }
      }
      
      public function hasKeyframe(param1:uint, param2:uint) : Boolean
      {
         return this.getKeyframeIndex(param1,param2) > -1;
      }
      
      public function hasDeletableKeyframe(param1:uint, param2:uint) : Boolean
      {
         if(param2 == 0)
         {
            return false;
         }
         if(this.isEmpty(param1))
         {
            return false;
         }
         return this.hasKeyframe(param1,param2);
      }
      
      public function getMaxCellsUsed(param1:int = -1) : uint
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         if(param1 > -1)
         {
            return this.getNumCells(param1);
         }
         _loc3_ = 0;
         for each(_loc2_ in this.data)
         {
            if(_loc2_.n > _loc3_)
            {
               _loc3_ = _loc2_.n;
            }
         }
         return _loc3_;
      }
      
      public function getFirstAppearance() : uint
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this.modeExists(Animation.MODE_DEFAULT))
         {
            _loc1_ = this.getKeyframes(Animation.MODE_DEFAULT);
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.d.hh == null || _loc2_.d.hh == 0)
               {
                  return _loc2_.p;
               }
            }
         }
         return 0;
      }
      
      public function modeExists(param1:uint) : Boolean
      {
         return this.map[param1] != null;
      }
      
      public function redraw() : void
      {
         var _loc1_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:uint = 0;
         var _loc17_:* = false;
         var _loc18_:Object = null;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc2_:uint = Math.min(cellOffset + visibleCells,Animation.maxFrames,cellsUsed);
         var _loc5_:Graphics;
         (_loc5_ = this.graphics).clear();
         var _loc21_:uint = this.data.length;
         _loc20_ = 0;
         while(_loc20_ < _loc21_)
         {
            _loc3_ = this.data[_loc20_].m;
            _loc8_ = 0;
            _loc9_ = CELL_WIDTH * Channel.visibleCells;
            _loc11_ = (_loc10_ = _loc20_ * CELL_HEIGHT) + CELL_INNER_HEIGHT;
            _loc5_.beginFill(COLOR_BKGD);
            _loc5_.lineStyle(1,COLOR_INACTIVE,1,true);
            _loc5_.moveTo(_loc8_,_loc10_);
            _loc5_.lineTo(_loc9_,_loc10_);
            _loc5_.lineTo(_loc9_,_loc11_);
            _loc5_.lineTo(_loc8_,_loc11_);
            _loc5_.lineTo(_loc8_,_loc10_);
            _loc5_.endFill();
            _loc9_ = (_loc4_ = Math.min(this.data[_loc20_].n - cellOffset,visibleCells)) * CELL_WIDTH;
            if(_loc4_ > 0)
            {
               _loc5_.beginFill(COLOR_BKGD);
               _loc5_.lineStyle(1,COLOR_ACTIVE,1,true);
               _loc5_.moveTo(_loc8_,_loc10_);
               _loc5_.lineTo(_loc9_,_loc10_);
               _loc5_.lineTo(_loc9_,_loc11_);
               _loc5_.lineTo(_loc8_,_loc11_);
               _loc5_.lineTo(_loc8_,_loc10_);
               _loc5_.endFill();
            }
            _loc1_ = _loc2_ - 1;
            while(_loc1_ >= cellOffset)
            {
               _loc16_ = _loc1_ % this.data[_loc20_].n;
               _loc17_ = _loc1_ >= this.data[_loc20_].n;
               _loc4_ = _loc1_ - cellOffset;
               _loc5_.lineStyle(1,!!_loc17_ ? uint(COLOR_INACTIVE) : uint(COLOR_ACTIVE),1,true);
               _loc14_ = _loc20_ * CELL_HEIGHT + CELL_PADDING;
               _loc15_ = _loc20_ * CELL_HEIGHT + CELL_INNER_HEIGHT - CELL_PADDING;
               _loc12_ = _loc4_ * CELL_WIDTH + CELL_PADDING;
               _loc13_ = (_loc4_ + 1) * CELL_WIDTH - CELL_PADDING;
               _loc6_ = ((_loc18_ = this.getKeyframe(this.data[_loc20_].m,_loc16_)) == null ? CELL_ALPHA : 1) * (!!_loc17_ ? LOOPED_ALPHA : 1);
               if(this.data[this.map[_loc3_].i].k[this.map[_loc3_].f[_loc16_].kf[1]].d.hh != 1)
               {
                  _loc7_ = Palette.RGBtoHex(Editor.COLOR[this.data[_loc20_].m + Editor.MODE_MOVE - Animation.MODE_DEFAULT]);
               }
               else
               {
                  _loc7_ = COLOR_INACTIVE;
               }
               _loc19_ = !!_loc17_ ? uint(COLOR_INACTIVE) : uint(COLOR_ACTIVE);
               _loc5_.lineStyle(1,_loc19_,1,true);
               _loc5_.beginFill(_loc7_,_loc6_);
               _loc5_.moveTo(_loc12_,_loc14_);
               _loc5_.lineTo(_loc13_,_loc14_);
               if(_loc18_ == null && _loc1_ < this.data[_loc20_].n - 1)
               {
                  _loc5_.lineStyle();
               }
               _loc5_.lineTo(_loc13_,_loc15_);
               _loc5_.lineStyle(1,_loc19_,1,true);
               _loc5_.lineTo(_loc12_,_loc15_);
               if(_loc18_ == null)
               {
                  _loc5_.lineStyle();
               }
               _loc5_.lineTo(_loc12_,_loc14_);
               _loc5_.endFill();
               if(_loc18_ == null)
               {
                  _loc5_.lineStyle(1,_loc19_,0.5,true);
                  _loc5_.moveTo(_loc12_ + 3,(_loc14_ + _loc15_) * 0.5);
                  _loc5_.lineTo(_loc13_ - 2,(_loc14_ + _loc15_) * 0.5);
               }
               else if(_loc4_ > 0)
               {
                  _loc5_.lineStyle(1,_loc19_,1,true);
                  _loc5_.beginFill(_loc19_);
                  _loc5_.moveTo(_loc12_ - 2,(_loc14_ + _loc15_) * 0.5);
                  _loc5_.lineTo(_loc12_ - 4,(_loc14_ + _loc15_) * 0.5 - 2);
                  _loc5_.lineTo(_loc12_ - 4,(_loc14_ + _loc15_) * 0.5 + 2);
                  _loc5_.lineTo(_loc12_ - 2,(_loc14_ + _loc15_) * 0.5);
                  _loc5_.endFill();
               }
               _loc1_--;
            }
            _loc20_++;
         }
         this.txtName.y = Math.round((_loc20_ * CELL_HEIGHT - this.txtName.height) * 0.5);
      }
      
      public function updateScene(param1:uint, param2:Boolean = false, param3:Boolean = false) : Array
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc12_:Object = null;
         if(param1 >= cellsUsed && cellsUsed > 0)
         {
            param1 = cellsUsed - 1;
         }
         var _loc11_:Array = [];
         for each(_loc12_ in this.data)
         {
            _loc9_ = _loc12_.m;
            _loc10_ = param1 % _loc12_.n;
            if(param2)
            {
               _loc4_ = this.map[_loc9_].f[_loc10_].kfw[0];
               _loc5_ = this.map[_loc9_].f[_loc10_].kfw[1];
               _loc6_ = this.map[_loc9_].f[_loc10_].kfw[2];
               _loc7_ = this.map[_loc9_].f[_loc10_].kfw[3];
            }
            else
            {
               _loc4_ = this.map[_loc9_].f[_loc10_].kf[0];
               _loc5_ = this.map[_loc9_].f[_loc10_].kf[1];
               _loc6_ = this.map[_loc9_].f[_loc10_].kf[2];
               _loc7_ = this.map[_loc9_].f[_loc10_].kf[3];
            }
            if(_loc6_ > _loc5_)
            {
               _loc8_ = (_loc10_ - _loc12_.k[_loc5_].p) / (_loc12_.k[_loc6_].p - _loc12_.k[_loc5_].p);
            }
            else
            {
               _loc8_ = (_loc10_ - _loc12_.k[_loc5_].p) / (_loc12_.n - _loc12_.k[_loc5_].p);
            }
            if(param3)
            {
               _loc11_[_loc9_] = {
                  "keyframes":[_loc12_.k[_loc4_].d,_loc12_.k[_loc5_].d,_loc12_.k[_loc6_].d,_loc12_.k[_loc7_].d],
                  "ratio":_loc8_
               };
            }
            else
            {
               Animation.setTargetData(this.target,_loc9_,[_loc12_.k[_loc4_].d,_loc12_.k[_loc5_].d,_loc12_.k[_loc6_].d,_loc12_.k[_loc7_].d],_loc8_);
            }
         }
         if(param3)
         {
            return _loc11_;
         }
         return null;
      }
      
      public function getOnionData(param1:uint, param2:Boolean) : Array
      {
         var _loc3_:Object = this.updateScene(param1,param2,true);
         return _loc3_.keyframes as Array;
      }
      
      public function getData(param1:int = -1, param2:int = -1, param3:int = -1, param4:int = -1, param5:Boolean = false) : Object
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         if(param1 == -1)
         {
            _loc8_ = {"data":this.data};
         }
         else if(param2 == -1)
         {
            _loc8_ = {"data":this.data[this.map[param1].i].k};
         }
         else
         {
            _loc11_ = [];
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
               _loc7_ = param1 + _loc6_;
               _loc9_ = this.getIndexByPosition(_loc7_,param2,NEXT,true);
               if(param5 && !this.hasKeyframe(_loc7_,param2 + param4 - 1))
               {
                  this.saveKeyframe(_loc7_,param2 + param4 - 1,this.data[this.map[_loc7_].i].k[_loc9_].d);
               }
               _loc10_ = this.getIndexByPosition(_loc7_,param2 + param4 - 1,BACK,true);
               _loc12_ = this.getKeyframes(_loc7_,_loc9_,_loc10_);
               _loc11_.push({
                  "k":_loc12_,
                  "m":_loc7_,
                  "n":param4
               });
               _loc6_++;
            }
            _loc8_ = {"data":_loc11_};
         }
         return _loc8_;
      }
      
      public function setData(param1:Object, param2:int = -1, param3:int = -1, param4:int = -1, param5:Object = null) : void
      {
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:uint = 0;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc6_:Array;
         var _loc8_:uint = (_loc6_ = param1.data).length;
         if(param2 == -1)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               param2 = _loc6_[_loc7_].m;
               if(this.isEmpty(param2))
               {
                  this.newMode(param2);
               }
               this.data[_loc7_] = _loc6_[_loc7_];
               _loc7_++;
            }
         }
         else if(param3 != -1)
         {
            if(param4 > -1)
            {
               if(param2 == Animation.MODE_DEFAULT)
               {
                  if(this.modeExists(param2))
                  {
                     if(param3 >= this.map[param2].n)
                     {
                        _loc16_ = this.data[this.map[param2].i].k.length - 1;
                     }
                     else
                     {
                        _loc16_ = this.getIndexByPosition(param2,param3,BACK,true);
                     }
                     _loc17_ = this.getPositionData(this.data[this.map[param2].i].k[_loc16_]);
                  }
                  else
                  {
                     _loc17_ = this.target.getAnimationPositionData();
                  }
                  _loc18_ = this.getPositionData(_loc6_[0].k[0]);
                  param5 = {
                     "x":_loc17_.x - _loc18_.x,
                     "y":_loc17_.y - _loc18_.y
                  };
               }
               else
               {
                  param5 = null;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc8_)
               {
                  _loc14_ = {};
                  _loc13_ = _loc6_[_loc7_].k.length;
                  _loc9_ = 0;
                  while(_loc9_ < _loc13_)
                  {
                     _loc14_[_loc6_[_loc7_].k[_loc9_].p.toString()] = _loc9_;
                     _loc9_++;
                  }
                  param2 = _loc6_[_loc7_].m;
                  this.requireMode(param2);
                  if(param3 + param4 > this.map[param2].n)
                  {
                     this.data[this.map[param2].i].n = param3 + param4;
                  }
                  if(param2 == Animation.MODE_DEFAULT)
                  {
                     _loc13_ = _loc6_[_loc7_].k.length;
                     _loc17_ = this.getPositionData(_loc6_[_loc7_].k[0]);
                     _loc18_ = this.getPositionData(_loc6_[_loc7_].k[_loc13_ - 1]);
                     _loc19_ = _loc17_.x;
                     _loc20_ = _loc17_.y;
                     _loc21_ = _loc18_.x;
                     _loc22_ = _loc18_.y;
                     _loc15_ = {
                        "x":_loc21_ - _loc19_,
                        "y":_loc22_ - _loc20_
                     };
                  }
                  else
                  {
                     _loc15_ = null;
                  }
                  _loc13_ = param4;
                  _loc9_ = 0;
                  while(_loc9_ < _loc13_)
                  {
                     if(_loc9_ == 0)
                     {
                        _loc10_ = 0;
                        _loc11_ = 0;
                     }
                     else
                     {
                        _loc10_ = (_loc9_ - 1) % (_loc6_[_loc7_].n - 1) + 1;
                        _loc11_ = Math.floor((_loc9_ - 1) / (_loc6_[_loc7_].n - 1));
                     }
                     if(param3 + _loc9_ > 0 && this.hasKeyframe(param2,param3 + _loc9_))
                     {
                        this.deleteKeyframe(param2,param3 + _loc9_);
                     }
                     if(_loc14_[_loc10_] != null)
                     {
                        this.saveKeyframe(param2,param3 + _loc9_,_loc6_[_loc7_].k[_loc14_[_loc10_]].d,param5,_loc15_,_loc11_);
                     }
                     _loc9_++;
                  }
                  _loc7_++;
               }
               if(!this.isEmpty(Animation.MODE_DEFAULT) && !this.isEmpty(Animation.MODE_EXPR))
               {
                  if(this.map[Animation.MODE_DEFAULT].n < this.map[Animation.MODE_EXPR].n)
                  {
                     this.data[this.map[Animation.MODE_DEFAULT].i].n = this.map[Animation.MODE_EXPR].n;
                  }
               }
            }
         }
         this.remap();
         this.redraw();
      }
      
      private function getPositionData(param1:Object) : Object
      {
         if(param1.d.p != null)
         {
            return param1.d.p;
         }
         return param1.d;
      }
      
      private function newMode(param1:uint) : void
      {
         this.data.push({
            "k":[],
            "m":param1,
            "n":0
         });
      }
      
      public function hideTarget(param1:uint, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object;
         (_loc4_ = this.getKeyframe(param1,param2)).d.hh = !!param3 ? 1 : 0;
         this.redraw();
      }
      
      public function getModes() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.data)
         {
            _loc1_.push(_loc2_.m);
         }
         return _loc1_;
      }
      
      public function getFirstMode() : int
      {
         if(this.data.length == 0)
         {
            return -1;
         }
         return this.data[0].m;
      }
      
      public function isEmpty(param1:int = -1) : Boolean
      {
         if(param1 > -1)
         {
            return this.map[param1] == null;
         }
         return this.data.length == 0;
      }
      
      public function setLength(param1:uint) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.data)
         {
            _loc2_.n = param1;
         }
         this.remap();
      }
      
      public function autoScale(param1:uint, param2:Channel) : void
      {
         var _loc3_:uint = Animation.MODE_DEFAULT;
         this.requireMode(_loc3_);
         var _loc4_:Object;
         var _loc5_:Number = (_loc4_ = param2.getKeyframe(_loc3_,param2.getFrame(_loc3_,param1,BACK))).d.z;
         var _loc6_:Object;
         var _loc7_:Number = (_loc6_ = param2.getKeyframe(_loc3_,param1)).d.z;
         var _loc8_:Object;
         var _loc9_:Number = (_loc8_ = this.getKeyframe(_loc3_,this.getFrame(_loc3_,param1,BACK))).d.sz;
         var _loc10_:Object;
         (_loc10_ = this.getKeyframe(_loc3_,param1)).d.sz = _loc9_ * _loc5_ / _loc7_;
         this.updateScene(param1);
      }
   }
}
