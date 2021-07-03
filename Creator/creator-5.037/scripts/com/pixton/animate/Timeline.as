package com.pixton.animate
{
   import com.pixton.editor.Character;
   import com.pixton.editor.Dialog;
   import com.pixton.editor.Editor;
   import com.pixton.editor.L;
   import com.pixton.editor.Main;
   import com.pixton.editor.Palette;
   import com.pixton.editor.PixtonButton;
   import com.pixton.editor.PixtonEvent;
   import com.pixton.editor.Utils;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Timeline extends MovieClip
   {
      
      private static const MAINTAIN_LENGTH:Boolean = true;
      
      private static const AUTO_EMPTY:Boolean = true;
      
      private static const COLOR_SELECTION:uint = 0;
      
      private static const COLOR_TEMP:uint = 0;
      
      private static const COLOR_OVER:uint = 16763904;
      
      private static const ALPHA_PLACEMENT_END:Number = 0.2;
      
      private static const SELECTION_FILL_ALPHA:Number = 0.5;
      
      private static const TEMP_SELECTION_FILL_ALPHA:Number = 0.1;
      
      private static const TEMP_SELECTION_BORDER_ALPHA:Number = 0.5;
      
      private static const PLACEMENT_FILL_COLOR:uint = 16777215;
      
      private static const PLACEMENT_LINE_COLOR:uint = 0;
      
      private static const PLACEMENT_ALPHA:Number = 0.9;
      
      private static const COLOR_INACTIVE:Array = [192,192,192];
      
      private static const MARKER_Y:Number = -15;
       
      
      public var selectionMC:MovieClip;
      
      public var placementsMC:MovieClip;
      
      public var channelsMC:MovieClip;
      
      public var overMC:MovieClip;
      
      public var flareMC:MovieClip;
      
      public var btnResizeH:PixtonButton;
      
      public var selectedMode:int = -1;
      
      public var selectedPos:int = -1;
      
      public var selectedTarget:Object;
      
      private var selectedChannel:int = -1;
      
      private var _selectedPlacement:Placement;
      
      private var resizeStart:int = -1;
      
      private var resizePlacementStartLength:uint;
      
      private var selecting:Boolean = false;
      
      private var resizing:Boolean = false;
      
      private var channels:Array;
      
      private var markers:Array;
      
      private var rowMap:Array;
      
      private var channelMap:Array;
      
      private var map:Array;
      
      private var placementLabels:Array;
      
      private var channelHeight:Number = 0;
      
      private var dirty:Boolean = false;
      
      public function Timeline()
      {
         this.placementLabels = [];
         super();
         Utils.addListener(this,MouseEvent.MOUSE_DOWN,this.onStartSelect);
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.addListener(this,Event.RENDER,this.onRender);
         this.btnResizeH.visible = false;
         this.flareMC = new MovieClip();
         addChild(this.flareMC);
      }
      
      private function onRender(param1:Event = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:Channel = null;
         var _loc8_:Marker = null;
         var _loc9_:Placement = null;
         var _loc11_:PlacementLabel = null;
         var _loc12_:Object = null;
         if(!this.dirty)
         {
            return;
         }
         this.dirty = false;
         this.arrange();
         this.remap();
         this.updateCellsUsed();
         if(this.markers == null)
         {
            this.markers = [];
         }
         var _loc5_:uint = 0;
         var _loc7_:Graphics;
         (_loc7_ = graphics).clear();
         if(this.rowMap != null)
         {
            _loc7_.beginFill(16777215,0);
            _loc7_.moveTo(0,MARKER_Y);
            _loc7_.lineTo(Channel.visibleCells * Channel.CELL_WIDTH,MARKER_Y);
            _loc7_.lineTo(Channel.visibleCells * Channel.CELL_WIDTH,this.rowMap.length * Channel.CELL_HEIGHT);
            _loc7_.lineTo(0,this.rowMap.length * Channel.CELL_HEIGHT);
            _loc7_.lineTo(0,MARKER_Y);
            _loc7_.endFill();
         }
         _loc7_.lineStyle(1,Palette.rgb2hex(Editor.COLOR[Editor.MODE_MAIN]));
         _loc4_ = Channel.cellOffset + Channel.visibleCells;
         _loc2_ = Channel.cellOffset;
         while(_loc2_ <= _loc4_)
         {
            if(_loc2_ % 3 == 2)
            {
               _loc3_ = _loc2_ - Channel.cellOffset;
               if(_loc2_ < _loc4_)
               {
                  if(this.markers[_loc5_] == null)
                  {
                     _loc8_ = new Marker(Editor.COLOR[Editor.MODE_MAIN]);
                     addChild(_loc8_);
                     _loc8_.y = MARKER_Y;
                     this.markers[_loc5_] = _loc8_;
                  }
                  (_loc8_ = this.markers[_loc5_]).alpha = _loc2_ % Channel.CELL_GROUP_SIZE == Channel.CELL_GROUP_SIZE - 1 ? Number(1) : Number(0.4);
                  _loc8_.value = _loc2_ + 1;
                  _loc8_.x = Math.round((_loc3_ + 0.5) * Channel.CELL_WIDTH - _loc8_.width * 0.5) + 1;
                  if(_loc2_ < Channel.cellsUsed)
                  {
                     Utils.setColor(_loc8_);
                  }
                  else
                  {
                     Utils.setColor(_loc8_,COLOR_INACTIVE);
                  }
                  _loc5_++;
               }
            }
            _loc2_++;
         }
         _loc4_ = this.markers.length;
         _loc2_ = _loc5_;
         while(_loc2_ < _loc4_)
         {
            this.markers[_loc2_].visible = false;
            _loc2_++;
         }
         _loc7_.moveTo(0,0);
         _loc7_.lineTo(Channel.visibleCells * Channel.CELL_WIDTH,0);
         if(!this.isEmpty())
         {
            for each(_loc6_ in this.channels)
            {
               _loc6_.redraw();
            }
         }
         var _loc10_:Array = Placement.getList();
         (_loc7_ = this.placementsMC.graphics).clear();
         _loc3_ = 0;
         _loc4_ = _loc10_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc9_ = _loc10_[_loc2_];
            if((_loc12_ = this.drawPlacement(_loc7_,_loc9_)) != null)
            {
               if(this.placementLabels[_loc3_] == null)
               {
                  _loc11_ = new PlacementLabel();
                  this.selectionMC.addChild(_loc11_);
                  this.placementLabels[_loc3_] = _loc11_;
               }
               else
               {
                  _loc11_ = this.placementLabels[_loc3_];
               }
               _loc11_.setName(_loc9_.getName());
               _loc11_.x = _loc12_.x + _loc12_.width * 0.5;
               _loc11_.y = _loc12_.y + _loc12_.height * 0.5;
               _loc11_.visible = true;
               _loc3_++;
            }
            _loc2_++;
         }
         _loc4_ = this.placementLabels.length;
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            (_loc11_ = this.placementLabels[_loc2_]).visible = false;
            _loc2_++;
         }
         this.redrawSelection();
         this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE));
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         Utils.monitorMemory("timeline");
         this.dirty = true;
         if(param1)
         {
            this.onRender();
         }
         else
         {
            Utils.invalidate(this);
         }
      }
      
      public function unsetData() : void
      {
         this.selectOneCell();
         this.clear();
         Placement.unsetData();
         this.redraw();
      }
      
      public function clearPosition() : void
      {
         this.selectedMode = -1;
         this.selectedPos = -1;
         this.selectedChannel = -1;
      }
      
      public function selectOneCell() : void
      {
         this.selectedPlacement = null;
         if(this.selectedChannel == -1 || this.selectedMode == -1 || this.selectedPos == -1 || this.channelMap == null || this.channelMap[this.selectedChannel] == null)
         {
            TimelineSelection.unset();
         }
         else
         {
            TimelineSelection.setStart(this.selectedPos,this.channelMap[this.selectedChannel][this.selectedMode]);
            TimelineSelection.unity();
         }
         this.redraw();
      }
      
      private function trySelectPlacement() : void
      {
         if(this.selectedChannel == -1)
         {
            this.selectedChannel = this.getChannelIndex(this.selectedTarget);
         }
         if(this.selectedChannel == -1 || this.selectedMode == -1 || this.channelMap == null || this.channelMap[this.selectedChannel] == null || this.channelMap[this.selectedChannel][this.selectedMode] == null)
         {
            this.selectedPlacement = null;
         }
         else
         {
            this.selectedPlacement = this.getPlacement(this.channelMap[this.selectedChannel][this.selectedMode],this.selectedPos);
         }
         if(this.selectedPlacement != null)
         {
            this.dispatchEvent(new PixtonEvent(PixtonEvent.SELECTION,null));
         }
      }
      
      public function set selectedPlacement(param1:Placement) : void
      {
         var _loc2_:uint = 0;
         if(this.resizing)
         {
            return;
         }
         this._selectedPlacement = param1;
         if(this._selectedPlacement == null)
         {
            this.btnResizeH.visible = false;
            Utils.removeListener(this.btnResizeH,MouseEvent.MOUSE_DOWN,this.startResize);
         }
         else
         {
            _loc2_ = this.getFirstRow(this.selectedPlacement);
            this.btnResizeH.visible = true;
            Utils.addListener(this.btnResizeH,MouseEvent.MOUSE_DOWN,this.startResize);
            this.btnResizeH.y = (_loc2_ + (this.selectedPlacement.getNumRows() - 1) * 0.5) * Channel.CELL_HEIGHT + Channel.CELL_INNER_HEIGHT * 0.5;
            this.repositionResizeH();
            TimelineSelection.setStart(param1.position,_loc2_);
            TimelineSelection.setEnd(param1.position + param1.getNumCells(),_loc2_ + param1.getNumRows());
         }
      }
      
      private function repositionResizeH() : void
      {
         this.btnResizeH.x = (this.selectedPlacement.position - Channel.cellOffset + this.selectedPlacement.getNumCells()) * Channel.CELL_WIDTH;
      }
      
      private function startResize(param1:MouseEvent) : void
      {
         this.resizing = true;
      }
      
      public function get selectedPlacement() : Placement
      {
         return this._selectedPlacement;
      }
      
      public function getAppearance(param1:Object) : uint
      {
         var _loc2_:int = this.getChannelIndex(param1);
         if(_loc2_ > -1)
         {
            return Channel(this.channels[_loc2_]).getFirstAppearance();
         }
         return 0;
      }
      
      public function setTargetMode(param1:Object, param2:int, param3:Boolean = false) : void
      {
         if(this.selecting)
         {
            return;
         }
         this.selectedTarget = param1;
         this.selectedMode = param2;
         this.selectedChannel = this.getChannelIndex(param1);
         if(!Animation.animating)
         {
            this.trySelectPlacement();
            if(this.selectedPlacement == null)
            {
               if(param3)
               {
                  this.selectOneCell();
               }
            }
            this.redraw();
         }
      }
      
      public function setPosition(param1:uint, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param1 == this.selectedPos && !param2)
         {
            return;
         }
         this.selectedPos = param1;
         if(!param3)
         {
            this.selectOneCell();
         }
         if(!Animation.animating && !this.resizing)
         {
            this.trySelectPlacement();
            this.redraw();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.onMoveOver);
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
         this.onMoveOver(param1);
      }
      
      private function onMoveOver(param1:MouseEvent) : void
      {
         var _loc4_:Placement = null;
         if(this.channels.length == 0)
         {
            return;
         }
         var _loc2_:Graphics = this.overMC.graphics;
         _loc2_.clear();
         if(this.resizing)
         {
            return;
         }
         var _loc3_:Object = this.getRowCol(param1);
         if(_loc3_.col > -1 && _loc3_.row > -1)
         {
            _loc4_ = this.getPlacement(_loc3_.row,_loc3_.col);
         }
         if(_loc4_ == null)
         {
            if(_loc3_.row == -1)
            {
               this.drawBox(_loc2_,_loc3_.col,0,_loc3_.col,this.rowMap.length - 1,0,0,0,COLOR_OVER,SELECTION_FILL_ALPHA);
            }
            else if(_loc3_.col == -1)
            {
               this.drawBox(_loc2_,0,_loc3_.row,Channel.visibleCells - 1,_loc3_.row,0,0,0,COLOR_OVER,SELECTION_FILL_ALPHA);
            }
            else
            {
               this.drawBox(_loc2_,_loc3_.col,_loc3_.row,_loc3_.col,_loc3_.row,0,0,0,COLOR_OVER,SELECTION_FILL_ALPHA);
            }
         }
         else if(_loc4_ != null)
         {
            this.drawPlacement(_loc2_,_loc4_,true);
         }
      }
      
      private function getPlacement(param1:uint, param2:uint) : Placement
      {
         if(this.map == null || this.map[param1] == null || this.map[param1][param2] == null)
         {
            return null;
         }
         return this.map[param1][param2] as Placement;
      }
      
      public function placementSelected() : Boolean
      {
         return this.selectedPlacement != null;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.overMC.graphics.clear();
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.onMoveOver);
         Utils.removeListener(this,MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onStartSelect(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.getRowCol(param1);
         if(_loc2_ == null)
         {
            return;
         }
         if(this.resizing)
         {
            if(_loc2_.col == -1 || _loc2_.row == -1)
            {
               return;
            }
            this.resizeStart = _loc2_.col;
            this.resizePlacementStartLength = this.selectedPlacement.getNumCells();
         }
         else
         {
            this.selecting = true;
            TimelineSelection.setStart(_loc2_.col,_loc2_.row);
            TimelineSelection.setEnd(_loc2_.col,_loc2_.row);
            this.onMoveOver(param1);
         }
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.onUpdateSelect);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onStopSelect);
      }
      
      private function onUpdateSelect(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc2_:Object = this.getRowCol(param1);
         if(this.resizing)
         {
            _loc3_ = _loc2_.col - this.resizeStart;
            if(this.resizePlacementStartLength + _loc3_ > 1)
            {
               _loc4_ = this.selectedPlacement.getNumCells();
               if((_loc5_ = this.resizePlacementStartLength + _loc3_ - _loc4_) > 0)
               {
                  _loc6_ = 0;
                  if(Placement.noneAfter(this.selectedPlacement))
                  {
                     _loc6_ = this.currentChannel.numEmptyFramesAfter(_loc2_.col - _loc5_ + 1);
                  }
                  this.insertCell(true,-1,_loc2_.col - _loc5_ + 1,Math.max(0,_loc5_ - _loc6_));
               }
               else if(_loc5_ < 0)
               {
                  this.insertCell(false,-1,_loc2_.col + 1,-_loc5_);
               }
               this.selectedPlacement.setNumCells(this.resizePlacementStartLength + _loc3_);
               this.repositionResizeH();
            }
         }
         else
         {
            TimelineSelection.setEnd(_loc2_.col,_loc2_.row);
         }
         this.redraw();
      }
      
      private function onStopSelect(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         this.selecting = false;
         if(this.resizing)
         {
            this.applyPlacement(this.selectedPlacement);
            this.resizing = false;
            if(this.selectedPos >= this.selectedPlacement.position + this.selectedPlacement.getNumCells())
            {
               this.dispatchEvent(new PixtonEvent(PixtonEvent.POSITION_CHANGE,this.selectedPlacement.position + this.selectedPlacement.getNumCells() - 1));
            }
            this.onStateChange();
         }
         else
         {
            _loc2_ = TimelineSelection.getRow();
            if(this.rowMap[_loc2_] != null)
            {
               this.selectedChannel = this.rowMap[_loc2_].channel;
               this.selectedMode = this.rowMap[_loc2_].mode;
            }
            else
            {
               this.selectedChannel = -1;
               this.selectedMode = -1;
            }
            _loc3_ = TimelineSelection.getPos();
            if(_loc3_ > -1)
            {
               if(this.selectedChannel > -1)
               {
                  _loc4_ = Channel(this.channels[this.selectedChannel]).target;
               }
               this.dispatchEvent(new PixtonEvent(PixtonEvent.SELECTION,{
                  "target":_loc4_,
                  "mode":this.selectedMode,
                  "pos":_loc3_
               }));
            }
         }
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.onUpdateSelect);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onStopSelect);
         this.redraw();
      }
      
      private function getRowCol(param1:MouseEvent) : Object
      {
         if(this.rowMap == null || this.rowMap.length == 0)
         {
            return null;
         }
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:int = Utils.limit(Math.floor(_loc2_.y / Channel.CELL_HEIGHT),-1,this.rowMap.length - 1);
         var _loc4_:int;
         if((_loc4_ = Channel.cellOffset + Math.floor(_loc2_.x / Channel.CELL_WIDTH)) < Channel.cellOffset)
         {
            _loc4_ = -1;
         }
         else if(_loc4_ > Channel.cellOffset + Channel.visibleCells - 1)
         {
            _loc4_ = Channel.cellOffset + Channel.visibleCells - 1;
         }
         return {
            "col":_loc4_,
            "row":_loc3_
         };
      }
      
      public function hasKeyframe() : Boolean
      {
         if(this.selectedChannel > -1 && this.selectedMode > -1 && this.selectedPos > -1)
         {
            return this.currentChannel.hasKeyframe(this.selectedMode,this.selectedPos);
         }
         return false;
      }
      
      public function hasDeletableKeyframe() : Boolean
      {
         if(this.selectedChannel > -1)
         {
            return this.currentChannel.hasDeletableKeyframe(this.selectedMode,this.selectedPos);
         }
         return false;
      }
      
      public function insertCell(param1:Boolean, param2:int = -1, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         if(param1 && !this.resizing && this.selectedPlacement != null)
         {
            param3 = this.selectedPos;
            param4 = 1;
            this.currentChannel.insertCell(-1,param3,param1,param4);
            _loc8_ = this.currentChannel.target;
         }
         else if(param2 == -1)
         {
            this.currentChannel.insertCell(param2,param3,param1,param4);
            _loc8_ = this.currentChannel.target;
         }
         else
         {
            param4 = TimelineSelection.getCells();
            param3 = this.selectedPos;
            _loc7_ = (_loc6_ = this.channelMap[this.selectedChannel][this.selectedMode]) + TimelineSelection.getRows();
            _loc5_ = _loc6_;
            while(_loc5_ < _loc7_)
            {
               Channel(this.channels[this.rowMap[_loc5_].channel]).insertCell(this.rowMap[_loc5_].mode,param3,param1,param4);
               _loc5_++;
            }
         }
         Placement.insertCell(_loc8_,param3,param1,param4);
         this.redraw();
      }
      
      public function getOnionData(param1:Boolean) : Array
      {
         if(this.selectedChannel > -1)
         {
            return this.currentChannel.getOnionData(this.selectedPos,param1);
         }
         return null;
      }
      
      public function targetHidden(param1:Boolean) : Boolean
      {
         if(this.selectedChannel > -1)
         {
            return this.currentChannel.targetHidden(this.selectedPos,param1);
         }
         return false;
      }
      
      public function hasDefaultChannel() : Boolean
      {
         if(this.selectedChannel > -1)
         {
            return !this.currentChannel.isEmpty(Animation.MODE_DEFAULT);
         }
         return false;
      }
      
      public function hideTarget(param1:Boolean) : void
      {
         this.currentChannel.hideTarget(Animation.MODE_DEFAULT,this.selectedPos,param1);
      }
      
      public function isSaveable() : Boolean
      {
         var _loc1_:uint = TimelineSelection.getCells();
         var _loc2_:uint = TimelineSelection.getRows();
         return this.selectedTarget != null && this.selectedPlacement == null && this.selectedChannel > -1 && this.selectedMode > -1 && !(this.selectedTarget is Dialog) && _loc1_ > 1 && this.rowMap[this.channelMap[this.selectedChannel][this.selectedMode] + _loc2_ - 1] != null && this.rowMap[this.channelMap[this.selectedChannel][this.selectedMode] + _loc2_ - 1].channel == this.selectedChannel;
      }
      
      public function getSelectedXY() : Point
      {
         return this.localToGlobal(new Point((this.selectedPos - Channel.cellOffset) * Channel.CELL_WIDTH,this.channelMap[this.selectedChannel][this.selectedMode] * Channel.CELL_HEIGHT));
      }
      
      public function placeSequence(param1:uint) : void
      {
         var _loc3_:Placement = null;
         var _loc2_:Sequence = Sequence.getSequence(param1);
         if(_loc2_ != null)
         {
            _loc3_ = new Placement();
            _loc3_.setSequence(_loc2_);
            _loc3_.setNumCells(_loc2_.getNumCells());
            _loc3_.setTarget(this.selectedTarget);
            _loc3_.setPosition(this.selectedPos);
            Placement.save(_loc3_);
            this.applyPlacement(_loc3_);
            this.arrange();
            this.remap();
            this.trySelectPlacement();
         }
         this.redraw();
         this.updateScene();
      }
      
      private function getFirstRow(param1:Placement) : uint
      {
         var _loc2_:uint = this.getChannelIndex(param1.target);
         return this.channelMap[_loc2_][Channel(this.channels[_loc2_]).getFirstMode()] + Channel(this.channels[_loc2_]).getRowNum(param1.sequence.getFirstMode());
      }
      
      private function drawPlacement(param1:Graphics, param2:Placement, param3:Boolean = false) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         _loc7_ = param2.getNumCells();
         _loc8_ = param2.getNumRows();
         _loc6_ = (_loc5_ = param2.position) + _loc7_;
         if(_loc5_ >= Channel.cellOffset + Channel.visibleCells || _loc6_ < Channel.cellOffset)
         {
            return null;
         }
         if((_loc4_ = this.getChannelIndex(param2.target)) == -1)
         {
            return null;
         }
         if(param3)
         {
            _loc9_ = this.drawBox(param1,_loc5_,this.getFirstRow(param2),_loc6_ - 1,this.getFirstRow(param2) + _loc8_ - 1,0,0,0,COLOR_OVER,SELECTION_FILL_ALPHA);
         }
         else
         {
            _loc9_ = this.drawBox(param1,_loc5_,this.getFirstRow(param2),_loc6_ - 1,this.getFirstRow(param2) + _loc8_ - 1,1,PLACEMENT_LINE_COLOR,1,PLACEMENT_FILL_COLOR,PLACEMENT_ALPHA);
         }
         param1.lineStyle(1,PLACEMENT_LINE_COLOR,ALPHA_PLACEMENT_END);
         var _loc11_:uint = param2.sequence.getNumCells() - 1;
         _loc10_ = param2.position;
         while(_loc10_ <= _loc6_)
         {
            if(_loc10_ >= Channel.cellOffset)
            {
               if(_loc10_ >= Channel.cellOffset + Channel.visibleCells)
               {
                  break;
               }
               param1.moveTo((_loc10_ - Channel.cellOffset) * Channel.CELL_WIDTH,_loc9_.y);
               param1.lineTo((_loc10_ - Channel.cellOffset) * Channel.CELL_WIDTH,_loc9_.y + _loc9_.height);
            }
            _loc10_ += _loc11_;
         }
         return _loc9_;
      }
      
      private function redrawSelection() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.selectedPlacement != null)
         {
            _loc1_ = this.selectedPlacement.position;
            _loc2_ = _loc1_ + this.selectedPlacement.getNumCells() - 1;
            _loc3_ = this.getFirstRow(this.selectedPlacement);
            _loc4_ = _loc3_ + this.selectedPlacement.getNumRows() - 1;
         }
         else
         {
            _loc1_ = TimelineSelection.getPos();
            _loc2_ = _loc1_ + TimelineSelection.getCells() - 1;
            _loc3_ = TimelineSelection.getRow();
            _loc4_ = _loc3_ + TimelineSelection.getRows() - 1;
         }
         var _loc5_:Graphics;
         (_loc5_ = this.selectionMC.graphics).clear();
         if(_loc1_ < 0)
         {
            return;
         }
         this.drawBox(_loc5_,_loc1_,_loc3_,_loc2_,_loc4_,1,COLOR_TEMP,TEMP_SELECTION_BORDER_ALPHA,COLOR_TEMP,TEMP_SELECTION_FILL_ALPHA);
         if(this.selectedChannel == -1 || this.selectedPos == -1 || this.channelMap[this.selectedChannel][this.selectedMode] == null || this.selectedPlacement != null)
         {
            return;
         }
         this.drawBox(_loc5_,this.selectedPos,this.channelMap[this.selectedChannel][this.selectedMode],this.selectedPos,this.channelMap[this.selectedChannel][this.selectedMode],1,COLOR_SELECTION,1,COLOR_SELECTION,SELECTION_FILL_ALPHA);
      }
      
      public function get currentChannel() : Channel
      {
         if(this.selectedChannel == -1)
         {
            return null;
         }
         return this.channels[this.selectedChannel] as Channel;
      }
      
      public function autoAlignFeet(param1:Object) : Object
      {
         return this.currentChannel.autoAlignFeet(param1,this.selectedPos);
      }
      
      public function autoAlignHandProp(param1:Object) : Object
      {
         return this.currentChannel.autoAlignHandProp(param1,this.selectedPos);
      }
      
      public function autoSave(param1:Object, param2:Object, param3:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         if(param3)
         {
            if((_loc5_ = this.getChannelIndex(param1)) > -1)
            {
               Channel(this.channels[_loc5_]).autoSave(Animation.MODE_DEFAULT,param2,TimelineSelection.getPos(),TimelineSelection.getCells(),this.selectedPos);
            }
         }
         else
         {
            if(this.selectedPlacement != null && this.selectedMode > Animation.MODE_DEFAULT)
            {
               this.clearPlacement();
            }
            if((_loc6_ = TimelineSelection.getCells()) > 1)
            {
               Channel(this.channels[this.rowMap[this.channelMap[this.selectedChannel][this.selectedMode]].channel]).autoSave(this.selectedMode,param2,TimelineSelection.getPos(),_loc6_,this.selectedPos);
            }
            else
            {
               this.saveKeyframe(param2);
            }
         }
         var _loc4_:Graphics = this.flareMC.graphics;
      }
      
      private function drawBox(param1:Graphics, param2:int, param3:int, param4:int, param5:int, param6:uint = 0, param7:int = -1, param8:Number = 0, param9:int = -1, param10:Number = 0) : Object
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(param2 < 0 || param3 < 0 || param4 < 0 || param5 < 0 || param4 < Channel.cellOffset || param2 > Channel.cellOffset + Channel.visibleCells)
         {
            return null;
         }
         param2 = Utils.limit(param2 - Channel.cellOffset,0,Channel.visibleCells - 1);
         param4 = Utils.limit(param4 - Channel.cellOffset,0,Channel.visibleCells - 1);
         _loc11_ = param2 * Channel.CELL_WIDTH - 1;
         _loc12_ = param3 * Channel.CELL_HEIGHT - 1;
         _loc13_ = (param4 + 1) * Channel.CELL_WIDTH + 1;
         _loc14_ = (param5 + 1) * Channel.CELL_HEIGHT - 1;
         if(param6 > 0 && param7 > -1 && param8 > 0)
         {
            param1.lineStyle(param6,param7,param8);
         }
         if(param9 > -1 && param10 > 0)
         {
            param1.beginFill(param9,param10);
         }
         param1.moveTo(_loc11_,_loc12_);
         param1.lineTo(_loc13_,_loc12_);
         param1.lineTo(_loc13_,_loc14_);
         param1.lineTo(_loc11_,_loc14_);
         param1.lineTo(_loc11_,_loc12_);
         if(param9 > -1 && param10 > 0)
         {
            param1.endFill();
         }
         return {
            "x":_loc11_,
            "y":_loc12_,
            "width":_loc13_ - _loc11_,
            "height":_loc14_ - _loc12_
         };
      }
      
      public function saveKeyframe(param1:Object, param2:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = this.selectedMode;
         }
         if(this.selectedChannel == -1)
         {
            this.selectedChannel = this.newChannel(this.selectedTarget);
         }
         if(this.selectedChannel != -1)
         {
            this.currentChannel.saveKeyframe(param2,this.selectedPos,param1);
            this.redraw();
         }
      }
      
      public function deleteKeyframe() : void
      {
         this.currentChannel.deleteKeyframe(this.selectedMode,this.selectedPos);
         if(AUTO_EMPTY && this.currentChannel.getNumKeyframes(Animation.ALL) == 0)
         {
            this.clear();
         }
         else
         {
            this.redraw();
         }
      }
      
      public function updateScene() : void
      {
         var _loc1_:Channel = null;
         this.updateCellsUsed();
         for each(_loc1_ in this.channels)
         {
            _loc1_.updateScene(this.selectedPos,Animation.isLooping);
         }
      }
      
      private function updateCellsUsed() : void
      {
         var _loc1_:Channel = null;
         Channel.cellsUsed = this.getMaxCells();
         if(MAINTAIN_LENGTH)
         {
            for each(_loc1_ in this.channels)
            {
               _loc1_.setLength(Channel.cellsUsed);
            }
         }
      }
      
      private function getMaxCells() : uint
      {
         var _loc2_:Channel = null;
         var _loc3_:uint = 0;
         if(this.isEmpty())
         {
            return 0;
         }
         var _loc1_:uint = 0;
         for each(_loc2_ in this.channels)
         {
            _loc3_ = _loc2_.getMaxCellsUsed();
            if(_loc3_ > _loc1_)
            {
               _loc1_ = _loc3_;
            }
         }
         return _loc1_;
      }
      
      public function canInsert() : Boolean
      {
         return this.selectedPos > 0 && this.selectedPos <= Animation.maxFrames - 1 && (this.channelExists() && this.selectedPlacement == null || this.selectedPlacement != null && this.selectedPos == this.selectedPlacement.position);
      }
      
      public function canRemove() : Boolean
      {
         return this.channelExists() && this.selectedPos < this.currentChannel.getMaxCellsUsed(this.selectedMode) && this.selectedPos > 0;
      }
      
      public function atEnd() : Boolean
      {
         return this.selectedPos == Channel.cellsUsed - 1;
      }
      
      public function getFrame(param1:Boolean) : uint
      {
         var _loc2_:Channel = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.channelExists())
         {
            return this.currentChannel.getFrame(this.selectedMode,this.selectedPos,param1);
         }
         _loc4_ = param1 == Channel.BACK ? uint(0) : uint(Animation.maxFrames - 1);
         for each(_loc2_ in this.channels)
         {
            _loc3_ = _loc2_.getFrameAllModes(this.selectedPos,param1);
            if(param1 == Channel.BACK && _loc3_ > _loc4_ || param1 == Channel.NEXT && _loc3_ < _loc4_)
            {
               _loc4_ = _loc3_;
            }
         }
         return _loc4_;
      }
      
      public function isEmpty(param1:Object = null) : Boolean
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return this.channels == null || this.channels.length == 0;
         }
         _loc2_ = this.getChannelIndex(param1);
         if(_loc2_ > -1)
         {
            return Channel(this.channels[_loc2_]).isEmpty();
         }
         return true;
      }
      
      public function getChannelIndex(param1:Object) : int
      {
         var _loc2_:uint = 0;
         if(this.isEmpty() || param1 == null)
         {
            return -1;
         }
         var _loc3_:uint = this.channels.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(Channel(this.channels[_loc2_]).target == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getScrollData() : Object
      {
         return {
            "unit":Channel.CELL_WIDTH,
            "track":Channel.visibleCells,
            "max":Animation.maxFrames
         };
      }
      
      public function getCharacters() : Array
      {
         var _loc2_:Channel = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.channels)
         {
            if(_loc2_.target is Character)
            {
               _loc1_.push(_loc2_.target);
            }
         }
         return _loc1_;
      }
      
      public function saveSequence(param1:String) : void
      {
         var _loc2_:Sequence = new Sequence();
         _loc2_.setTarget(this.selectedTarget);
         _loc2_.setTimelineData(this.getData(this.selectedPos,this.channelMap[this.selectedChannel][this.selectedMode],TimelineSelection.getCells(),TimelineSelection.getRows(),true));
         _loc2_.setName(param1 + " (" + (TimelineSelection.getCells() - 1) + ")");
         Main.saveSequence(_loc2_);
         var _loc3_:Placement = new Placement();
         _loc3_.setSequence(_loc2_);
         _loc3_.setNumCells(_loc2_.getNumCells());
         _loc3_.setTarget(this.selectedTarget);
         _loc3_.setPosition(this.selectedPos);
         Placement.save(_loc3_);
         this.redraw();
      }
      
      public function getData(param1:int = -1, param2:int = -1, param3:int = -1, param4:int = -1, param5:Boolean = false) : Array
      {
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         if(this.channels.length > 0)
         {
            _loc6_ = [];
            if(param1 > -1)
            {
               _loc11_ = (_loc10_ = param2) + param4;
               _loc9_ = _loc10_;
               while(_loc9_ < _loc11_)
               {
                  _loc7_ = Channel(this.channels[this.rowMap[_loc9_].channel]);
                  (_loc8_ = {}).d = Channel(_loc7_).getData(this.rowMap[_loc9_].mode,param1,1,param3,param5);
                  Editor.getTargetInfo(_loc8_,Channel(_loc7_).target);
                  _loc6_.push(_loc8_);
                  _loc9_++;
               }
            }
            else
            {
               for each(_loc7_ in this.channels)
               {
                  (_loc8_ = {}).d = Channel(_loc7_).getData();
                  Editor.getTargetInfo(_loc8_,Channel(_loc7_).target);
                  _loc6_.push(_loc8_);
               }
            }
         }
         return _loc6_;
      }
      
      private function applyPlacement(param1:Placement) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = param1.getTimelineData();
         var _loc4_:uint = _loc3_.length;
         var _loc5_:int;
         if((_loc5_ = this.getChannelIndex(param1.target)) == -1)
         {
            _loc5_ = this.newChannel(param1.target);
         }
         if(_loc5_ != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               Channel(this.channels[_loc5_]).setData(_loc3_[_loc2_].d,_loc3_[_loc2_].d.data[0].m,param1.position,param1.getNumCells());
               _loc2_++;
            }
         }
      }
      
      public function setData(param1:Array = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Channel = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(this.channels != null)
         {
            for each(_loc4_ in this.channels)
            {
               this.channelsMC.removeChild(_loc4_);
            }
         }
         this.channels = [];
         if(param1 != null)
         {
            for each(_loc6_ in param1)
            {
               if((_loc5_ = Editor.getTargetFromInfo(_loc6_)) != null)
               {
                  _loc3_ = this.newChannel(_loc5_);
                  if(_loc3_ != -1)
                  {
                     Channel(this.channels[_loc3_]).setData(_loc6_.d);
                  }
               }
            }
         }
         if(!param2)
         {
            this.clearPosition();
            this.selectOneCell();
         }
      }
      
      private function clearPlacement() : void
      {
         Placement.remove(this.selectedPlacement);
         this.selectOneCell();
         this.remap();
         this.redraw();
      }
      
      private function clearCells() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.channelMap[this.selectedChannel][this.selectedMode];
         _loc3_ = _loc2_ + TimelineSelection.getRows();
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            Channel(this.channels[this.rowMap[_loc1_].channel]).clearCells(this.rowMap[_loc1_].mode,TimelineSelection.getPos(),TimelineSelection.getCells());
            _loc1_++;
         }
         if(this.selectedPos >= this.getMaxCells())
         {
            this.dispatchEvent(new PixtonEvent(PixtonEvent.POSITION_CHANGE,this.getMaxCells() - 1));
            this.selectOneCell();
         }
      }
      
      public function clear(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         if(param1 == null)
         {
            if(param2)
            {
               _loc4_ = this.channels.length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  this.clearChannel(_loc3_,-1);
                  _loc3_++;
               }
            }
            else if(this.selectedPlacement == null)
            {
               if(TimelineSelection.getCells() > 1 || TimelineSelection.getRows() > 1)
               {
                  this.clearCells();
               }
               else
               {
                  this.clearChannel(this.selectedChannel,this.selectedMode);
               }
            }
            else
            {
               this.clearPlacement();
            }
         }
         else
         {
            _loc3_ = this.getChannelIndex(param1);
            if(_loc3_ > -1)
            {
               this.clearChannel(_loc3_);
            }
         }
         this.redraw();
      }
      
      public function anyChannelsExist() : Boolean
      {
         return this.channels != null && this.channels.length > 0;
      }
      
      public function channelExists() : Boolean
      {
         return this.selectedChannel > -1 && this.currentChannel.modeExists(this.selectedMode);
      }
      
      private function newChannel(param1:Object) : int
      {
         if(this.channels.length >= Animation.maxChannels)
         {
            Utils.alert(L.text("animation-channels",Animation.maxFrames,Animation.maxChannels));
            return -1;
         }
         var _loc2_:Channel = new Channel(param1);
         this.channelsMC.addChild(_loc2_);
         this.channels.push(_loc2_);
         return this.channels.length - 1;
      }
      
      private function clearChannel(param1:int, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 > -1)
         {
            Placement.clear(Channel(this.channels[param1]).target,param2);
            if(AUTO_EMPTY)
            {
               if(param2 > -1)
               {
                  Channel(this.channels[param1]).clear(param2);
                  this.selectedChannel = this.getChannelIndex(this.selectedTarget);
                  this.selectedMode = Channel(this.channels[param1]).getFirstMode();
               }
               if(param2 == -1 || Channel(this.channels[param1]).isEmpty())
               {
                  this.channelsMC.removeChild(this.channels[param1]);
                  delete global[this.channels.splice(param1,1)];
                  this.selectedChannel = -1;
                  this.selectedTarget = null;
               }
            }
            else
            {
               Channel(this.channels[param1]).clear();
            }
            this.arrange();
            this.selectOneCell();
         }
         else
         {
            _loc4_ = this.channels.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.clearChannel(0);
               _loc3_++;
            }
         }
      }
      
      private function arrange() : void
      {
         var _loc1_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         if(this.isEmpty())
         {
            return;
         }
         this.rowMap = [];
         this.channelMap = [];
         this.channels.sortOn(["targetZOrder"]);
         var _loc2_:uint = this.channels.length;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.channels[_loc1_].y = _loc3_;
            _loc3_ += Channel(this.channels[_loc1_]).getHeight();
            this.channelMap[_loc1_] = [];
            _loc6_ = (_loc7_ = Channel(this.channels[_loc1_]).getModes()).length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               this.channelMap[_loc1_][_loc7_[_loc5_]] = _loc4_;
               var _loc8_:*;
               this.rowMap[_loc8_ = _loc4_++] = {
                  "channel":_loc1_,
                  "mode":_loc7_[_loc5_]
               };
               _loc5_++;
            }
            _loc1_++;
         }
         this.channelHeight = _loc3_;
      }
      
      public function getHeight() : Number
      {
         return this.channelHeight + Math.round(Channel.CELL_HEIGHT * 0.5);
      }
      
      public function autoScale() : void
      {
         var _loc1_:Channel = null;
         var _loc2_:Channel = null;
         for each(_loc1_ in this.channels)
         {
            if(_loc1_.target is Editor)
            {
               _loc2_ = _loc1_;
            }
         }
         if(_loc2_ != null)
         {
            this.currentChannel.autoScale(this.selectedPos,_loc2_);
         }
      }
      
      public function hasChannel(param1:Object, param2:uint) : Boolean
      {
         var _loc3_:int = this.getChannelIndex(param1);
         if(_loc3_ > -1)
         {
            if(this.channelMap[_loc3_] != null)
            {
               if(this.channelMap[_loc3_][param2] != null)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function remap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Placement = null;
         if(this.channelMap == null)
         {
            return;
         }
         this.map = [];
         var _loc11_:Array;
         var _loc12_:uint = (_loc11_ = Placement.getList()).length;
         _loc1_ = 0;
         while(_loc1_ < _loc12_)
         {
            _loc7_ = (_loc10_ = _loc11_[_loc1_]).position;
            _loc8_ = _loc10_.getNumCells();
            _loc9_ = _loc10_.getNumRows();
            _loc3_ = _loc7_ + _loc8_;
            _loc2_ = this.getChannelIndex(_loc10_.target);
            if(_loc2_ != -1)
            {
               _loc6_ = (_loc5_ = this.getFirstRow(_loc10_)) + _loc9_;
               _loc4_ = _loc5_;
               while(_loc4_ < _loc6_)
               {
                  if(this.map[_loc4_] == null)
                  {
                     this.map[_loc4_] = [];
                  }
                  _loc2_ = _loc7_;
                  while(_loc2_ < _loc3_)
                  {
                     this.map[_loc4_][_loc2_] = _loc10_;
                     _loc2_++;
                  }
                  _loc4_++;
               }
            }
            _loc1_++;
         }
      }
      
      private function onStateChange() : void
      {
         dispatchEvent(new PixtonEvent(PixtonEvent.STATE_CHANGE,this));
      }
   }
}
