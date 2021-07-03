package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class PanelText extends MovieClip
   {
       
      
      public var bkgd:MovieClip;
      
      public var txtValue:TextField;
      
      protected var padding:uint = 0;
      
      private var tf:TextFormat;
      
      private var _editing:Boolean = false;
      
      private var _isInput:Boolean = false;
      
      private var _editable:Boolean = false;
      
      private var _enabled:Boolean = true;
      
      private var _defaultValue:String = "";
      
      public function PanelText()
      {
         super();
         this.padding = this.txtValue.x;
         this.txtValue.text = "";
         this.tf = new TextFormat();
         if(this.txtValue.type == TextFieldType.INPUT)
         {
            this._isInput = true;
            this.setEditable(true);
         }
      }
      
      public function setEditable(param1:Boolean) : void
      {
         if(!this._isInput)
         {
            return;
         }
         this._editable = param1;
         if(this._editable)
         {
            this.txtValue.type = TextFieldType.INPUT;
            Utils.addListener(this.txtValue,FocusEvent.FOCUS_IN,this.onFocus);
            Utils.addListener(this.txtValue,FocusEvent.FOCUS_OUT,this.onFocusOut);
            Utils.addListener(this.txtValue,Event.CHANGE,this.onChange);
         }
         else
         {
            this.txtValue.type = TextFieldType.DYNAMIC;
            Utils.removeListener(this.txtValue,FocusEvent.FOCUS_IN,this.onFocus);
            Utils.removeListener(this.txtValue,FocusEvent.FOCUS_OUT,this.onFocusOut);
            Utils.removeListener(this.txtValue,Event.CHANGE,this.onChange);
         }
      }
      
      public function isEditable() : Boolean
      {
         return this._editable;
      }
      
      private function onChange(param1:Event) : void
      {
         this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,this));
      }
      
      public function setWidth(param1:uint) : void
      {
         this.txtValue.width = param1 - this.padding * 2;
         this.bkgd.width = param1;
      }
      
      public function setHeight(param1:uint) : void
      {
         this.txtValue.height = param1 - this.padding;
         this.bkgd.height = param1;
      }
      
      public function getHeight() : uint
      {
         return this.bkgd.height;
      }
      
      public function updateColor() : void
      {
      }
      
      protected function updateColors(param1:uint, param2:Array) : void
      {
         this.tf.color = param1;
         this.txtValue.defaultTextFormat = this.tf;
         Utils.setColor(this.bkgd,param2);
      }
      
      protected function onFocus(param1:FocusEvent) : void
      {
         this._editing = true;
         Editor.startLock();
         if(this.txtValue.text == this.getDefaultValue())
         {
            this.txtValue.text = "";
         }
      }
      
      protected function onFocusOut(param1:FocusEvent) : void
      {
         this._editing = false;
         Editor.endLock();
         var _loc2_:String = this.txtValue.text;
         _loc2_ = Filter.filter(_loc2_);
         if(_loc2_ == "")
         {
            _loc2_ = this.getDefaultValue();
         }
         this.txtValue.text = _loc2_;
      }
      
      public function hasFocus() : Boolean
      {
         return this._editing;
      }
      
      public function setDefaultValue(param1:String) : void
      {
         this._defaultValue = param1;
      }
      
      protected function getDefaultValue() : String
      {
         return this._defaultValue;
      }
      
      public function getText() : String
      {
         if(this.txtValue.text != this.getDefaultValue())
         {
            return this.txtValue.text;
         }
         return "";
      }
      
      public function hasText() : Boolean
      {
         return this.getText() != "";
      }
      
      public function setText(param1:String) : void
      {
         if(this._isInput && (param1 == null || param1 == ""))
         {
            this.txtValue.text = this.getDefaultValue();
         }
         else
         {
            this.txtValue.text = param1;
         }
         this.onChangeText();
      }
      
      public function set enableState(param1:Boolean) : void
      {
         this.txtValue.type = !!param1 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.txtValue.selectable = param1;
         this.txtValue.mouseEnabled = param1;
      }
      
      protected function onChangeText(param1:Event = null) : void
      {
      }
   }
}
