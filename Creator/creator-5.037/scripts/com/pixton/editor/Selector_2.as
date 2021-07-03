package com.pixton.editor
{
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class Selector extends MovieClip
   {
      
      public static var PADDING:Number = 5;
       
      
      public var target:Object;
      
      public var border:MovieClip;
      
      public var rotateSE:HandleRotate;
      
      public var rotateSW:HandleRotate;
      
      public var rotateNE:HandleRotate;
      
      public var rotateNW:HandleRotate;
      
      public var resizeN:HandleRotate;
      
      public var resizeS:HandleRotate;
      
      public var resizeE:HandleRotate;
      
      public var resizeW:HandleRotate;
      
      public var resizerH:Resizer;
      
      public var resizerV:Resizer;
      
      public var remove:MovieClip;
      
      public var attach:MovieClip;
      
      public var btnPlay:MovieClip;
      
      public var btnLink:MovieClip;
      
      public var btnDelete:MovieClip;
      
      public var btnVideo:MovieClip;
      
      private var canResize:Boolean = false;
      
      private var moveStart:Point;
      
      private var startPoint:Object;
      
      private var activeHandle:HandleRotate;
      
      private var _zoomed:Boolean = false;
      
      private var attaching:Boolean = false;
      
      private var buttons:Array;
      
      public function Selector()
      {
         super();
         Utils.useHand(this.attach);
         Utils.useHand(this.remove);
         Utils.useHand(this.btnPlay);
         Utils.useHand(this.btnLink);
         Utils.useHand(this.btnDelete);
         Utils.useHand(this.btnVideo);
         this.buttons = [this.btnPlay,this.btnDelete,this.btnVideo,this.btnLink];
         this.resizeN.visible = false;
         this.resizeS.visible = false;
         this.resizeE.visible = false;
         this.resizeW.visible = false;
         this.rotateSW.visible = false;
         this.rotateNE.visible = false;
         this.rotateSE.visible = false;
         this.rotateNW.visible = false;
         this.resizerH.visible = false;
         this.resizerV.visible = false;
         this.reset();
      }
      
      public static function init() : void
      {
      }
      
      private function reset() : void
      {
         this.rotatable = false;
         this.resizableCharacter = false;
         this.resizableAsset = false;
         this.removable = false;
         this.videoable = false;
         visible = false;
      }
      
      public function setTarget(param1:Object = null) : void
      {
         if(this.target && param1 != this.target && this.target is Moveable)
         {
            Moveable(this.target).onSelect(false);
         }
         if(this.target == param1 && !(param1 is Array))
         {
            return;
         }
         this.target = param1;
         if(param1 == null)
         {
            this.reset();
         }
         else
         {
            this.updatePosition();
         }
         if(Template.isActive() && param1 && param1 is Dialog && Dialog(param1).isEmpty() && Editor.self.mode != Editor.MODE_EXPR)
         {
            Editor.self.mode = Editor.MODE_EXPR;
         }
         if(param1 && param1 is Moveable)
         {
            Moveable(param1).onSelect();
         }
      }
      
      public function updateColor() : void
      {
         Utils.setColor(this.btnPlay.bkgd,Palette.colorLink);
         Utils.setColor(this.btnPlay.icon,Palette.colorBkgd);
         Utils.setColor(this.btnLink.bkgd,Palette.colorLink);
         Utils.setColor(this.btnLink.icon,Palette.colorBkgd);
         Utils.setColor(this.btnDelete.bkgd,Palette.colorLink);
         Utils.setColor(this.btnDelete.icon,Palette.colorBkgd);
         Utils.setColor(this.btnVideo.bkgd,Palette.colorLink);
         Utils.setColor(this.btnVideo.icon,Palette.colorBkgd);
      }
      
      public function updateIfMatches(param1:MovieClip) : void
      {
         if(param1 == this.target)
         {
            this.updatePosition();
         }
      }
      
      public function updatePosition() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Point = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:MovieClip = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Rectangle = null;
         var _loc11_:Object = null;
         var _loc6_:Graphics;
         (_loc6_ = this.graphics).clear();
         if(this.target is Array)
         {
            _loc3_ = this.target[0];
            _loc4_ = 1;
            _loc5_ = 1;
            _loc1_ = Utils.getBounds(this.target as Array);
            _loc2_ = parent.globalToLocal(_loc3_.parent.localToGlobal(new Point(_loc1_.x,_loc1_.y)));
            rotation = _loc3_.parent.parent.rotation;
            this.border.x = 0;
            this.border.y = 0;
            for each(_loc11_ in this.target)
            {
               _loc10_ = _loc11_.getBounds(this);
               _loc6_.lineStyle(1,Palette.rgb2hex(Editor.COLOR[Editor.MODE_MOVE]),1,false,LineScaleMode.NONE);
               _loc6_.moveTo(_loc10_.x,_loc10_.y);
               _loc6_.lineTo(_loc10_.bottomRight.x,_loc10_.y);
               _loc6_.lineTo(_loc10_.bottomRight.x,_loc10_.bottomRight.y);
               _loc6_.lineTo(_loc10_.x,_loc10_.bottomRight.y);
               _loc6_.lineTo(_loc10_.x,_loc10_.y);
            }
         }
         else
         {
            _loc3_ = this.target;
            if(this.target is Asset)
            {
               _loc4_ = _loc3_.scaleX * _loc3_.flipX;
               _loc5_ = _loc3_.scaleY * _loc3_.flipY;
            }
            else
            {
               _loc4_ = _loc3_.scaleX;
               _loc5_ = _loc3_.scaleY;
            }
            _loc1_ = this.target.getSelectableRect();
            _loc2_ = parent.globalToLocal(this.target.parent.localToGlobal(new Point(this.target.x,this.target.y)));
            if(this.target is Dialog && !Dialog(this.target).isProp())
            {
               rotation = _loc3_.rotation;
            }
            else
            {
               rotation = _loc3_.rotation + _loc3_.parent.parent.rotation;
            }
            if(_loc3_.scaleX > 0)
            {
               this.border.x = _loc1_.x * _loc3_.parent.scaleX * _loc4_ - PADDING;
            }
            else
            {
               this.border.x = -(_loc1_.x + _loc1_.width) * _loc3_.parent.scaleX * _loc4_ - PADDING;
            }
            if(_loc3_.scaleY > 0)
            {
               this.border.y = _loc1_.y * _loc3_.parent.scaleY * _loc5_ - PADDING - (this.target is Character ? PADDING : 0);
            }
            else
            {
               this.border.y = -(_loc1_.y + _loc1_.height) * _loc3_.parent.scaleY * _loc5_ - PADDING;
            }
         }
         if(_loc1_.width == 0 || _loc1_.height == 0)
         {
            this.visible = false;
            return;
         }
         x = _loc2_.x;
         y = _loc2_.y;
         this.border.width = _loc1_.width * _loc3_.parent.scaleX * _loc4_ + PADDING * 2;
         this.border.height = _loc1_.height * _loc3_.parent.scaleY * _loc5_ + PADDING * 2;
         this.mouseEnabled = true;
         this.mouseChildren = this.mouseEnabled;
         if(this.target is Dialog && !Dialog(this.target).isProp())
         {
            if(this.attach.visible && !this.attaching)
            {
               if(Dialog(this.target).target != null)
               {
                  Utils.matchPosition(this.attach,Dialog(this.target).getSpikePos());
               }
               else
               {
                  Utils.matchPosition(this.attach,Dialog(this.target).getAttachPos());
               }
            }
            this.attach.alpha = this.attaching || Template.isActive() ? Number(0) : Number(1);
            this.border.alpha = !!this.attaching ? Number(0) : Number(1);
            this.resizeN.alpha = this.attach.alpha;
            this.resizeS.alpha = this.attach.alpha;
            this.resizeE.alpha = this.attach.alpha;
            this.resizeW.alpha = this.attach.alpha;
            this.rotateNW.alpha = this.attach.alpha;
            this.rotateNE.alpha = this.attach.alpha;
            this.rotateSE.alpha = this.attach.alpha;
            this.rotateSW.alpha = this.attach.alpha;
            if(this.remove.visible)
            {
               this.remove.alpha = !!Template.isActive() ? Number(0) : Number(1);
               if(Dialog(this.target).target is Photo)
               {
                  Utils.matchPosition(this.remove,this.attach);
                  this.remove.x += 16;
                  this.remove.y += 16;
               }
               else
               {
                  Utils.matchPosition(this.remove,Dialog(this.target).getRemovePos());
               }
            }
         }
         else if(Template.isActive())
         {
            this.attach.alpha = 0;
            this.resizeN.alpha = Editor.self.currentTarget is Prop ? Number(1) : Number(0);
            this.resizeS.alpha = this.attach.alpha;
            this.resizeE.alpha = this.attach.alpha;
            this.resizeW.alpha = this.attach.alpha;
            this.rotateNW.alpha = this.attach.alpha;
            this.rotateNE.alpha = this.attach.alpha;
            this.rotateSE.alpha = Editor.self.currentTarget is Prop ? Number(1) : Number(0);
            this.rotateSW.alpha = this.attach.alpha;
         }
         _loc1_ = this.border.getRect(this);
         this.rotateNE.x = _loc1_.bottomRight.x;
         this.rotateNE.y = _loc1_.topLeft.y;
         this.rotateSE.x = _loc1_.bottomRight.x;
         this.rotateSE.y = _loc1_.bottomRight.y;
         this.rotateSW.x = _loc1_.topLeft.x;
         this.rotateSW.y = _loc1_.bottomRight.y;
         this.rotateNW.x = _loc1_.topLeft.x;
         this.rotateNW.y = _loc1_.topLeft.y;
         this.resizeN.x = Math.round((this.rotateNW.x + this.rotateNE.x) * 0.5);
         this.resizeN.y = this.rotateNE.y;
         this.resizeS.x = this.resizeN.x;
         this.resizeS.y = this.rotateSE.y;
         this.resizeE.x = this.rotateNE.x;
         this.resizeE.y = Math.round((this.rotateNW.y + this.rotateSW.y) * 0.5);
         this.resizeW.x = this.rotateNW.x;
         this.resizeW.y = this.resizeE.y;
         var _loc7_:Number = this.resizeE.x - 11;
         for each(_loc8_ in this.buttons)
         {
            if(_loc8_.visible)
            {
               _loc8_.x = _loc7_;
               _loc8_.y = this.resizeS.y - 11;
               _loc7_ -= 19;
            }
         }
         _loc9_ = Editor.self.customBorder.getBounds(stage);
         Utils.keepInside([this.rotateNE,this.rotateSW,this.rotateNW,this.rotateSE],_loc9_);
         Utils.keepInside([this.resizeN,this.resizeS,this.resizeE,this.resizeW],_loc9_);
         Utils.keepInside(this.attach,_loc9_);
         Utils.keepInside(this.remove,_loc9_);
         Utils.keepInside(this.btnPlay,_loc9_);
         Utils.keepInside(this.btnDelete,_loc9_);
         Utils.keepInside(this.btnVideo,_loc9_);
         Utils.keepInside(this.btnLink,_loc9_);
         this.resizerH.x = this.rotateSE.x;
         this.resizerH.y = this.rotateNE.y;
         this.resizerV.x = this.rotateNW.x;
         this.resizerV.y = this.rotateNE.y;
         this.resizerH.setHeight(this.border.height);
         this.resizerV.setHeight(this.border.width);
         visible = true;
      }
      
      private function updateResizeAsset(param1:PixtonEvent) : void
      {
         if(param1.currentTarget && param1.currentTarget.alpha == 0)
         {
            return;
         }
         if(param1.value == null)
         {
            this.target.size = 1;
         }
         else
         {
            this.target.size = param1.value.size;
         }
         if(this.target is Dialog)
         {
            Dialog(this.target).redraw();
         }
         this.updatePosition();
      }
      
      private function updateRotate(param1:PixtonEvent) : void
      {
         if(param1.currentTarget && param1.currentTarget.alpha == 0)
         {
            return;
         }
         if(this.target is Dialog && !Dialog(this.target).isProp() && Dialog(this.target).isUnicode())
         {
            this.target.rotation = 0;
         }
         else if(param1.value == null)
         {
            this.target.rotation = Math.round(this.target.rotation / Utils.SNAP_ANGLE) * Utils.SNAP_ANGLE;
         }
         else
         {
            this.target.rotation = param1.value.r;
         }
         this.updatePosition();
         dispatchEvent(new PixtonEvent(PixtonEvent.MOVE_TARGET,this.target));
      }
      
      public function set movable(param1:Boolean) : void
      {
         if(param1)
         {
            Utils.addListener(this.border,MouseEvent.MOUSE_DOWN,this.startMove,true);
         }
         else
         {
            Utils.removeListener(this.border,MouseEvent.MOUSE_DOWN,this.startMove);
         }
         buttonMode = param1;
         useHandCursor = param1;
      }
      
      public function set zable(param1:Boolean) : void
      {
         if(param1)
         {
            Utils.addListener(this.border,MouseEvent.MOUSE_DOWN,this.startZ,true);
         }
         else
         {
            Utils.removeListener(this.border,MouseEvent.MOUSE_DOWN,this.startZ);
         }
         buttonMode = param1;
         useHandCursor = param1;
      }
      
      public function set playable(param1:Boolean) : void
      {
         this.btnPlay.visible = param1 && Main.canUploadSound() && Globals.isFullVersion() && Dialog(this.target).hasSound();
         this.btnDelete.visible = this.btnPlay.visible;
         if(this.btnPlay.visible)
         {
            Utils.addListener(this.btnPlay,MouseEvent.CLICK,this.onButton,true);
            Utils.addListener(this.btnDelete,MouseEvent.CLICK,this.onButton,true);
         }
         else
         {
            Utils.removeListener(this.btnPlay,MouseEvent.CLICK,this.onButton);
            Utils.removeListener(this.btnDelete,MouseEvent.CLICK,this.onButton);
         }
      }
      
      public function set linkable(param1:Boolean) : void
      {
         this.btnLink.visible = this.target is Dialog && Dialog(this.target).hasLink();
         if(this.btnLink.visible)
         {
            Utils.addListener(this.btnLink,MouseEvent.CLICK,this.onButton,true);
         }
         else
         {
            Utils.removeListener(this.btnLink,MouseEvent.CLICK,this.onButton);
         }
      }
      
      public function get playable() : Boolean
      {
         return this.btnPlay.visible;
      }
      
      public function get linkable() : Boolean
      {
         return this.btnLink.visible;
      }
      
      public function set videoable(param1:Boolean) : void
      {
         this.btnVideo.visible = param1;
         if(this.btnVideo.visible)
         {
            Utils.addListener(this.btnVideo,MouseEvent.CLICK,this.onButton,true);
         }
         else
         {
            Utils.removeListener(this.btnVideo,MouseEvent.CLICK,this.onButton);
            VideoRecorder.hide();
         }
      }
      
      public function get videoable() : Boolean
      {
         return this.btnVideo.visible;
      }
      
      private function onButton(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         switch(evt.currentTarget)
         {
            case this.btnVideo:
               VideoRecorder.show(Character(this.target));
               break;
            case this.btnPlay:
               Sounds.play(Dialog(this.target).getSound());
               break;
            case this.btnDelete:
               Confirm.open("Pixton.comic.confirm",L.text("detach-sound"),function(param1:Boolean):*
               {
                  if(param1)
                  {
                     dispatchEvent(new PixtonEvent(PixtonEvent.DETACH_SOUND,target));
                  }
               });
               break;
            case this.btnLink:
               Main.gotoURL(Dialog(this.target).getLink());
         }
      }
      
      public function set resizableCharacter(param1:Boolean) : void
      {
         this.canResize = param1;
         this.updateResizers();
         if(param1)
         {
            this.resizerH.setTarget(this.target as MovieClip,this.updateResizeCharacter,this.finalizeResizeCharacter);
            this.resizerV.setTarget(this.target as MovieClip,this.updateResizeCharacter,this.finalizeResizeCharacter);
         }
         else
         {
            this.resizerH.setTarget();
            this.resizerV.setTarget();
         }
      }
      
      private function updateResizeCharacter(param1:PixtonEvent) : void
      {
         if(this.target is Character)
         {
            if(param1.target == this.resizerH && Character(this.target).skinType != Globals.CARNIVORE || param1.target == this.resizerV && Character(this.target).skinType == Globals.CARNIVORE)
            {
               if(param1.value == null)
               {
                  Character(this.target).setBodyWidth(1,false);
               }
               else
               {
                  Character(this.target).setBodyWidth(param1.target == this.resizerH ? Number(param1.value.w) : Number(param1.value.h),false);
               }
            }
            else if(param1.target == this.resizerV && Character(this.target).skinType != Globals.CARNIVORE || param1.target == this.resizerH && Character(this.target).skinType == Globals.CARNIVORE)
            {
               if(param1.value == null)
               {
                  Character(this.target).setBodyHeight(1,false);
               }
               else
               {
                  Character(this.target).setBodyHeight(param1.target == this.resizerH ? Number(param1.value.w) : Number(param1.value.h),false);
               }
            }
            Character(this.target).redraw();
         }
         this.updatePosition();
      }
      
      public function startAttach(param1:MouseEvent) : void
      {
         this.attaching = true;
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateAttach);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopAttach);
         this.startPoint = new Point(this.attach.x,this.attach.y);
         this.moveStart = new Point(param1.stageX,param1.stageY);
      }
      
      private function updateAttach(param1:MouseEvent) : void
      {
         this.attach.x = this.startPoint.x + (param1.stageX - this.moveStart.x) / Editor.self.scaleX;
         this.attach.y = this.startPoint.y + (param1.stageY - this.moveStart.y) / Editor.self.scaleY;
         var _loc2_:Point = this.attach.localToGlobal(new Point(0,0));
         Dialog(this.target).drawBubble(_loc2_);
         dispatchEvent(new PixtonEvent(PixtonEvent.MOVE_TARGET,this.target,"attaching"));
      }
      
      private function stopAttach(param1:MouseEvent) : void
      {
         this.attaching = false;
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateAttach);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopAttach);
         dispatchEvent(new PixtonEvent(PixtonEvent.MOVE_TARGET,this.target,"attached",new Point(param1.stageX,param1.stageY)));
      }
      
      public function startMove(param1:MouseEvent) : void
      {
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         this.resetStart();
         this.moveStart = new Point(param1.stageX,param1.stageY);
      }
      
      private function updateMove(param1:MouseEvent) : void
      {
         this.nudge(param1.stageX - this.moveStart.x,param1.stageY - this.moveStart.y,false,param1);
         dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,this.target));
      }
      
      private function stopMove(param1:MouseEvent) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         if(Math.abs(param1.stageX - this.moveStart.x) > 1 || Math.abs(param1.stageY - this.moveStart.y) > 1)
         {
            this.dispatchStateChange();
         }
      }
      
      public function startZ(param1:MouseEvent) : void
      {
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateZ);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopZ);
         this.resetStart();
         this.moveStart = new Point(param1.stageX,param1.stageY);
      }
      
      private function updateZ(param1:MouseEvent) : void
      {
         if(!(this.target is Array))
         {
            Asset(this.target).zIndex = Asset(this.target).zIndex + (param1.stageY - this.moveStart.y) * 0.001;
            dispatchEvent(new PixtonEvent(PixtonEvent.Z_MOVE_TARGET,this.target));
         }
      }
      
      private function stopZ(param1:MouseEvent) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateZ);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopZ);
         if(param1.stageX != this.moveStart.x || param1.stageY != this.moveStart.y)
         {
            this.dispatchStateChange();
         }
      }
      
      private function resetStart() : void
      {
         var _loc1_:uint = 0;
         if(this.target == null)
         {
            return;
         }
         if(this.target is Array)
         {
            this.startPoint = [];
            _loc1_ = 0;
            while(_loc1_ < this.target.length)
            {
               this.startPoint[_loc1_] = new Point(this.target[_loc1_].x,this.target[_loc1_].y);
               _loc1_++;
            }
         }
         else
         {
            this.startPoint = new Point(this.target.x,this.target.y);
         }
      }
      
      public function nudge(param1:Number, param2:Number, param3:Boolean = false, param4:MouseEvent = null) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:uint = 0;
         if(param3)
         {
            this.resetStart();
         }
         var _loc5_:Number = this.target is Array || this.target is Dialog && !Dialog(this.target).isProp() ? Number(1) : Number(Editor(parent).scale);
         var _loc6_:Number = param1 / _loc5_ / Editor.self.scaleX;
         var _loc7_:Number = param2 / _loc5_ / Editor.self.scaleY;
         var _loc8_:Number = _loc6_;
         var _loc9_:Number = _loc7_;
         if(!(this.target is Dialog) || Dialog(this.target).isProp())
         {
            _loc10_ = Utils.d2r(Editor(parent).contentsC.rotation);
            _loc11_ = Math.sin(_loc10_);
            _loc12_ = Math.cos(_loc10_);
            _loc8_ = _loc6_ * _loc12_ + _loc7_ * _loc11_;
            _loc9_ = -_loc6_ * _loc11_ + _loc7_ * _loc12_;
         }
         if(this.target is Array)
         {
            _loc13_ = 0;
            while(_loc13_ < this.target.length)
            {
               this.target[_loc13_].x = this.startPoint[_loc13_].x + _loc8_ / this.target[0].parent.scaleX;
               this.target[_loc13_].y = this.startPoint[_loc13_].y + _loc9_ / this.target[0].parent.scaleY;
               _loc13_++;
            }
         }
         else
         {
            this.target.x = this.startPoint.x + _loc8_;
            this.target.y = this.startPoint.y + _loc9_;
         }
         if(param4 == null && !(this.target is Dialog))
         {
            this.dispatchStateChange();
         }
         else
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.MOVE_TARGET,this.target));
         }
         this.updatePosition();
      }
      
      private function finalizeResizeCharacter(param1:PixtonEvent = null) : void
      {
         Character(this.target).setBodyWidth(Character(this.target).bodyWidth,true);
         Character(this.target).onOverwrite();
      }
      
      private function dispatchStateChange(param1:PixtonEvent = null) : void
      {
         if(this.target is Moveable)
         {
            Moveable(this.target).updateBMCache();
         }
         dispatchEvent(new PixtonEvent(PixtonEvent.STATE_CHANGE,this.target));
      }
      
      public function set rotatable(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isSmall();
         if(this.target is Dialog && (!Main.isFun() || Main.isFunStudent()))
         {
            param1 = false;
         }
         this.rotateSE.visible = param1;
         this.rotateSW.visible = !_loc2_ && param1;
         this.rotateNE.visible = !_loc2_ && param1;
         this.rotateNW.visible = !_loc2_ && param1;
         if(param1)
         {
            this.rotateSE.setTarget(this.target as MovieClip,this.updateRotate,this.dispatchStateChange);
            this.rotateSW.setTarget(this.target as MovieClip,this.updateRotate,this.dispatchStateChange);
            this.rotateNE.setTarget(this.target as MovieClip,this.updateRotate,this.dispatchStateChange);
            this.rotateNW.setTarget(this.target as MovieClip,this.updateRotate,this.dispatchStateChange);
         }
         else
         {
            this.rotateSE.setTarget();
            this.rotateSW.setTarget();
            this.rotateNE.setTarget();
            this.rotateNW.setTarget();
         }
      }
      
      private function isSmall() : Boolean
      {
         return this.border.width < 44 || this.border.height < 44;
      }
      
      public function updateState(param1:uint, param2:Object) : void
      {
         this.rotatable = param1 == Editor.MODE_MOVE && !(param2 is Array) && !Main.isCharCreate();
         this.removable = param1 == Editor.MODE_MOVE && param2 is Dialog && !Dialog(param2).isProp() && Dialog(param2).target != null;
         this.attachable = param1 == Editor.MODE_MOVE && param2 is Dialog && !Dialog(param2).isProp();
         this.resizableCharacter = Utils.inArray(param1,[Editor.MODE_LOOKS,Editor.MODE_SCALE]) && param2 is Character && Character(param2).isResizable();
         this.resizableAsset = (param1 == Editor.MODE_MOVE && !(param2 is Array) || param2 is Dialog && param1 == Editor.MODE_EXPR) && !Main.isCharCreate();
         this.movable = param1 == Editor.MODE_MOVE;
         this.playable = param2 is Dialog && !Dialog(param2).isProp();
         this.videoable = param1 == Editor.MODE_EXPR && VideoRecorder.isAllowed && param2 is Character && Globals.isFullVersion() && Character(param2).hasPhoto();
         this.linkable = param2 is Dialog && Dialog(param2).hasLink();
      }
      
      public function set resizableAsset(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isSmall();
         this.resizeN.visible = param1 && !(this.target is Dialog);
         this.resizeS.visible = !_loc2_ && param1 && !(this.target is Dialog);
         this.resizeE.visible = !_loc2_ && param1 && (!(this.target is Dialog) || Dialog(this.target).isResizable());
         this.resizeW.visible = this.resizeE.visible;
         if(this.resizeN.visible)
         {
            this.resizeN.setTarget(this.target as MovieClip,this.updateResizeAsset,this.dispatchStateChange);
            this.resizeS.setTarget(this.target as MovieClip,this.updateResizeAsset,this.dispatchStateChange);
         }
         else
         {
            this.resizeN.setTarget();
            this.resizeS.setTarget();
         }
         if(this.resizeE.visible)
         {
            this.resizeE.setTarget(this.target as MovieClip,this.updateResizeAsset,this.dispatchStateChange);
            this.resizeW.setTarget(this.target as MovieClip,this.updateResizeAsset,this.dispatchStateChange);
         }
         else
         {
            this.resizeE.setTarget();
            this.resizeW.setTarget();
         }
      }
      
      public function setColor(param1:Array) : void
      {
         Utils.setColor(this.border.contents,param1,0,true);
         this.resizerH.setColor(param1);
         this.resizerV.setColor(param1);
         this.resizeN.setColor(param1);
         this.resizeS.setColor(param1);
         this.resizeE.setColor(param1);
         this.resizeW.setColor(param1);
      }
      
      private function removeTarget(param1:MouseEvent) : void
      {
         Dialog(this.target).target = null;
         this.removable = false;
         dispatchEvent(new PixtonEvent(PixtonEvent.MOVE_TARGET,this.target,"detached"));
         this.hideHelp();
      }
      
      public function set attachable(param1:Boolean) : void
      {
         this.attach.visible = param1;
         if(param1)
         {
            Utils.addListener(this.attach,MouseEvent.ROLL_OVER,this.showHelp,true);
            Utils.addListener(this.attach,MouseEvent.ROLL_OUT,this.hideHelp,true);
            Utils.addListener(this.attach,MouseEvent.MOUSE_DOWN,this.startAttach,true);
         }
         else
         {
            Utils.removeListener(this.attach,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.removeListener(this.attach,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.removeListener(this.attach,MouseEvent.MOUSE_DOWN,this.startAttach);
         }
      }
      
      public function set removable(param1:Boolean) : void
      {
         this.remove.visible = param1;
         if(param1)
         {
            Utils.addListener(this.remove,MouseEvent.ROLL_OVER,this.showHelp,true);
            Utils.addListener(this.remove,MouseEvent.ROLL_OUT,this.hideHelp,true);
            Utils.addListener(this.remove,MouseEvent.CLICK,this.removeTarget,true);
         }
         else
         {
            Utils.removeListener(this.remove,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.removeListener(this.remove,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.removeListener(this.remove,MouseEvent.CLICK,this.removeTarget);
         }
      }
      
      public function set zoomed(param1:Boolean) : void
      {
         this._zoomed = param1;
         this.updateResizers();
      }
      
      private function updateResizers() : void
      {
         this.resizerH.visible = this.canResize && !this._zoomed;
         this.resizerV.visible = this.resizerH.visible;
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         switch(param1.currentTarget)
         {
            case this.remove:
               _loc2_ = L.text("detach-c");
               break;
            case this.attach:
               _loc2_ = L.text("attach-c");
               break;
            default:
               _loc2_ = "";
         }
         Help.show(_loc2_,param1.currentTarget);
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
   }
}
