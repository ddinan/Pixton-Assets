package com.pixton.character
{
   import com.pixton.characterSkin.Look;
   import com.pixton.editor.Character;
   import com.pixton.editor.FX;
   import com.pixton.editor.Globals;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Picker;
   import com.pixton.editor.SkinManager;
   import com.pixton.editor.Utils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Video;
   
   public final class BodyPart
   {
      
      private static const BIAS_PROBABILITY:Number = 0.9;
      
      private static var pivotOrig:Object;
       
      
      public var target:MovieClip;
      
      public var numExpressions:uint = 0;
      
      public var skinType:uint;
      
      public var video:Video;
      
      var turnPos:int;
      
      var invisible:Boolean = false;
      
      private var variants:Array;
      
      private var currentLook:uint;
      
      private var currentExpression:uint;
      
      private var hotspot:MovieClip;
      
      private var rgbColor:Array;
      
      private var _flippedX:Boolean = false;
      
      private var _flippedY:Boolean = false;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _yStretch:Number = 1;
      
      private var pivots:Object;
      
      private var pivotPos:Object;
      
      private var map:Object;
      
      private var alwaysInFront:Array;
      
      private var rotateHere:MovieClip;
      
      private var turnHere:MovieClip;
      
      private var _photo:MovieClip;
      
      private var _char:Character;
      
      private var _ready:Boolean = false;
      
      public function BodyPart(param1:MovieClip, param2:uint, param3:int, param4:Object = null, param5:Character = null, param6:Boolean = false)
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:BodyPartLook = null;
         var _loc12_:MovieClip = null;
         var _loc13_:BodyPartLook = null;
         super();
         this.target = param1;
         this.skinType = param2;
         this.turnPos = param3;
         this._char = param5;
         this._scaleX = param1.scaleX;
         this._scaleY = param1.scaleY;
         this.rgbColor = [];
         this.variants = [];
         this.pivots = {};
         this.pivotPos = {};
         if(param1._ == null)
         {
            _loc10_ = [];
            _loc8_ = param1.numChildren;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc9_ = param1.getChildAt(_loc7_);
               _loc10_.push(_loc9_);
               _loc7_++;
            }
            param1._ = _loc10_;
         }
         this.map = {};
         this.alwaysInFront = [];
         if(pivotOrig == null)
         {
            pivotOrig = {};
         }
         if(pivotOrig[param2] == null)
         {
            pivotOrig[param2] = [];
         }
         if(pivotOrig[param2][param3] == null)
         {
            pivotOrig[param2][param3] = {};
         }
         for each(_loc9_ in param1._)
         {
            if(_loc9_.name != null && !(_loc9_ is Shape) && !(_loc9_ is Look))
            {
               this.map[_loc9_.name] = _loc9_;
            }
            if(_loc9_ is MovieClip)
            {
               if(_loc9_ is Look)
               {
                  _loc11_ = new BodyPartLook(_loc9_ as MovieClip);
                  this.variants.push(_loc11_);
               }
               else if(_loc9_.name == "hotspot")
               {
                  this.hotspot = _loc9_ as MovieClip;
                  this.concealHotspot();
               }
               else if(!(Utils.startsWith(_loc9_.name,"anchor") || Utils.startsWith(_loc9_.name,"drawing")))
               {
                  if(_loc9_.name == "rotateHere")
                  {
                     this.rotateHere = _loc9_ as MovieClip;
                  }
                  else if(_loc9_.name == "turnHere")
                  {
                     this.turnHere = _loc9_ as MovieClip;
                  }
                  else
                  {
                     this.pivots[_loc9_.name] = _loc9_;
                     if(pivotOrig[param2][param3][_loc9_.name] == null)
                     {
                        pivotOrig[param2][param3][_loc9_.name] = new Point(_loc9_.x,_loc9_.y);
                     }
                     this.pivotPos[_loc9_.name] = pivotOrig[param2][param3][_loc9_.name];
                  }
               }
            }
         }
         if(param4 == null)
         {
            this.look = 0;
            this.expression = 0;
         }
         else if(param4 is BodyPart)
         {
            this.look = BodyPart(param4).look;
            this.expression = BodyPart(param4).expression;
            this.setColor(BodyPart(param4).getColor(0),0);
            this.setColor(BodyPart(param4).getColor(1),1);
            this.setColor(BodyPart(param4).getColor(2),2);
            this.setColor(BodyPart(param4).getColor(3),3);
            this.setColor(BodyPart(param4).getColor(4),4);
            this.setColor(BodyPart(param4).getColor(5),5);
            if(param5.skinType == 101)
            {
               this.setColor(BodyPart(param4).getColor(6),6);
               this.setColor(BodyPart(param4).getColor(7),7);
               this.setColor(BodyPart(param4).getColor(8),8);
               this.setColor(BodyPart(param4).getColor(9),9);
               this.setColor(BodyPart(param4).getColor(10),10);
               this.setColor(BodyPart(param4).getColor(11),11);
               this.setColor(BodyPart(param4).getColor(12),12);
               this.setColor(BodyPart(param4).getColor(13),13);
               this.setColor(BodyPart(param4).getColor(14),14);
               this.setColor(BodyPart(param4).getColor(15),15);
               this.setColor(BodyPart(param4).getColor(16),16);
               this.setColor(BodyPart(param4).getColor(17),17);
            }
         }
         if(param6)
         {
            this.hideExtra();
         }
         if(this.variants.length > 0)
         {
            this.numExpressions = 0;
            for each(_loc13_ in this.variants)
            {
               this.numExpressions = Math.max(this.numExpressions,_loc13_.getNum());
            }
         }
         if(!param1.drawing)
         {
            (_loc12_ = new MovieClip()).name = "drawing";
            _loc12_.mouseEnabled = false;
            _loc12_.mouseChildren = false;
            param1.addChild(_loc12_);
            param1.drawing = _loc12_;
         }
         if(param1.turnHere != null)
         {
            this.turnHere = param1.turnHere;
         }
         if(param1.photo != null)
         {
            this._photo = param1.photo;
            this._photo.visible = false;
         }
         if(param1.drawing2 && param1.getChildIndex(param1.drawing2) > 0)
         {
            this.alwaysInFront.push(param1.drawing2);
         }
         if(param1.getChildIndex(param1.drawing) > 0)
         {
            this.alwaysInFront.push(param1.drawing);
         }
         this._ready = true;
      }
      
      public function getDrawing(param1:uint) : MovieClip
      {
         var _loc2_:BodyPartLook = null;
         var _loc4_:MovieClip = null;
         var _loc3_:String = "drawing" + (param1 == 0 ? "" : param1);
         if(this.variants[this.currentLook] != null)
         {
            _loc2_ = BodyPartLook(this.variants[this.currentLook]);
            if(_loc2_[_loc3_] != null)
            {
               return _loc2_[_loc3_];
            }
         }
         if(param1 > 2 && this.target[_loc3_] == null)
         {
            (_loc4_ = new MovieClip()).name = _loc3_;
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            this.target.addChild(_loc4_);
            this.target[_loc3_] = _loc4_;
         }
         return this.target[_loc3_];
      }
      
      private function updateDisplayOrder() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = this.alwaysInFront.length;
         while(_loc2_ < _loc1_)
         {
            Utils.rearrange(this.alwaysInFront[_loc2_] as MovieClip,true,1);
            _loc2_++;
         }
      }
      
      public function get onTop() : Boolean
      {
         if(this.variants[this.currentLook])
         {
            return BodyPartLook(this.variants[this.currentLook]).onTop;
         }
         return false;
      }
      
      public function get onBottom() : Boolean
      {
         return BodyPartLook(this.variants[this.currentLook]).onBottom;
      }
      
      function get isLong() : Boolean
      {
         return BodyPartLook(this.variants[this.currentLook]).isLong;
      }
      
      private function loadImage() : void
      {
         if(!this._ready || this._char == null || Character(this._char).dummy || this.variants[this.currentLook] == null)
         {
            return;
         }
         var _loc1_:BodyPartLook = this.variants[this.currentLook] as BodyPartLook;
         _loc1_.loadImage(this.skinType,this.target.name,this.currentLook);
      }
      
      public function getTexture() : DisplayObject
      {
         return BodyPartLook(this.variants[this.currentLook]).getTexture();
      }
      
      public function hasImages() : Boolean
      {
         return BodyPartLook(this.variants[this.currentLook]).hasImages();
      }
      
      public function get look() : uint
      {
         return this.currentLook;
      }
      
      function shouldTurn(param1:Point) : Boolean
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(this.turnHere == null || this.rotateHere == null)
         {
            return false;
         }
         _loc2_ = this.turnHere.parent.localToGlobal(new Point(this.turnHere.x,this.turnHere.y));
         _loc3_ = this.rotateHere.parent.localToGlobal(new Point(this.rotateHere.x,this.rotateHere.y));
         return Point.distance(param1,_loc2_) < Point.distance(param1,_loc3_);
      }
      
      function setYStretch(param1:Number) : void
      {
         this._yStretch = Utils.limit(param1,0.2,1);
      }
      
      function getYStretch() : Number
      {
         return this._yStretch;
      }
      
      function setYOff(param1:Number) : void
      {
         if(!(this.variants.length == 0 || this.variants[this.currentLook] == null))
         {
            BodyPartLook(this.variants[this.currentLook]).setYOff(param1);
         }
      }
      
      function getYOffset() : Number
      {
         if(this.variants.length == 0 || this.variants[this.currentLook] == null)
         {
            return 0;
         }
         return BodyPartLook(this.variants[this.currentLook]).getYOffset();
      }
      
      public function getAnchor(param1:String, param2:Boolean = false) : MovieClip
      {
         if(this.map[param1] == null)
         {
            if(this.variants[this.currentLook] == null)
            {
               return null;
            }
            return BodyPartLook(this.variants[this.currentLook]).getAnchor(param1,param2);
         }
         if(param2 && this.map[param1].parent == null)
         {
            this.target.addChild(this.map[param1]);
         }
         return this.map[param1];
      }
      
      public function set look(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Boolean = false;
         var _loc4_:uint = this.variants.length;
         if(param1 > 0 && !(Picker.isVisible() && Picker.type == Globals.LOOKS) && Globals.isLocked(BodyParts.getLock(this.skinType,this,Globals.LOOKS,param1)))
         {
            if(this.target.__name == "hair" || this.target.__name == "hairBehind")
            {
               switch(param1)
               {
                  case 40:
                     param1 = 2;
                     break;
                  case 41:
                     param1 = 38;
                     break;
                  case 42:
                     param1 = 9;
                     break;
                  case 43:
                     param1 = 10;
                     break;
                  case 44:
                     param1 = 32;
                     break;
                  case 45:
                     param1 = 12;
                     break;
                  case 46:
                     param1 = 31;
                     break;
                  case 47:
                     param1 = 23;
                     break;
                  case 48:
                     param1 = 12;
                     break;
                  case 49:
                     param1 = 19;
                     break;
                  case 50:
                     param1 = 39;
                     break;
                  case 51:
                     param1 = 34;
                     break;
                  case 52:
                     param1 = 36;
                     break;
                  case 53:
                     param1 = 24;
                     break;
                  case 54:
                     param1 = 37;
                     break;
                  case 55:
                     param1 = 38;
                     break;
                  case 56:
                     param1 = 36;
                     break;
                  default:
                     _loc2_ = true;
               }
            }
            else
            {
               _loc2_ = true;
            }
            if(_loc2_)
            {
               return;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(BodyPartLook(this.variants[_loc3_]).target.parent == null)
            {
               if(_loc3_ == param1)
               {
                  this.target.addChild(BodyPartLook(this.variants[_loc3_]).target);
               }
            }
            else if(_loc3_ != param1)
            {
               this.target.removeChild(BodyPartLook(this.variants[_loc3_]).target);
            }
            _loc3_++;
         }
         this.updateDisplayOrder();
         this.currentLook = param1;
         this.invisible = false;
         if(this.hotspot != null)
         {
            this.hotspot.visible = false;
            if(this.blankPart())
            {
               this.hotspot.visible = true;
               this.invisible = true;
            }
         }
         this.loadImage();
      }
      
      public function blankPart() : Boolean
      {
         if(this.invisible || this.variants[this.currentLook] == null)
         {
            return true;
         }
         var _loc1_:MovieClip = BodyPartLook(this.variants[this.currentLook]).target;
         var _loc2_:Rectangle = _loc1_.getBounds(_loc1_.parent);
         return _loc2_.width == 0 || _loc2_.height == 0;
      }
      
      public function get expression() : uint
      {
         return this.currentExpression;
      }
      
      public function set expression(param1:uint) : void
      {
         var _loc2_:BodyPartLook = null;
         if(param1 > 0 && !Picker.isVisible() && Globals.isLocked(BodyParts.getLock(this.skinType,this,Globals.EXPRESSION,param1)))
         {
            return;
         }
         for each(_loc2_ in this.variants)
         {
            _loc2_.expression = param1;
         }
         this.currentExpression = param1;
      }
      
      public function setRotation(param1:Object, param2:Number) : Number
      {
         if(param1.rMin != null && param1.rMax != null)
         {
            param2 = Utils.limit(param2,param1.rMin,param1.rMax);
         }
         return param2;
      }
      
      function isVariable() : Boolean
      {
         return this.variants.length > 1;
      }
      
      function isExpressive() : Boolean
      {
         if(this.variants.length == 0 || this.blankPart())
         {
            return false;
         }
         return this.hasPhoto() || BodyPartLook(this.variants[0]).isVariable();
      }
      
      function isMovable() : Boolean
      {
         if(this.variants.length == 0 || this.variants[this.currentLook] == null)
         {
            return false;
         }
         return BodyPartLook(this.variants[this.currentLook]).isMovable();
      }
      
      function saveMovablePos() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.variants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            BodyPartLook(this.variants[_loc1_]).saveMovablePos();
            _loc1_++;
         }
      }
      
      function getMovablePos() : Object
      {
         return BodyPartLook(this.variants[this.currentLook]).getMovablePos();
      }
      
      public function setMovablePos(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this.variants.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            BodyPartLook(this.variants[_loc2_]).setMovablePos(param1);
            _loc2_++;
         }
      }
      
      function flipMovable() : void
      {
         BodyPartLook(this.variants[this.currentLook]).flipMovable();
      }
      
      function updateMovable(param1:Point, param2:Point, param3:Object = null) : void
      {
         BodyPartLook(this.variants[this.currentLook]).updateMovable(param1,param2,param3);
      }
      
      public function randomize(param1:uint, param2:Boolean = false, param3:uint = 0) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(isNaN(param3))
         {
            param3 = 0;
         }
         switch(param1)
         {
            case BodyParts.EXPRESSION:
               this.expression = Math.floor(Math.random() * this.numExpressions);
               break;
            case BodyParts.LOOKS:
               if(param2 || Utils.inArray(this.target.__name,SkinManager.getInfo(this.skinType).biasedParts) && Math.random() < BIAS_PROBABILITY)
               {
                  this.look = param3;
               }
               else
               {
                  _loc4_ = SkinManager.getInfo(this.skinType).randomLooks;
                  _loc5_ = BodyParts.simplifyPartName(this.target.__name);
                  if(_loc4_ == null || _loc4_[_loc5_] == null)
                  {
                     this.look = Math.floor(Math.random() * this.variants.length);
                  }
                  else
                  {
                     this.look = _loc4_[_loc5_][Math.floor(Math.random() * _loc4_[_loc5_].length)];
                  }
               }
         }
      }
      
      function setColor(param1:Array, param2:uint = 0) : void
      {
         var _loc3_:uint = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc4_:uint = this.variants.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            BodyPartLook(this.variants[_loc3_]).setColor(param1,param2);
            _loc3_++;
         }
         this.rgbColor[param2] = param1;
      }
      
      function getColor(param1:uint = 0) : Array
      {
         if(this.rgbColor[param1] == null)
         {
            return null;
         }
         return this.rgbColor[param1];
      }
      
      function revealHotspot(param1:Array) : void
      {
         if(Utils.SCREEN_CAPTURE_MODE)
         {
            return;
         }
         FX.glow(this.target);
         if(this.hotspot == null || !this.hotspot.visible)
         {
            Utils.setColor(this.target,param1,1 - (!!Utils.SCREEN_CAPTURE_MODE ? 0 : Globals.HIGHLIGHTING_ALPHA),true);
         }
         else
         {
            Utils.setColor(this.hotspot,param1,0,false,0.4);
            this.hotspot.mouseEnabled = true;
            this.hotspot.mouseChildren = true;
         }
      }
      
      function concealHotspot() : void
      {
         FX.glow(this.target,0);
         if(this.hotspot == null || !this.hotspot.visible)
         {
            Utils.setColor(this.target);
         }
         else
         {
            Utils.setColor(this.hotspot);
            this.hotspot.alpha = 0;
            this.hotspot.mouseEnabled = false;
            this.hotspot.mouseChildren = false;
         }
      }
      
      function show(param1:Boolean) : void
      {
         var _loc2_:BodyPartLook = null;
         for each(_loc2_ in this.variants)
         {
            _loc2_.show(param1);
         }
      }
      
      function showSpecial(param1:Boolean) : void
      {
         var _loc2_:BodyPartLook = null;
         for each(_loc2_ in this.variants)
         {
            _loc2_.showSpecial(param1);
         }
      }
      
      public function get numLooks() : uint
      {
         return this.variants.length;
      }
      
      public function set flippedX(param1:Boolean) : void
      {
         this._flippedX = param1;
         this.updateScale();
      }
      
      public function get flippedX() : Boolean
      {
         return this._flippedX;
      }
      
      public function set flippedY(param1:Boolean) : void
      {
         this._flippedY = param1;
         this.updateScale();
      }
      
      public function get flippedY() : Boolean
      {
         return this._flippedY;
      }
      
      function invert(param1:Boolean = false) : void
      {
         Utils.setColor(this.target,!!param1 ? Palette.WHITE : null);
      }
      
      function nudgePivot(param1:String, param2:Object, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = param2.x == null ? Number(0) : Number(param2.x);
         var _loc6_:Number = param2.y == null ? Number(0) : Number(param2.y);
         var _loc7_:DisplayObject;
         var _loc8_:Point = (_loc7_ = this.pivots[param1] as DisplayObject).parent.localToGlobal(this.pivotPos[param1]);
         _loc8_.x += param3;
         _loc8_.y += param4;
         _loc8_ = _loc7_.parent.globalToLocal(_loc8_);
         if(!(param2.x == null && param2.linkXY && param1.match(/[1-2]$/)))
         {
            _loc8_.x = Utils.limit(_loc8_.x,pivotOrig[this.skinType][this.turnPos][param1].x - _loc5_,pivotOrig[this.skinType][this.turnPos][param1].x + _loc5_);
         }
         _loc8_.y = Utils.limit(_loc8_.y,pivotOrig[this.skinType][this.turnPos][param1].y - _loc6_,pivotOrig[this.skinType][this.turnPos][param1].y + _loc6_);
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
      }
      
      function updatePivot(param1:String) : void
      {
         if(this.pivots[param1] == null)
         {
            return;
         }
         this.pivotPos[param1] = new Point(this.pivots[param1].x,this.pivots[param1].y);
      }
      
      function getPivotData(param1:String) : Array
      {
         if(this.pivots[param1] == null)
         {
            return [];
         }
         return [this.pivots[param1].x - pivotOrig[this.skinType][this.turnPos][param1].x,this.pivots[param1].y - pivotOrig[this.skinType][this.turnPos][param1].y];
      }
      
      function setPivotValue(param1:String, param2:String, param3:Number) : void
      {
         if(param1 == null || this.pivots[param1] == null)
         {
            return;
         }
         this.pivots[param1][param2] = param3;
         this.updatePivot(param1);
      }
      
      function setPivotData(param1:String, param2:Array, param3:Boolean = true) : void
      {
         if(param1 == null || this.pivots[param1] == null || param2 == null)
         {
            return;
         }
         var _loc4_:Number = !!this.isTurnedAway() ? Number(-1) : Number(1);
         if(param3)
         {
            if(!isNaN(param2[0]) && !isNaN(param2[1]))
            {
               this.pivots[param1].x = pivotOrig[this.skinType][this.turnPos][param1].x + param2[0] * _loc4_;
               this.pivots[param1].y = pivotOrig[this.skinType][this.turnPos][param1].y + param2[1];
            }
         }
         else
         {
            this.pivots[param1].x = param2[0];
            this.pivots[param1].y = param2[1];
         }
         this.updatePivot(param1);
      }
      
      function randomizePivot(param1:String, param2:Object, param3:Boolean) : void
      {
         var _loc4_:Number = pivotOrig[this.skinType][this.turnPos][param1].x;
         var _loc5_:Number = pivotOrig[this.skinType][this.turnPos][param1].y;
         if(param2.x != null)
         {
            _loc4_ += Utils.normalize(-param2.x,param2.x);
         }
         if(param2.y != null)
         {
            _loc5_ += Utils.normalize(-param2.y,param2.y);
         }
         this.setPivotData(param1,[_loc4_,_loc5_],param3);
      }
      
      function leaveUsed() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.variants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
         }
         if(this.hotspot != null)
         {
            this.hotspot.parent.removeChild(this.hotspot);
         }
      }
      
      function set scaleX(param1:Number) : void
      {
         this._scaleX = param1;
         this.updateScale();
      }
      
      function set scaleY(param1:Number) : void
      {
         this._scaleY = param1;
         this.updateScale();
      }
      
      function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      function getTarget() : DisplayObject
      {
         return BodyPartLook(this.variants[this.currentLook]).target;
      }
      
      public function getTargetName() : String
      {
         return this.target.__name;
      }
      
      function getPivot(param1:String) : DisplayObject
      {
         return BodyPartLook(this.variants[this.currentLook]).getPivot(param1);
      }
      
      function isFixed() : Boolean
      {
         return this.variants[this.currentLook] && BodyPartLook(this.variants[this.currentLook]).isFixed();
      }
      
      private function updateScale() : void
      {
         var _loc1_:uint = 0;
         this.target.scaleX = this._scaleX * (!!this._flippedX ? -1 : 1);
         this.target.scaleY = this._scaleY * (!!this._flippedY ? -1 : 1);
         var _loc2_:uint = this.variants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            BodyPartLook(this.variants[_loc1_]).updateScale(this.target.scaleX,this.target.scaleY);
            _loc1_++;
         }
         if(BodyParts._get(this.skinType,"scaleMovables") === false)
         {
            BodyPartLook(this.variants[this.currentLook]).updateMovableScale(1 / this._scaleX);
         }
      }
      
      function getMasks() : Array
      {
         if(this.variants[this.currentLook] == null)
         {
            return null;
         }
         return BodyPartLook(this.variants[this.currentLook]).maskers;
      }
      
      public function isFlippedTurn() : Boolean
      {
         return this.turnPos > BodyParts.TURNED_AWAY;
      }
      
      public function isTurnedAway() : Boolean
      {
         return Utils.inArray(this.turnPos,[2,3,4]);
      }
      
      public function cull() : void
      {
         if(this.variants.length > 0 && this.variants[this.currentLook] != null)
         {
            BodyPartLook(this.variants[this.currentLook]).cull();
         }
      }
      
      private function hideExtra() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.variants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            BodyPartLook(this.variants[_loc1_]).hideExtra();
            _loc1_++;
         }
      }
      
      function hasPhoto() : Boolean
      {
         return this.getPhoto() != null;
      }
      
      public function getPhoto() : MovieClip
      {
         if(this.variants[this.currentLook] != null)
         {
            return BodyPartLook(this.variants[this.currentLook]).photo;
         }
         return this._photo;
      }
      
      public function setLineAlpha(param1:Number) : void
      {
         var _loc2_:BodyPartLook = null;
         for each(_loc2_ in this.variants)
         {
            _loc2_.setLineAlpha(param1);
         }
      }
   }
}
