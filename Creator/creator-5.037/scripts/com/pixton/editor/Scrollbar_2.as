package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public final class Scrollbar extends MovieClip
   {
       
      
      public var handle:MovieClip;
      
      public var track:MovieClip;
      
      private var _offset:uint = 0;
      
      private var unit:Number;
      
      private var maxOffset:Number;
      
      private var range:Number;
      
      private var visibleCells:Number;
      
      private var startO:Number;
      
      private var startX:Number;
      
      public function Scrollbar()
      {
         super();
         Utils.useHand(this.handle);
         Utils.addListener(this.handle,MouseEvent.MOUSE_DOWN,this.startScroll);
      }
      
      public function setData(param1:Object) : void
      {
         this.unit = param1.unit;
         this.visibleCells = param1.track;
         this.maxOffset = param1.max - this.visibleCells;
         this.track.width = this.visibleCells * this.unit;
         this.handle.width = this.visibleCells * this.visibleCells / param1.max * this.unit;
         this.range = this.track.width - this.handle.width;
      }
      
      public function set offset(param1:uint) : void
      {
         this._offset = param1;
         this.handle.x = this._offset / this.maxOffset * this.range;
         this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,param1));
      }
      
      public function get offset() : uint
      {
         return this._offset;
      }
      
      private function startScroll(param1:MouseEvent) : void
      {
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateScroll);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopScroll);
         this.startX = param1.stageX;
         this.startO = this.handle.x;
      }
      
      private function updateScroll(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.startO + (param1.stageX - this.startX);
         this.offset = Math.round(Utils.limit(_loc2_ / this.range * this.maxOffset,0,this.maxOffset));
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateScroll);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopScroll);
      }
   }
}
