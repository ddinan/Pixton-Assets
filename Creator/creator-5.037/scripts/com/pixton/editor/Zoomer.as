package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class Zoomer extends MovieClip
   {
      
      public static const MIN_ZOOM:Number = -2;
      
      public static const MAX_ZOOM:Number = 1.2;
      
      private static const MIN:uint = 0;
      
      private static const MAX:uint = 1;
      
      static const DEF_MIN:uint = 0;
      
      static const DEF_MAX:uint = 100;
      
      static const DEF_MIN_BASIC:uint = 50;
      
      static const DEF_MAX_BASIC:uint = 80;
       
      
      public var handle:MovieClip;
      
      public var track:MovieClip;
      
      public var bkgd:MovieClip;
      
      public var valueContainer:MovieClip;
      
      public var txtValue:TextField;
      
      private var startPos:Object;
      
      private var startHandleY:Number;
      
      private var clickTime:Number;
      
      private var _value:Number;
      
      private var _default:Number;
      
      private var range:Array;
      
      private var rangeLimit:Array;
      
      private var round:Boolean = true;
      
      private var _isFixed:Boolean = true;
      
      public function Zoomer()
      {
         super();
         this.txtValue = this.valueContainer.txtValue;
         this.hideLabel();
         this.setRange(DEF_MIN,DEF_MAX);
         this.setDefault(this.range[MIN]);
         this.handle.buttonMode = true;
         this.handle.useHandCursor = true;
         Utils.addListener(this.handle,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.handle,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.handle,MouseEvent.MOUSE_DOWN,this.startMove);
      }
      
      public function setColor(param1:Array) : void
      {
         if(this.bkgd)
         {
            if(this.bkgd.fill)
            {
               Utils.setColor(this.bkgd.fill,param1);
            }
            if(this.bkgd.fill2)
            {
               Utils.setColor(this.bkgd.fill2,Palette.colorBkgd);
            }
         }
      }
      
      public function setRange(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         this.range = [param1,param2];
         this.round = param3;
      }
      
      public function setRangeLimit(param1:Number, param2:Number) : void
      {
         this.rangeLimit = [param1,param2];
      }
      
      public function setDefault(param1:Number) : void
      {
         this._default = param1;
      }
      
      private function startMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!isNaN(this.clickTime))
         {
            _loc2_ = getTimer() - this.clickTime;
            if(_loc2_ < Pixton.CLICK_TIME)
            {
               if(name == "zoomer" && Main.controlPressed)
               {
                  Editor.self.resetScale();
               }
               else
               {
                  this.value = this._default;
               }
               return;
            }
         }
         this.clickTime = getTimer();
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         this.startPos = Utils.getEventPoint(param1,this);
         this.startHandleY = this.handle.y - this.track.y;
         this.updateLabel();
      }
      
      private function stopMove(param1:MouseEvent) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         dispatchEvent(new PixtonEvent(PixtonEvent.STATE_CHANGE,this));
      }
      
      private function updateMove(param1:MouseEvent) : void
      {
         var _loc2_:Object = Utils.getEventPoint(param1,this);
         if(this.rangeLimit == null)
         {
            this.value = this.range[MIN] + (this.startHandleY + _loc2_.y - this.startPos.y) / this.track.height * (this.range[MAX] - this.range[MIN]);
         }
         else
         {
            this.value = Utils.limit(this.range[MIN] + (this.startHandleY + _loc2_.y - this.startPos.y) / this.track.height * (this.range[MAX] - this.range[MIN]),this.rangeLimit[MIN],this.rangeLimit[MAX]);
         }
      }
      
      private function updateLabel(param1:MouseEvent = null) : void
      {
         if(this.round)
         {
            this.txtValue.text = Math.round(this.value).toString();
         }
         else
         {
            this.txtValue.text = (Math.round(this.value * 10) * 0.1).toString();
         }
      }
      
      private function showLabel(param1:MouseEvent = null) : void
      {
         this.valueContainer.visible = true;
      }
      
      private function hideLabel(param1:MouseEvent = null) : void
      {
         this.valueContainer.visible = false;
      }
      
      public function set isFixed(param1:Boolean) : void
      {
         if(!param1)
         {
            Utils.addListener(this,MouseEvent.ROLL_OVER,this.showLabel);
            Utils.addListener(this,MouseEvent.ROLL_OUT,this.hideLabel);
            this.hideLabel();
         }
         this._isFixed = param1;
      }
      
      public function get isFixed() : Boolean
      {
         return this._isFixed;
      }
      
      public function set value(param1:Number) : void
      {
         if(this.round)
         {
            param1 = Math.round(param1);
         }
         this.updateValue(param1);
         this.updateLabel();
         if(this.isFixed)
         {
            this.showLabel();
         }
         this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,this.value));
      }
      
      public function calculateValue(param1:Number) : Number
      {
         return (Math.log(param1) * Math.LOG10E - MIN_ZOOM) / (MAX_ZOOM - MIN_ZOOM) * this.maxValue();
      }
      
      public function calculateScale(param1:Number) : Number
      {
         return Math.pow(10,MIN_ZOOM + param1 / this.maxValue() * (MAX_ZOOM - MIN_ZOOM));
      }
      
      public function updateValue(param1:Number) : void
      {
         if(this.rangeLimit != null && param1 < this.rangeLimit[MIN])
         {
            param1 = this.rangeLimit[MIN];
         }
         else if(this.rangeLimit != null && param1 > this.rangeLimit[MAX])
         {
            param1 = this.rangeLimit[MAX];
         }
         else if(param1 < this.range[MIN])
         {
            param1 = this.range[MIN];
         }
         else if(param1 > this.range[MAX])
         {
            param1 = this.range[MAX];
         }
         this.handle.y = this.track.y + (param1 - this.range[MIN]) / (this.range[MAX] - this.range[MIN]) * this.track.height;
         this._value = param1;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = "";
         switch(name)
         {
            case "zoomer":
               _loc2_ = L.text("zoom");
               break;
            case "slider":
               _loc2_ = L.text("change-size");
         }
         Help.show(_loc2_,param1.currentTarget);
      }
      
      public function maxValue() : Number
      {
         return this.range[MAX];
      }
      
      private function hideHelp(param1:MouseEvent) : void
      {
         Help.hide();
      }
   }
}
