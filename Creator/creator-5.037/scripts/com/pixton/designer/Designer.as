package com.pixton.designer
{
   import com.pixton.editor.Character;
   import com.pixton.editor.Editor;
   import com.pixton.editor.Globals;
   import com.pixton.editor.L;
   import com.pixton.editor.Main;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Picker;
   import com.pixton.editor.Utils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public final class Designer extends MovieClip
   {
      
      public static const WH_RATIO:Number = 0.75;
      
      public static const FIXED_WIDTH:Number = 600;
      
      public static const FIXED_HEIGHT:Number = 400;
      
      public static const FIXED_Y:Number = 130;
      
      public static const MAX_ITEM_HEIGHT:Number = 180;
      
      public static const MAX_ITEM_WIDTH:Number = 150;
      
      public static var skinType:uint = 0;
      
      private static const BUTTON_SPACING:Number = 10;
      
      private static const BUTTON_COLOR:Array = [183,182,181];
      
      static var selectedButton:Array = [];
      
      static var highlightedButton:DesignerButton;
      
      private static var _instance:Designer;
       
      
      public var btnToggleBasic:MovieClip;
      
      public var stepProgressContainer:MovieClip;
      
      private var _isBasic:Boolean = true;
      
      private var char:Character;
      
      private var currentStep:int = -1;
      
      private var steps:Array;
      
      private var numBasicSteps:uint;
      
      private var numSteps:uint;
      
      private var stepContainer:MovieClip;
      
      private var recentDirection:int = 1;
      
      public function Designer()
      {
         super();
         if(!_instance)
         {
            _instance = this;
            this.x = -2;
            this.y = -3;
            this.stepContainer = new MovieClip();
            this.addChild(this.stepContainer);
            Utils.useHand(this.btnToggleBasic);
            Utils.addListener(this.btnToggleBasic,MouseEvent.CLICK,this.onToggleBasic);
            this.btnToggleBasic.txtLabel.autoSize = "left";
            this.btnToggleBasic.x = -3;
            this.stepProgressContainer.txtLabel.width = FIXED_WIDTH;
            this.stepProgressContainer.y = FIXED_HEIGHT + 16;
            visible = false;
            return;
         }
         throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
      }
      
      public static function getInstance() : Designer
      {
         return !!_instance ? _instance : new Designer();
      }
      
      private function onToggleBasic(param1:MouseEvent = null) : void
      {
         this._isBasic = !this._isBasic;
         this.update();
         Main.self.onUpdateDesigner(Picker.btnForward && !Picker.btnForward.visible);
      }
      
      private function update() : void
      {
         this.btnToggleBasic.visible = skinType == Globals.HUMAN;
         this.btnToggleBasic.txtLabel.text = L.text(!!this._isBasic ? "advanced-show" : "advanced-hide");
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = Palette.rgb2hex(Palette.colorLink);
         this.btnToggleBasic.txtLabel.setTextFormat(_loc1_);
         this.btnToggleBasic.y = -(27 + (!!this._isBasic ? 0 : DesignerButton.HEIGHT + DesignerButton.GAP));
         this.stepContainer.visible = !this._isBasic && this.btnToggleBasic.visible;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:Array = param1.designer;
         if(param1.cca == 1)
         {
            this.onToggleBasic();
         }
         if(param1.ccs != null)
         {
            skinType = param1.ccs;
         }
         this.steps = [];
         this.numSteps = 0;
         this.numBasicSteps = 0;
         this.createSteps(_loc2_,0);
         this.update();
         visible = true;
      }
      
      private function createSteps(param1:Array, param2:uint) : MovieClip
      {
         var _loc4_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:DesignerButton = null;
         var _loc9_:MovieClip = null;
         var _loc3_:MovieClip = new MovieClip();
         this.stepContainer.addChild(_loc3_);
         var _loc5_:uint = param1.length;
         _loc3_.x = param2 * (DesignerButton.WIDTH + DesignerButton.GAP + BUTTON_SPACING);
         var _loc8_:Number = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1[_loc4_];
            if(!(!Character.ALLOW_FEMALE && (_loc6_.name == "breasts" || _loc6_.part == "breasts")))
            {
               _loc7_ = new DesignerButton();
               _loc3_.addChild(_loc7_);
               _loc7_.setData(_loc4_,_loc6_);
               _loc7_.setOriginalX(_loc8_);
               _loc7_.y = -DesignerButton.GAP;
               _loc7_.num = this.steps.length;
               _loc7_.tier = param2;
               if(_loc6_.basic === true || _loc6_.advanced === false)
               {
                  _loc6_.basicStepNum = this.numBasicSteps;
                  ++this.numBasicSteps;
               }
               _loc7_.rgb = BUTTON_COLOR;
               Utils.addListener(_loc7_,MouseEvent.CLICK,this.onStep);
               this.steps.push(_loc7_);
               if(_loc6_.steps != null)
               {
                  _loc7_.setSteps(this.createSteps(_loc6_.steps,param2 + 1));
               }
               else
               {
                  _loc6_.stepNum = this.numSteps;
                  ++this.numSteps;
               }
               if(_loc6_.advanced === false)
               {
                  _loc7_.alpha = 0;
                  _loc7_.mouseEnabled = false;
                  _loc7_.mouseChildren = false;
               }
               else
               {
                  _loc8_ += DesignerButton.WIDTH + DesignerButton.GAP;
               }
            }
            _loc4_++;
         }
         if(param2 > 0)
         {
            _loc9_ = new designerArrow();
            _loc3_.addChild(_loc9_);
            _loc9_.x = -BUTTON_SPACING * 0.5;
            _loc9_.y = -(DesignerButton.HEIGHT + DesignerButton.GAP) * 0.5;
         }
         return _loc3_;
      }
      
      private function onStep(param1:MouseEvent) : void
      {
         if(param1.currentTarget == highlightedButton)
         {
            return;
         }
         this.goto(DesignerButton(param1.currentTarget),true);
      }
      
      public function start() : void
      {
         visible = true;
         this.char = Editor.self.getCharacter() as Character;
         Editor.self.setSelection(this.char as Object);
         this.navigate(1);
      }
      
      public function navigate(param1:int, param2:Boolean = false) : void
      {
         stage.focus = null;
         this.goto(this.steps[this.currentStep + param1] as DesignerButton,param2);
      }
      
      public function goto(param1:DesignerButton, param2:Boolean = false) : void
      {
         var _loc6_:Object = null;
         var _loc7_:* = null;
         var _loc8_:Object = null;
         if(highlightedButton != null)
         {
            highlightedButton.highlighted = false;
         }
         if(selectedButton[param1.tier] != null)
         {
            DesignerButton(selectedButton[param1.tier]).selected = false;
            if(selectedButton[param1.tier + 1] != null)
            {
               DesignerButton(selectedButton[param1.tier + 1]).selected = false;
               if(selectedButton[param1.tier + 2] != null)
               {
                  DesignerButton(selectedButton[param1.tier + 2]).selected = false;
               }
            }
         }
         param1.selected = true;
         param1.highlighted = true;
         var _loc3_:uint = param1.num;
         this.recentDirection = _loc3_ - this.currentStep >= 0 ? 1 : -1;
         this.currentStep = Utils.limit(_loc3_,0,this.steps.length);
         var _loc4_:int = 0;
         var _loc5_:Object = param1.data;
         if(param1.getSteps() == null)
         {
            Editor.self.setZoom(Editor.ZOOM_BODY,false);
            if(!param2 && this._isBasic && _loc5_.basic == null && _loc5_.advanced == null)
            {
               _loc4_ = this.recentDirection;
            }
            else if(!this._isBasic && _loc5_.advanced === false)
            {
               _loc4_ = this.recentDirection;
            }
            else if(!param2 && _loc5_.skip != null)
            {
               for(_loc7_ in _loc5_.skip)
               {
                  if(_loc5_.skip[_loc7_] is Array && Utils.inArray(this.char.bodyParts.getPart(_loc7_).look,_loc5_.skip[_loc7_]) || _loc5_.skip[_loc7_] < 0 && this.char.bodyParts.getPart(_loc7_).look != -_loc5_.skip[_loc7_] || _loc5_.skip[_loc7_] === true && this.char.bodyParts.getPart(_loc7_).look > 0 || this.char.bodyParts.getPart(_loc7_).look == _loc5_.skip[_loc7_])
                  {
                     _loc4_ = this.recentDirection;
                  }
               }
            }
            _loc6_ = _loc5_;
            if(_loc5_.part != null && !(_loc5_.part is Array))
            {
               if(!param2 && _loc5_.stretch == null)
               {
                  if(!this._isBasic && _loc5_.color == null && _loc5_.lockList == null)
                  {
                     _loc5_.list = null;
                  }
                  if(Character.editingSkinType == Globals.HUMAN)
                  {
                     if((_loc8_ = this.char.bodyParts.getGenderLooks(_loc5_.part)) != null)
                     {
                        _loc5_.list = this.makeList(this.char.bodyParts.getPart(_loc5_.part).numLooks,_loc8_,_loc5_.list);
                        if(_loc5_.list.length < 2 && !param2)
                        {
                           _loc4_ = this.recentDirection;
                        }
                     }
                  }
               }
               this.char.selectPart(this.char.bodyParts.target[_loc5_.part]);
               _loc6_ = Utils.mergeObjects(_loc6_,this.char.clickData);
            }
            if(_loc4_ == 0)
            {
               Picker.load(Globals.DESIGNER,_loc6_,this.char,true);
            }
         }
         else
         {
            if(param1.tier == 2)
            {
               param1.parent.visible = false;
               param1.getSteps().x = param1.parent.x;
            }
            if(param1.tier == 2)
            {
               _loc4_ = this.recentDirection;
            }
            else if(!param2 && param1.tier == 1)
            {
               _loc4_ = this.recentDirection;
            }
            else if(!param2 && (selectedButton[param1.tier] == null || DesignerButton(param1.getSteps().getChildAt(0)).getSteps() == null))
            {
               _loc4_ = this.recentDirection;
            }
            else if(selectedButton[param1.tier + 1] != null)
            {
               DesignerButton(selectedButton[param1.tier + 1]).selected = false;
            }
         }
         selectedButton[param1.tier] = param1;
         highlightedButton = param1;
         if(_loc4_ != 0)
         {
            this.navigate(_loc4_,param2);
         }
         else
         {
            this.updateProgress();
         }
      }
      
      private function updateProgress() : void
      {
         if(highlightedButton == null || highlightedButton.getSteps() != null)
         {
            return;
         }
         var _loc1_:Object = highlightedButton.data;
         if(this._isBasic)
         {
            if(_loc1_.basicStepNum != null)
            {
               this.stepProgressContainer.txtLabel.text = L.text("step-chk",_loc1_.basicStepNum + 1,this.numBasicSteps);
            }
         }
         else if(_loc1_.stepNum != null)
         {
            this.stepProgressContainer.txtLabel.text = L.text("step-chk",_loc1_.stepNum + 1,this.numSteps);
         }
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = Palette.rgb2hex(Palette.colorText3);
         this.stepProgressContainer.txtLabel.setTextFormat(_loc2_);
      }
      
      private function makeList(param1:uint, param2:Object, param3:Array = null) : Array
      {
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < param1)
         {
            if(!(param3 != null && !Utils.inArray(_loc5_,param3)))
            {
               if(!(param2.exc != null && Utils.inArray(_loc5_,param2.exc) || param2.inc != null && !Utils.inArray(_loc5_,param2.inc)))
               {
                  _loc4_.push(_loc5_);
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function gotoEnd() : void
      {
         this.currentStep = this.steps.length - 1;
      }
      
      public function isFirst() : Boolean
      {
         return this.currentStep <= 1;
      }
      
      public function isLast() : Boolean
      {
         return this.currentStep >= this.steps.length - 1;
      }
      
      public function getActiveColor() : uint
      {
         if(selectedButton[0] == null || DesignerButton(selectedButton[0]).rgb == null)
         {
            return Palette.RGBtoHex(BUTTON_COLOR);
         }
         return Palette.RGBtoHex(DesignerButton(selectedButton[0]).rgb);
      }
      
      public function isBasic() : Boolean
      {
         return this._isBasic;
      }
   }
}
