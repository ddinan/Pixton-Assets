package com.pixton.editor
{
   import com.pixton.character.BodyParts;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class Handle extends PixtonButton
   {
       
      
      public var hotspot:MovieClip;
      
      private var target:MovieClip;
      
      private var target2:String;
      
      private var handler:Function;
      
      private var stateChange:Function;
      
      private var cursorStart:Point;
      
      private var startPoint:Object;
      
      private var moveStart:Object;
      
      private var startA:Number;
      
      private var startR:Number;
      
      private var startS:Number;
      
      private var startZ:Number;
      
      public function Handle()
      {
         super();
      }
      
      override function onOver(param1:MouseEvent) : void
      {
         super.onOver(param1);
         Utils.addListener(this,MouseEvent.MOUSE_DOWN,this.startAction);
      }
      
      override function onOut(param1:MouseEvent) : void
      {
         super.onOut(param1);
         Utils.removeListener(this,MouseEvent.MOUSE_DOWN,this.startAction);
      }
      
      public function setTarget(param1:MovieClip = null, param2:Function = null, param3:Function = null) : void
      {
         if(param1 == null)
         {
            if(this.handler != null)
            {
               Utils.removeListener(this,PixtonEvent.CHANGE,this.handler);
            }
         }
         else
         {
            Utils.addListener(this,PixtonEvent.CHANGE,param2,true);
         }
         this.target = param1;
         this.handler = param2;
         this.stateChange = param3;
      }
      
      public function setTarget2(param1:String) : void
      {
         this.target2 = param1;
      }
      
      private function startAction(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         active = true;
         if(!isNaN(clickTime))
         {
            _loc2_ = getTimer() - clickTime;
            if(_loc2_ < Pixton.CLICK_TIME)
            {
               dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,null,this));
               return;
            }
         }
         clickTime = getTimer();
         if(symbol != null && hideSymbol)
         {
            symbol.visible = false;
            if(symbolWhite != null)
            {
               symbolWhite.visible = symbol.visible;
            }
         }
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.onAction);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopAction);
         switch(name)
         {
            case "turn1":
            case "turn2":
               this.startA = Character(this.target).bodyParts.getTurn(this.target2);
               this.cursorStart = new Point(param1.stageX,param1.stageY);
               break;
            case "resizerH":
            case "resizerV":
               if(this.target is Character)
               {
                  this.startPoint = {
                     "w":Character(this.target).bodyWidth,
                     "h":Character(this.target).bodyHeight
                  };
                  this.cursorStart = this.target.globalToLocal(new Point(param1.stageX,param1.stageY));
               }
               else
               {
                  this.startPoint = new Point(this.target.width,this.target.height);
                  this.cursorStart = new Point(param1.stageX,param1.stageY);
               }
               break;
            case "resizeN":
            case "resizeS":
            case "resizeE":
            case "resizeW":
               this.cursorStart = new Point(param1.stageX,param1.stageY);
               this.startPoint = this.target.parent.localToGlobal(new Point(this.target.x,this.target.y));
               this.moveStart = {"size":this.target.size};
               this.startA = Point.distance(this.startPoint as Point,this.cursorStart);
               this.startS = this.target.size;
               this.startZ = this.target.zIndex;
               break;
            case "cornerNE":
            case "cornerSE":
            case "cornerSW":
            case "cornerNW":
               this.cursorStart = new Point(param1.stageX,param1.stageY);
               switch(name)
               {
                  case "cornerNE":
                     _loc3_ = 0;
                     break;
                  case "cornerSE":
                     _loc3_ = 1;
                     break;
                  case "cornerSW":
                     _loc3_ = 2;
                     break;
                  case "cornerNW":
                     _loc3_ = 3;
               }
               this.startPoint = Border.cornerOffsets[_loc3_];
               break;
            default:
               this.startPoint = this.target.parent.localToGlobal(new Point(this.target.x,this.target.y));
               this.startA = Math.atan2(param1.stageY - this.startPoint.y,param1.stageX - this.startPoint.x);
               this.startR = this.target.rotation;
         }
         hideHelp(param1);
      }
      
      public function stopAction(param1:MouseEvent = null) : void
      {
         active = false;
         if(symbol != null && hideSymbol)
         {
            symbol.visible = false;
            if(symbolWhite != null)
            {
               symbolWhite.visible = symbol.visible;
            }
         }
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.onAction);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopAction);
         if(this.stateChange != null)
         {
            this.stateChange(new PixtonEvent(PixtonEvent.CHANGE,this));
         }
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc2_:Object = {"target":this};
         switch(name)
         {
            case "turn1":
            case "turn2":
               _loc2_.n = this.target2;
               _loc2_.t = this.startA + Math.round((param1.stageX - this.cursorStart.x) / BodyParts.TURN_INCR);
               break;
            case "resizerH":
            case "resizerV":
               if(this.target is Character)
               {
                  _loc3_ = (_loc6_ = this.target.globalToLocal(new Point(param1.stageX,param1.stageY))).x / this.cursorStart.x;
                  _loc4_ = _loc6_.y / this.cursorStart.y;
                  if(name == "resizerH")
                  {
                     _loc2_.w = this.startPoint.w * Math.abs(_loc3_);
                  }
                  else
                  {
                     _loc2_.h = this.startPoint.h * Math.abs(_loc4_);
                  }
               }
               else
               {
                  _loc3_ = param1.stageX - this.cursorStart.x;
                  _loc4_ = param1.stageY - this.cursorStart.y;
                  if(name == "resizerH")
                  {
                     _loc2_.x = this.startPoint.x + _loc3_;
                  }
                  else
                  {
                     _loc2_.y = this.startPoint.y + _loc4_;
                  }
               }
               break;
            case "resizeN":
            case "resizeS":
            case "resizeE":
            case "resizeW":
               _loc2_.size = this.startS * Point.distance(this.startPoint as Point,new Point(param1.stageX,param1.stageY)) / this.startA;
               _loc2_.z = this.startZ * Point.distance(this.startPoint as Point,new Point(param1.stageX,param1.stageY)) / this.startA;
               break;
            case "cornerNE":
            case "cornerSE":
            case "cornerSW":
            case "cornerNW":
               _loc3_ = param1.stageX - this.cursorStart.x;
               _loc4_ = param1.stageY - this.cursorStart.y;
               _loc2_.x = this.startPoint.x + _loc3_;
               _loc2_.y = this.startPoint.y + _loc4_;
               break;
            default:
               _loc5_ = Math.atan2(param1.stageY - this.startPoint.y,param1.stageX - this.startPoint.x);
               _loc2_.r = this.startR + Utils.r2d(_loc5_ - this.startA);
         }
         dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,_loc2_));
      }
   }
}
