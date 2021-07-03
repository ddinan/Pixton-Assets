package com.pixton.editor
{
   import com.pixton.team.Team;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class PhotoDrawing extends Photo
   {
      
      public static var ENABLED:Boolean = false;
      
      public static var FIXED:Boolean = true;
      
      public static var defaultName:String = "";
      
      public static var thumbCache:Object = {};
      
      private static var photoDrawingData:Array;
      
      private static var photoDrawingDataVisible:Array;
      
      private static var map:Object;
       
      
      private var bmd:BitmapData;
      
      private var bm:Bitmap;
      
      private var drawingContainer:Sprite;
      
      private var showBrush:Boolean = true;
      
      private var brush:DrawingBrush;
      
      private var mouseIsDown:Boolean = false;
      
      private var drawingW:Number;
      
      private var drawingH:Number;
      
      private var minThickness:Number;
      
      private var thicknessFactor:Number;
      
      private var smoothingFactor:Number;
      
      private var thicknessSmoothingFactor:Number;
      
      private var dotRadius:Number;
      
      private var tipTaperFactor:Number;
      
      private var lineLayer:Sprite;
      
      private var lastSmoothedMouseX:Number;
      
      private var lastSmoothedMouseY:Number;
      
      private var lastMouseX:Number;
      
      private var lastMouseY:Number;
      
      private var lastThickness:Number;
      
      private var lastRotation:Number;
      
      private var lineColor:uint;
      
      private var lineThickness:Number;
      
      private var lineRotation:Number;
      
      private var L0Sin0:Number;
      
      private var L0Cos0:Number;
      
      private var L1Sin1:Number;
      
      private var L1Cos1:Number;
      
      private var sin0:Number;
      
      private var cos0:Number;
      
      private var sin1:Number;
      
      private var cos1:Number;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var dist:Number;
      
      private var targetLineThickness:Number;
      
      private var smoothedMouseX:Number;
      
      private var smoothedMouseY:Number;
      
      private var tipLayer:Sprite;
      
      private var mouseMoved:Boolean;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var mouseChangeVectorX:Number;
      
      private var mouseChangeVectorY:Number;
      
      private var lastMouseChangeVectorX:Number;
      
      private var lastMouseChangeVectorY:Number;
      
      private var controlVecX:Number;
      
      private var controlVecY:Number;
      
      private var controlX1:Number;
      
      private var controlY1:Number;
      
      private var controlX2:Number;
      
      private var controlY2:Number;
      
      public function PhotoDrawing(param1:uint, param2:uint = 0)
      {
         var _loc3_:Object = null;
         var _loc4_:BitmapData = null;
         var _loc5_:String = null;
         super();
         cacheKey = "PhotoDrawing";
         if(Team.isActive && param1 > 0)
         {
            Team.require(param1.toString(),null,Team.P_DRAWING);
         }
         this.id = param1;
         this.initDrawing();
         if(param1 != 0)
         {
            _loc3_ = PhotoDrawing.getData(param1);
            if(_loc3_ != null)
            {
               propName = _loc3_.n;
               fileName = _loc3_.f;
               drawPlaceholderBox(_loc3_.w,_loc3_.h);
               if((_loc4_ = Cache.load(cacheKey,param1)) != null)
               {
                  placeImage(_loc4_);
               }
               else
               {
                  _loc5_ = getImagePath(param1,fileName);
                  Utils.load(_loc5_,onLoadImage,false,File.BUCKET_DYNAMIC);
               }
               sendTeamUpdate(param1,_loc3_);
            }
         }
      }
      
      public static function init(param1:Object) : void
      {
         defaultName = param1.defaultName;
      }
      
      public static function has(param1:uint) : Boolean
      {
         require(param1);
         return photoDrawingDataVisible[param1].length > 0;
      }
      
      private static function require(param1:uint) : void
      {
         if(photoDrawingData == null)
         {
            photoDrawingData = [];
            photoDrawingDataVisible = [];
         }
         if(photoDrawingData[param1] == null)
         {
            photoDrawingData[param1] = [];
            photoDrawingDataVisible[param1] = [];
         }
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc6_:Object = null;
         var _loc4_:Array = photoDrawingDataVisible[param1].slice(param2,Math.min(photoDrawingDataVisible[param1].length,param2 + param3));
         var _loc5_:Array = [];
         for each(_loc6_ in _loc4_)
         {
            _loc5_.push(_loc6_.id);
         }
         return {
            "array":_loc5_,
            "showPrev":param2 > 0,
            "showNext":param2 + param3 < photoDrawingDataVisible[param1].length
         };
      }
      
      public static function getCount(param1:uint) : uint
      {
         return photoDrawingData[param1].length;
      }
      
      public static function searchList(param1:uint, param2:String, param3:uint, param4:uint) : Object
      {
         var _loc7_:Object = null;
         param2 = param2.toLowerCase();
         var _loc5_:Array = photoDrawingDataVisible[param1];
         var _loc6_:Array = [];
         for each(_loc7_ in _loc5_)
         {
            if(_loc7_.n.toLowerCase().indexOf(param2) > -1)
            {
               _loc6_.push(_loc7_.id);
            }
         }
         return {
            "array":_loc6_.slice(param3,Math.min(_loc6_.length,param3 + param4)),
            "showPrev":param3 > 0,
            "showNext":param3 + param4 < _loc6_.length
         };
      }
      
      public static function setData(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         if(!param2)
         {
            _loc3_ = param1.lockedPhotoDrawings as Array;
            if(_loc3_ != null && _loc3_.length > 0)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(map[_loc4_.id.toString()] != null)
                  {
                     updateByID(_loc4_.id,_loc4_);
                  }
                  else
                  {
                     require(Pixton.POOL_LOCKED);
                     photoDrawingData[Pixton.POOL_LOCKED].push(_loc4_);
                  }
               }
            }
         }
         else
         {
            if(photoDrawingData != null && photoDrawingData[Pixton.POOL_MINE] != null)
            {
               photoDrawingData[Pixton.POOL_MINE] = null;
            }
            _loc9_ = [];
            _loc10_ = Pixton.POOL_LOCKED;
            _loc11_ = param1.userPhotoDrawings as Array;
            _loc9_[Pixton.POOL_MINE] = _loc11_;
            _loc9_[Pixton.POOL_PRESET] = [];
            if(param1.lockedPhotoDrawings != null)
            {
               _loc12_ = param1.lockedPhotoDrawings as Array;
               _loc9_[Pixton.POOL_LOCKED] = _loc12_;
               _loc10_ = Pixton.POOL_LOCKED;
            }
            _loc7_ = Pixton.POOL_MINE;
            while(_loc7_ <= _loc10_)
            {
               if(_loc9_[_loc7_] != null)
               {
                  require(_loc7_);
                  _loc6_ = _loc9_[_loc7_].length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_)
                  {
                     photoDrawingData[_loc7_].push(_loc9_[_loc7_][_loc5_]);
                     if(_loc9_[_loc7_][_loc5_].hd != 1)
                     {
                        photoDrawingDataVisible[_loc7_].push(_loc9_[_loc7_][_loc5_]);
                     }
                     _loc5_++;
                  }
               }
               _loc7_++;
            }
         }
         updateMap();
      }
      
      public static function hide(param1:int) : void
      {
         Utils.remote("hidePropPhoto",{"prop":param1});
         remove(param1);
      }
      
      private static function remove(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = Pixton.POOL_MINE;
         _loc3_ = photoDrawingDataVisible[_loc4_].length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(photoDrawingDataVisible[_loc4_][_loc2_].id == param1)
            {
               photoDrawingDataVisible[_loc4_].splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private static function updateMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         map = {};
         var _loc3_:uint = photoDrawingData.length;
         _loc1_ = Pixton.POOL_MINE;
         while(_loc1_ <= Pixton.POOL_LOCKED)
         {
            if(photoDrawingData[_loc1_] != null)
            {
               _loc3_ = photoDrawingData[_loc1_].length;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  map[photoDrawingData[_loc1_][_loc2_].id.toString()] = [_loc1_,_loc2_];
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      public static function hasData(param1:uint) : Boolean
      {
         return map[param1.toString()] != null;
      }
      
      public static function getData(param1:uint) : Object
      {
         var _loc2_:String = param1.toString();
         var _loc3_:Array = map[_loc2_];
         if(_loc3_ != null)
         {
            return photoDrawingData[_loc3_[0]][_loc3_[1]];
         }
         return null;
      }
      
      private static function updateByID(param1:uint, param2:Object) : void
      {
         var _loc3_:Array = map[param1.toString()];
         photoDrawingData[_loc3_[0]][_loc3_[1]] = param2;
      }
      
      public static function update(param1:PhotoDrawing) : void
      {
         updateByID(param1.id,param1.getPhotoData());
      }
      
      static function sendTeamUpdate(param1:int, param2:Object) : void
      {
         if(!Team.isActive)
         {
            return;
         }
         Team.onChange(Main.userID.toString(),null,Team.P_DRAWING_LIST,param1.toString(),1);
         Team.onChange(param1.toString(),null,Team.P_DRAWING,null,param2);
      }
      
      static function getImagePath(param1:int, param2:String = null) : String
      {
         return File.LOCAL_BUCKET + "photo/" + (param2 == null ? "_" : "") + param1 + (param2 == null ? PickerItem.IMAGE_EXT : param2);
      }
      
      private static function addData(param1:Object, param2:uint) : void
      {
         if(hasData(param1.id))
         {
            return;
         }
         require(param2);
         photoDrawingData[param2].unshift(param1);
         if(param1.hd == null || param1.hd != 1)
         {
            photoDrawingDataVisible[param2].unshift(param1);
         }
         updateMap();
      }
      
      static function onTeamUpdate(param1:int, param2:Object) : void
      {
         param2.hd = 1;
         addData(param2,Pixton.POOL_COMMUNITY);
      }
      
      override public function setMode(param1:uint, param2:Boolean = false) : void
      {
         super.setMode(param1,param2);
         if(param1 == Editor.MODE_EXPR)
         {
            Utils.addListener(stage,MouseEvent.MOUSE_DOWN,this.startDraw);
            Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.onMove);
            Utils.addListener(stage,Event.MOUSE_LEAVE,this.onLeave);
            graphics.clear();
            graphics.beginFill(16777215,0);
            graphics.moveTo(-this.drawingW / 2,-this.drawingH / 2);
            graphics.lineTo(this.drawingW / 2,-this.drawingH / 2);
            graphics.lineTo(this.drawingW / 2,this.drawingH / 2);
            graphics.lineTo(-this.drawingW / 2,this.drawingH / 2);
            graphics.lineTo(-this.drawingW / 2,-this.drawingH / 2);
            graphics.endFill();
            if(this.showBrush)
            {
               if(this.brush == null)
               {
                  this.brush = new DrawingBrush();
                  this.brush.width = this.dotRadius * 2;
                  this.brush.height = this.dotRadius * 2;
                  this.brush.mouseEnabled = false;
                  this.brush.blendMode = BlendMode.INVERT;
               }
               Mouse.hide();
               if(this.brush.parent == null)
               {
                  stage.addChild(this.brush);
               }
            }
         }
         else
         {
            Utils.removeListener(stage,MouseEvent.MOUSE_DOWN,this.startDraw);
            Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.onMove);
            Utils.removeListener(stage,Event.MOUSE_LEAVE,this.onLeave);
            graphics.clear();
            if(this.showBrush && this.brush != null)
            {
               if(this.brush.parent != null)
               {
                  stage.removeChild(this.brush);
               }
               Mouse.show();
            }
         }
      }
      
      private function initDrawing() : void
      {
         this.drawingW = 300;
         this.drawingH = 300;
         this.minThickness = 0.2;
         this.thicknessFactor = 0.25;
         this.smoothingFactor = 0.3;
         this.thicknessSmoothingFactor = 0.3;
         this.dotRadius = 2;
         this.tipTaperFactor = 0.8;
         this.drawingContainer = new Sprite();
         addChild(this.drawingContainer);
         this.bmd = new BitmapData(this.drawingW,this.drawingH,true,16777215);
         this.bm = new Bitmap(this.bmd);
         this.drawingContainer.addChild(this.bm);
         this.lineLayer = new Sprite();
         this.tipLayer = new Sprite();
         this.tipLayer.mouseEnabled = false;
         this.drawingContainer.addChild(this.tipLayer);
         this.drawingContainer.x = this.drawingW * -0.5;
         this.drawingContainer.y = this.drawingH * -0.5;
      }
      
      private function startDraw(param1:MouseEvent) : void
      {
         this.mouseMoved = false;
         this.mouseIsDown = true;
         this.startX = this.lastMouseX = this.smoothedMouseX = this.lastSmoothedMouseX = this.drawingContainer.mouseX;
         this.startY = this.lastMouseY = this.smoothedMouseY = this.lastSmoothedMouseY = this.drawingContainer.mouseY;
         this.lastThickness = 0;
         this.lastRotation = Math.PI / 2;
         this.lastMouseChangeVectorX = 0;
         this.lastMouseChangeVectorY = 0;
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopDraw);
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         if(this.showBrush)
         {
            this.brush.visible = true;
            Utils.matchPosition(this.brush,new Point(param1.stageX,param1.stageY));
         }
         if(this.mouseIsDown)
         {
            this.drawLine(param1);
         }
      }
      
      private function drawLine(param1:MouseEvent) : void
      {
         this.mouseMoved = true;
         this.lineLayer.graphics.clear();
         this.mouseChangeVectorX = this.drawingContainer.mouseX - this.lastMouseX;
         this.mouseChangeVectorY = this.drawingContainer.mouseY - this.lastMouseY;
         if(this.mouseChangeVectorX * this.lastMouseChangeVectorX + this.mouseChangeVectorY * this.lastMouseChangeVectorY < 0)
         {
            this.bmd.draw(this.tipLayer);
            this.smoothedMouseX = this.lastSmoothedMouseX = this.lastMouseX;
            this.smoothedMouseY = this.lastSmoothedMouseY = this.lastMouseY;
            this.lastRotation += Math.PI;
            this.lastThickness = this.tipTaperFactor * this.lastThickness;
         }
         this.smoothedMouseX += this.smoothingFactor * (this.drawingContainer.mouseX - this.smoothedMouseX);
         this.smoothedMouseY += this.smoothingFactor * (this.drawingContainer.mouseY - this.smoothedMouseY);
         this.dx = this.smoothedMouseX - this.lastSmoothedMouseX;
         this.dy = this.smoothedMouseY - this.lastSmoothedMouseY;
         this.dist = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
         if(this.dist != 0)
         {
            this.lineRotation = Math.PI / 2 + Math.atan2(this.dy,this.dx);
         }
         else
         {
            this.lineRotation = 0;
         }
         this.targetLineThickness = this.minThickness + this.thicknessFactor * this.dist;
         this.lineThickness = this.lastThickness + this.thicknessSmoothingFactor * (this.targetLineThickness - this.lastThickness);
         this.sin0 = Math.sin(this.lastRotation);
         this.cos0 = Math.cos(this.lastRotation);
         this.sin1 = Math.sin(this.lineRotation);
         this.cos1 = Math.cos(this.lineRotation);
         this.L0Sin0 = this.lastThickness * this.sin0;
         this.L0Cos0 = this.lastThickness * this.cos0;
         this.L1Sin1 = this.lineThickness * this.sin1;
         this.L1Cos1 = this.lineThickness * this.cos1;
         this.lineColor = 0;
         this.controlVecX = 0.33 * this.dist * this.sin0;
         this.controlVecY = -0.33 * this.dist * this.cos0;
         this.controlX1 = this.lastSmoothedMouseX + this.L0Cos0 + this.controlVecX;
         this.controlY1 = this.lastSmoothedMouseY + this.L0Sin0 + this.controlVecY;
         this.controlX2 = this.lastSmoothedMouseX - this.L0Cos0 + this.controlVecX;
         this.controlY2 = this.lastSmoothedMouseY - this.L0Sin0 + this.controlVecY;
         this.lineLayer.graphics.lineStyle(1,this.lineColor);
         this.lineLayer.graphics.beginFill(this.lineColor);
         this.lineLayer.graphics.moveTo(this.lastSmoothedMouseX + this.L0Cos0,this.lastSmoothedMouseY + this.L0Sin0);
         this.lineLayer.graphics.curveTo(this.controlX1,this.controlY1,this.smoothedMouseX + this.L1Cos1,this.smoothedMouseY + this.L1Sin1);
         this.lineLayer.graphics.lineTo(this.smoothedMouseX - this.L1Cos1,this.smoothedMouseY - this.L1Sin1);
         this.lineLayer.graphics.curveTo(this.controlX2,this.controlY2,this.lastSmoothedMouseX - this.L0Cos0,this.lastSmoothedMouseY - this.L0Sin0);
         this.lineLayer.graphics.lineTo(this.lastSmoothedMouseX + this.L0Cos0,this.lastSmoothedMouseY + this.L0Sin0);
         this.lineLayer.graphics.endFill();
         this.bmd.draw(this.lineLayer);
         var _loc2_:Number = this.tipTaperFactor * this.lineThickness;
         this.tipLayer.graphics.clear();
         this.tipLayer.graphics.beginFill(this.lineColor);
         this.tipLayer.graphics.drawEllipse(this.drawingContainer.mouseX - _loc2_,this.drawingContainer.mouseY - _loc2_,2 * _loc2_,2 * _loc2_);
         this.tipLayer.graphics.endFill();
         this.tipLayer.graphics.lineStyle(1,this.lineColor);
         this.tipLayer.graphics.beginFill(this.lineColor);
         this.tipLayer.graphics.moveTo(this.smoothedMouseX + this.L1Cos1,this.smoothedMouseY + this.L1Sin1);
         this.tipLayer.graphics.lineTo(this.drawingContainer.mouseX + this.tipTaperFactor * this.L1Cos1,this.drawingContainer.mouseY + this.tipTaperFactor * this.L1Sin1);
         this.tipLayer.graphics.lineTo(this.drawingContainer.mouseX - this.tipTaperFactor * this.L1Cos1,this.drawingContainer.mouseY - this.tipTaperFactor * this.L1Sin1);
         this.tipLayer.graphics.lineTo(this.smoothedMouseX - this.L1Cos1,this.smoothedMouseY - this.L1Sin1);
         this.tipLayer.graphics.lineTo(this.smoothedMouseX + this.L1Cos1,this.smoothedMouseY + this.L1Sin1);
         this.tipLayer.graphics.endFill();
         this.lastSmoothedMouseX = this.smoothedMouseX;
         this.lastSmoothedMouseY = this.smoothedMouseY;
         this.lastRotation = this.lineRotation;
         this.lastThickness = this.lineThickness;
         this.lastMouseChangeVectorX = this.mouseChangeVectorX;
         this.lastMouseChangeVectorY = this.mouseChangeVectorY;
         this.lastMouseX = this.drawingContainer.mouseX;
         this.lastMouseY = this.drawingContainer.mouseY;
         param1.updateAfterEvent();
      }
      
      private function stopDraw(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         var _loc4_:Sprite = null;
         if(!this.mouseMoved)
         {
            _loc2_ = this.dotRadius * (0.75 + 0.75 * Math.random());
            _loc3_ = 0;
            (_loc4_ = new Sprite()).graphics.beginFill(_loc3_);
            _loc4_.graphics.drawEllipse(this.startX - _loc2_,this.startY - _loc2_,2 * _loc2_,2 * _loc2_);
            _loc4_.graphics.endFill();
            this.bmd.draw(_loc4_);
         }
         this.bmd.draw(this.tipLayer);
         this.mouseIsDown = false;
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopDraw);
      }
      
      private function onLeave(param1:Event) : void
      {
         if(!this.showBrush)
         {
            return;
         }
         this.brush.visible = false;
      }
      
      function promptForName(param1:Function) : void
      {
         Popup.show(L.text("name-photo"),this.onName,param1,propName == defaultName ? "" : propName);
      }
      
      private function onName(param1:String = null, param2:Function = null) : void
      {
         if(param1 != null)
         {
            propName = param1;
         }
         param2(true);
      }
      
      function updateID(param1:uint) : void
      {
         this.id = param1;
      }
      
      function getPhotoData() : Object
      {
         return {
            "id":id,
            "n":propName
         };
      }
   }
}
