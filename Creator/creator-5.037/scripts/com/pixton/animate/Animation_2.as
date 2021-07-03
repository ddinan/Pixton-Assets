package com.pixton.animate
{
   import com.pixton.editor.AppSettings;
   import com.pixton.editor.Character;
   import com.pixton.editor.Comic;
   import com.pixton.editor.Confirm;
   import com.pixton.editor.Dialog;
   import com.pixton.editor.DisplayManager;
   import com.pixton.editor.Editor;
   import com.pixton.editor.Globals;
   import com.pixton.editor.Help;
   import com.pixton.editor.L;
   import com.pixton.editor.Main;
   import com.pixton.editor.MenuItem;
   import com.pixton.editor.Moveable;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Picker;
   import com.pixton.editor.Pixton;
   import com.pixton.editor.PixtonEvent;
   import com.pixton.editor.Popup;
   import com.pixton.editor.Prop;
   import com.pixton.editor.Scrollbar;
   import com.pixton.editor.Template;
   import com.pixton.editor.Utils;
   import com.pixton.editor.Zoomer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class Animation extends MovieClip
   {
      
      public static var MAX_BYTES:uint = 4000000;
      
      public static const ALL:int = -1;
      
      public static const INTERPOLATE_AUTO:uint = 0;
      
      public static const INTERPOLATE_LINEAR:uint = 1;
      
      public static const INTERPOLATE_COSINE:uint = 2;
      
      public static const INTERPOLATE_CUBIC:uint = 3;
      
      public static const INTERPOLATE_HERMITE:uint = 4;
      
      public static const INTERPOLATE_CONTINUOUS:uint = 0;
      
      public static const INTERPOLATE_COLOR:uint = 1;
      
      public static const INTERPOLATE_BINARY:uint = 2;
      
      public static const INTERPOLATE_BINARY_ONKEY:uint = 3;
      
      public static const TARGET_EDITOR:uint = 0;
      
      public static const TARGET_CHARACTER:uint = 1;
      
      public static const TARGET_DIALOG:uint = 2;
      
      public static const TARGET_PROP:uint = 3;
      
      public static const MODE_DEFAULT:uint = 0;
      
      public static const MODE_EXPR:uint = 1;
      
      public static const MODE_LOOKS:uint = 2;
      
      public static const AUTO_ALIGN_FEET:uint = 0;
      
      public static const AUTO_ALIGN_HAND_PROP:uint = 1;
      
      public static var animating:Boolean = false;
      
      public static var startCaptureFrame:uint = 0;
      
      public static var completelyRendered:Boolean = false;
      
      public static var self:Animation;
      
      private static const TIMELINE_PADDING:uint = 20;
      
      public static const PREF_ONION:uint = 1 << 0;
      
      public static const PREF_3D:uint = 1 << 1;
      
      public static const RENDER_CHUNK_SIZE:uint = 10000;
      
      public static var maxFrames:uint = 0;
      
      public static var maxChannels:uint = 0;
      
      public static var isLooping:Boolean = false;
      
      public static var optionVisible:Boolean = false;
      
      public static var isApplicableFormat:Boolean = false;
      
      private static const MARGIN_BOTTOM:Number = 10;
      
      private static const FPS_MIN:uint = 1;
      
      private static const FPS_MAX:uint = 24;
      
      public static var fps:Number = FPS_MAX;
      
      private static var available:Boolean = false;
      
      private static var preferences:uint = 0;
      
      private static var _prefsChanged:Boolean = false;
      
      private static var loading:Boolean = false;
      
      private static var dragging:Boolean = false;
      
      private static var interval:uint;
      
      private static var initialized:Boolean = false;
      
      private static var capturing:Boolean = false;
      
      private static var snapshots:Array;
      
      private static var autoStart:int = -1;
      
      private static var autoStop:int = -1;
      
      private static var autoMode:int = -1;
      
      private static var autoAlignData:Object;
      
      private static var dirty:Boolean = false;
       
      
      public var timeline:Timeline;
      
      public var playhead:Playhead;
      
      public var border:MovieClip;
      
      public var scrim:MovieClip;
      
      public var scrollbar:Scrollbar;
      
      public var txtCells:TextField;
      
      public var mnuRewind:MenuItem;
      
      public var mnuBack:MenuItem;
      
      public var mnuBack2:MenuItem;
      
      public var mnuPlay:MenuItem;
      
      public var mnuStop:MenuItem;
      
      public var mnuNext2:MenuItem;
      
      public var mnuNext:MenuItem;
      
      public var mnuEnd:MenuItem;
      
      public var mnuKAdd:MenuItem;
      
      public var mnuKDelete:MenuItem;
      
      public var mnuInsert:MenuItem;
      
      public var mnuRemove:MenuItem;
      
      public var mnuPreset:MenuItem;
      
      public var mnuSave:MenuItem;
      
      public var mnuSaveAnim:MenuItem;
      
      public var mnuFPS:MenuItem;
      
      public var mnuClear:MenuItem;
      
      public var mnuShow:MenuItem;
      
      public var mnuHide:MenuItem;
      
      public var mnuFeet:MenuItem;
      
      public var mnuHand:MenuItem;
      
      public var mnuAutoScale:MenuItem;
      
      public var mnuLoop:MenuItem;
      
      public var mnuOnion:MenuItem;
      
      public var slider:Zoomer;
      
      private var menu:Array;
      
      private var menuRight:Array;
      
      private var options:Array;
      
      private var allButtons:Array;
      
      private var playInterval:int = -1;
      
      public function Animation()
      {
         super();
         self = this;
         Main.displayManager.SET(this,DisplayManager.P_VIS,false);
         this.slider.visible = false;
         Utils.addListener(this.slider,PixtonEvent.CHANGE,this.onSlider);
         Utils.useHand(this.playhead);
         this.menu = [this.mnuSaveAnim,this.mnuFPS,this.mnuRewind,this.mnuBack,this.mnuBack2,this.mnuPlay,this.mnuStop,this.mnuNext2,this.mnuNext,this.mnuEnd,this.mnuKAdd,this.mnuKDelete,this.mnuInsert,this.mnuRemove,this.mnuShow,this.mnuHide,this.mnuPreset,this.mnuSave,this.mnuFeet,this.mnuHand,this.mnuAutoScale,this.mnuClear];
         this.menuRight = [this.mnuFPS,this.mnuSaveAnim];
         this.options = [this.mnuLoop,this.mnuOnion];
         this.allButtons = this.menu.concat(this.options);
         this.mnuRewind.disablable = true;
         Utils.addListener(this.playhead,MouseEvent.MOUSE_DOWN,this.onStartMove);
         Utils.addListener(this.timeline,PixtonEvent.SELECTION,this.onSelection);
         Utils.addListener(this.timeline,PixtonEvent.CHANGE,this.onTimelineChange);
         Utils.addListener(this.timeline,PixtonEvent.STATE_CHANGE,this.onStateChange);
         Utils.addListener(this.timeline,PixtonEvent.POSITION_CHANGE,this.onPositionChange);
         Utils.addListener(this.scrollbar,PixtonEvent.CHANGE,this.onScroll);
         Utils.addListener(this,Event.RENDER,this.onRender);
         Utils.addListener(this.scrim,MouseEvent.CLICK,this.onClickAway);
         Utils.addListener(this.border,MouseEvent.CLICK,this.onClickAway);
      }
      
      public static function init(param1:Object) : void
      {
         MAX_BYTES = param1.anim_max;
         optionVisible = param1.anim_opt == 1;
         isApplicableFormat = param1.anim_format == 1;
         available = param1.anim == 1;
         maxFrames = param1.anim_f;
         maxChannels = param1.anim_c == 0 ? uint(1000) : uint(param1.anim_c);
         Channel.visibleCells = Math.min(maxFrames,48);
         self.updateSize();
      }
      
      public static function updateVisibility() : void
      {
         Main.displayManager.SET(self,DisplayManager.P_VIS,available && !Template.isActive() && isApplicableFormat && Editor.self && Main.displayManager.GET(Editor.self,DisplayManager.P_VIS) && (AppSettings.getActive(AppSettings.ANIMATION) || !self.timeline.isEmpty()),true);
      }
      
      public static function setTargetData(param1:Object, param2:uint, param3:Array, param4:Number) : void
      {
         if(param1 is Editor)
         {
            Editor(param1).setAnimationData(param3,param4);
         }
         else if(param1 is Character)
         {
            Character(param1).setAnimationData(param2,param3,param4);
            if(capturing || autoStop > -1)
            {
               Character(param1).redraw(true);
            }
         }
         else if(param1 is Prop)
         {
            Prop(param1).setAnimationData(param3,param4);
         }
         else if(param1 is Dialog)
         {
            Dialog(param1).setAnimationData(param3,param4);
         }
      }
      
      public static function isPlaying() : Boolean
      {
         return animating;
      }
      
      public static function getTargetType(param1:Object) : int
      {
         if(param1 is Editor)
         {
            return Animation.TARGET_EDITOR;
         }
         if(param1 is Character)
         {
            return Animation.TARGET_CHARACTER;
         }
         if(param1 is Prop)
         {
            return Animation.TARGET_PROP;
         }
         if(param1 is Dialog)
         {
            return Animation.TARGET_DIALOG;
         }
         return -1;
      }
      
      public static function getAlignData(param1:Object) : Object
      {
         return Character(param1).getAlignData();
      }
      
      public static function interpolate(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:int = 0, param7:Boolean = false, param8:uint = 0, param9:uint = 0) : *
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         if(param2 == param3)
         {
            return param2;
         }
         if(param8 == INTERPOLATE_BINARY)
         {
            return param5 < 0.5 ? param2 : param3;
         }
         if(param8 == INTERPOLATE_BINARY_ONKEY)
         {
            return param2;
         }
         if(param6 > 0)
         {
            _loc10_ = Utils.wrap(param3 - param2,param6);
            _loc11_ = Utils.wrap(param4 - param3,param6);
            if(_loc10_ < param6 * 0.5)
            {
               param3 = param2 + _loc10_;
            }
            else
            {
               param3 = param2 + _loc10_ - param6;
            }
            if(_loc11_ < param6 * 0.5)
            {
               param4 = param3 + _loc11_;
            }
            else
            {
               param4 = param3 + _loc11_ - param6;
            }
         }
         if(param8 == INTERPOLATE_COLOR)
         {
            _loc12_ = Palette.getColor(param1);
            _loc13_ = Palette.getColor(param2);
            _loc14_ = Palette.getColor(param3);
            _loc15_ = Palette.getColor(param4);
            return [interpolateOne(param9,_loc12_[0],_loc13_[0],_loc14_[0],_loc15_[0],param5,param7),interpolateOne(param9,_loc12_[1],_loc13_[1],_loc14_[1],_loc15_[1],param5,param7),interpolateOne(param9,_loc12_[2],_loc13_[2],_loc14_[2],_loc15_[2],param5,param7)];
         }
         return interpolateOne(param9,param1,param2,param3,param4,param5,param7);
      }
      
      private static function interpolateOne(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : Number
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param1 == INTERPOLATE_AUTO)
         {
            if(param6 < 0.5)
            {
               if((param4 - param3) * (param3 - param2) > 0)
               {
                  param1 = INTERPOLATE_LINEAR;
               }
               else
               {
                  param1 = INTERPOLATE_COSINE;
               }
            }
            else if((param5 - param4) * (param4 - param3) > 0)
            {
               param1 = INTERPOLATE_LINEAR;
            }
            else
            {
               param1 = INTERPOLATE_COSINE;
            }
         }
         switch(param1)
         {
            case INTERPOLATE_LINEAR:
               _loc8_ = param3 + (param4 - param3) * param6;
               break;
            case INTERPOLATE_COSINE:
               _loc9_ = (1 - Math.cos(param6 * Math.PI)) / 2;
               _loc8_ = param3 * (1 - _loc9_) + param4 * _loc9_;
         }
         if(param7)
         {
            return Math.round(_loc8_);
         }
         return _loc8_;
      }
      
      public static function rewind() : void
      {
         self.rewind();
      }
      
      public static function allSaved() : Boolean
      {
         if(!available || !isApplicableFormat)
         {
            return true;
         }
         return self.allSaved();
      }
      
      public static function hasAnimation() : Boolean
      {
         if(!available || !isApplicableFormat)
         {
            return false;
         }
         return self.hasAnimation();
      }
      
      public static function captureFrames() : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.captureFrames();
      }
      
      public static function getStoredImages() : Object
      {
         if(!available || !isApplicableFormat)
         {
            return null;
         }
         return self.getStoredImages();
      }
      
      public static function getImagesSize() : uint
      {
         if(!available || !isApplicableFormat)
         {
            return 0;
         }
         return self.getImagesSize();
      }
      
      public static function clearCapture() : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.clearCapture();
      }
      
      public static function setXY(param1:Number, param2:Number) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         Main.displayManager.SET(self,DisplayManager.P_X,Math.min(param1,Comic.maxWidth - self.border.width));
         Main.displayManager.SET(self,DisplayManager.P_Y,param2);
      }
      
      public static function getBottom() : Number
      {
         if(!available || !isApplicableFormat)
         {
            return 0;
         }
         return self.getBottom();
      }
      
      public static function isAvailable() : Boolean
      {
         return available;
      }
      
      public static function getData() : String
      {
         if(!available || !isApplicableFormat)
         {
            return null;
         }
         return self.getData();
      }
      
      public static function setData(param1:String, param2:Boolean = false) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.setData(param1,param2);
      }
      
      public static function unsetData() : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.unsetData();
      }
      
      public static function previewOnion(param1:Object) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.previewOnion(param1);
      }
      
      public static function update(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.update(param1,param2,param3);
      }
      
      public static function autoSave(param1:Object, param2:uint, param3:Boolean = false) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.autoSave(param1,param2,param3);
      }
      
      public static function onRemoveTarget(param1:Object) : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.onRemoveTarget(param1);
      }
      
      public static function reset() : void
      {
         if(!available || !isApplicableFormat)
         {
            return;
         }
         self.reset();
      }
      
      public static function setPreferences(param1:uint) : void
      {
         preferences = param1;
         self.mnuOnion.toggleState = can(PREF_ONION);
      }
      
      public static function can(param1:uint) : Boolean
      {
         return available && isApplicableFormat && preferences & param1;
      }
      
      public static function makeAble(param1:uint, param2:Boolean = true) : void
      {
         if(param2)
         {
            preferences |= param1;
         }
         else
         {
            preferences &= ~param1;
         }
      }
      
      public static function getPreferences() : uint
      {
         return preferences;
      }
      
      public static function getPrefsChanged() : Boolean
      {
         return _prefsChanged;
      }
      
      public static function setPrefsChanged(param1:Boolean) : void
      {
         _prefsChanged = param1;
      }
      
      public static function hasChannel(param1:Object, param2:uint) : Boolean
      {
         return self.timeline.hasChannel(param1,param2);
      }
      
      private function onClickAway(param1:MouseEvent) : void
      {
         this.slider.visible = false;
         Editor.self.onClickAway();
      }
      
      private function updateSize() : void
      {
         this.border.width = this.timeline.x + Channel.CELL_WIDTH * (Channel.visibleCells + 2);
         this.scrim.width = this.border.width;
         this.mnuLoop.x = this.border.width + MenuItem.GAP;
      }
      
      private function onStartMove(param1:MouseEvent) : void
      {
         dragging = true;
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.onUpdateMove);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onStopMove);
      }
      
      private function onUpdateMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Number = _loc2_.x - this.timeline.x;
         var _loc4_:uint = Channel.cellOffset + Math.floor(_loc3_ / Channel.CELL_WIDTH);
         this.setPlayhead(_loc4_);
      }
      
      private function onStopMove(param1:MouseEvent) : void
      {
         dragging = false;
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.onUpdateMove);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onStopMove);
      }
      
      private function onSelection(param1:PixtonEvent) : void
      {
         if(param1.value != null)
         {
            if(param1.value.target != null)
            {
               Editor.self.setSelection(param1.value.target is Editor ? null : param1.value.target,param1.value.mode + Editor.MODE_MOVE - MODE_DEFAULT,false);
            }
            this.setPlayhead(param1.value.pos,false,true);
         }
         this.redraw();
      }
      
      private function onScroll(param1:PixtonEvent) : void
      {
         Channel.cellOffset = param1.value;
         if(this.timeline.selectedPos < Channel.cellOffset)
         {
            this.setPlayhead(Channel.cellOffset);
         }
         else if(this.timeline.selectedPos > Channel.cellOffset + Channel.visibleCells - 1)
         {
            if(param1.value == 0)
            {
               this.setPlayhead(param1.value);
            }
            else
            {
               this.setPlayhead(Channel.cellOffset + Channel.visibleCells - 1);
            }
         }
         else
         {
            this.updatePlayhead();
         }
         this.timeline.redraw();
      }
      
      private function updatePlayhead() : void
      {
         this.playhead.visible = this.timeline.selectedPos >= Channel.cellOffset && this.timeline.selectedPos < Channel.cellOffset + Channel.visibleCells;
         if(this.playhead.visible)
         {
            this.playhead.setText((this.timeline.selectedPos + 1).toString());
            this.playhead.x = this.timeline.x + Math.round((this.timeline.selectedPos + 0.5) * Channel.CELL_WIDTH - this.playhead.width * 0.5) - Channel.cellOffset * Channel.CELL_WIDTH;
         }
         if(!animating)
         {
            this.redraw();
         }
      }
      
      function setPlayhead(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         param1 = Utils.limit(param1,0,Animation.maxFrames - 1);
         this.timeline.setPosition(param1,param2,param3);
         if(!animating)
         {
            if(Channel.cellOffset > param1)
            {
               this.scrollbar.offset = param1;
            }
            else if(Channel.cellOffset + Channel.visibleCells <= param1)
            {
               this.scrollbar.offset = param1 - Channel.visibleCells + 1;
            }
         }
         this.updatePlayhead();
         if(!loading)
         {
            this.timeline.updateScene();
            Editor.self.updateDialogSpikes();
         }
         switch(autoMode)
         {
            case AUTO_ALIGN_FEET:
               autoAlignData = this.timeline.autoAlignFeet(autoAlignData);
               break;
            case AUTO_ALIGN_HAND_PROP:
               autoAlignData = this.timeline.autoAlignHandProp(autoAlignData);
         }
      }
      
      function reset() : void
      {
         this.animate(false);
         this.rewind();
      }
      
      function previewOnion(param1:Object) : void
      {
         this.redrawOnion(param1);
      }
      
      private function redrawOnion(param1:Object = null) : void
      {
         if(can(PREF_ONION))
         {
            Editor.self.drawOnion(this.timeline.getOnionData(isLooping),param1);
         }
         else
         {
            Editor.self.drawOnion();
         }
      }
      
      function update(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         if(param2 == Editor.MODE_LOOKS)
         {
            _loc4_ = MODE_LOOKS;
         }
         else if(param2 == Editor.MODE_EXPR && !(param1 is Dialog))
         {
            _loc4_ = MODE_EXPR;
         }
         else
         {
            _loc4_ = MODE_DEFAULT;
         }
         if(param1 != this.timeline.selectedTarget || _loc4_ != this.timeline.selectedMode || param3)
         {
            this.timeline.setTargetMode(param1,_loc4_,param3);
            if(_loc4_ == MODE_DEFAULT && param1 is Moveable)
            {
               this.redrawOnion();
            }
         }
         this.redraw();
      }
      
      function autoSave(param1:Object, param2:uint, param3:Boolean = false) : void
      {
         if(this.timeline.channelExists() && param1 == this.timeline.selectedTarget || param3)
         {
            this.timeline.autoSave(param1,this.getTargetData(param1,param3),param3);
         }
         this.redraw();
      }
      
      function onRemoveTarget(param1:Object) : void
      {
         if(this.timeline.isEmpty(param1))
         {
            return;
         }
         this.timeline.clear(param1);
         if(this.timeline.isEmpty())
         {
            this.rewind();
         }
         this.redraw();
      }
      
      function hasAnimation() : Boolean
      {
         return Main.displayManager.GET(this,DisplayManager.P_VIS) && this.timeline.anyChannelsExist() && Channel.cellsUsed > 1;
      }
      
      function getData() : String
      {
         if(!this.timeline.anyChannelsExist())
         {
            return null;
         }
         var _loc1_:Array = this.timeline.getData();
         var _loc2_:Array = Placement.getData();
         return Utils.encode({
            "t":_loc1_,
            "p":_loc2_,
            "l":isLooping,
            "fps":fps
         });
      }
      
      function setData(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:MenuItem = null;
         if(!available || !isApplicableFormat)
         {
            return;
         }
         mouseEnabled = true;
         mouseChildren = true;
         this.txtCells.text = L.text("frame-no").toUpperCase();
         loading = true;
         if(!initialized)
         {
            initialized = true;
            for each(_loc4_ in this.allButtons)
            {
               _loc4_.setColor(Editor.COLOR[Editor.MODE_MAIN],Editor.COLOR_OVER[Editor.MODE_MAIN]);
               Utils.addListener(_loc4_,MouseEvent.ROLL_OVER,this.showHelp);
               Utils.addListener(_loc4_,MouseEvent.ROLL_OUT,this.hideHelp);
               Utils.addListener(_loc4_,MouseEvent.CLICK,this.onMenu);
            }
            this.slider.setColor(Editor.COLOR[Editor.MODE_MAIN]);
         }
         if(param1 != null && param1 != "")
         {
            _loc3_ = Utils.decode(param1);
         }
         if(_loc3_ != null)
         {
            this.timeline.setData(_loc3_.t,param2);
            Placement.setData(_loc3_.p);
            this.setLooping(_loc3_.l);
            if(_loc3_.fps != null)
            {
               fps = _loc3_.fps;
            }
         }
         else
         {
            this.timeline.setData();
            this.setLooping(false);
         }
         loading = false;
         if(!param2)
         {
            this.rewind();
         }
         this.timeline.redraw();
         this.redraw();
         updateVisibility();
      }
      
      function unsetData() : void
      {
         mouseEnabled = false;
         mouseChildren = false;
         this.timeline.unsetData();
         this.redraw();
         updateVisibility();
      }
      
      private function onMenu(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this.slider.visible = false;
         switch(evt.currentTarget)
         {
            case this.mnuRewind:
               this.rewind();
               break;
            case this.mnuBack:
               this.setPlayhead(this.timeline.getFrame(Channel.BACK));
               break;
            case this.mnuBack2:
               this.setPlayhead(this.timeline.selectedPos - 1);
               break;
            case this.mnuPlay:
               this.animate(true);
               break;
            case this.mnuStop:
               this.animate(false);
               break;
            case this.mnuNext2:
               this.setPlayhead(this.timeline.selectedPos + 1);
               break;
            case this.mnuNext:
               this.setPlayhead(this.timeline.getFrame(Channel.NEXT));
               break;
            case this.mnuEnd:
               this.setPlayhead(Channel.cellsUsed - 1);
               break;
            case this.mnuKAdd:
               this.saveKeyframe();
               break;
            case this.mnuKDelete:
               this.deleteKeyframe();
               break;
            case this.mnuInsert:
               this.insertCell(true);
               break;
            case this.mnuRemove:
               this.insertCell(false);
               break;
            case this.mnuShow:
               this.hideTarget(false);
               break;
            case this.mnuHide:
               this.hideTarget(true);
               break;
            case this.mnuPreset:
               this.pickSequence(this.timeline.selectedTarget);
               break;
            case this.mnuSave:
               this.saveSequence();
               break;
            case this.mnuSaveAnim:
               Main.saveAnimation();
               break;
            case this.mnuFPS:
               this.showSlider();
               break;
            case this.mnuFeet:
               this.autoAlignFeet();
               break;
            case this.mnuHand:
               this.autoAlignHandProp();
               break;
            case this.mnuAutoScale:
               this.autoScale();
               break;
            case this.mnuClear:
               Confirm.open("Pixton.comic.confirm",L.text("confirm-anim-del"),function(param1:Boolean):*
               {
                  if(param1)
                  {
                     clear();
                  }
               });
               break;
            case this.mnuLoop:
               this.setLooping(!isLooping);
               break;
            case this.mnuOnion:
               makeAble(PREF_ONION,!can(PREF_ONION));
               this.mnuOnion.toggleState = can(PREF_ONION);
               _prefsChanged = true;
         }
      }
      
      private function showSlider() : void
      {
         this.slider.setRange(FPS_MIN,FPS_MAX);
         this.slider.x = this.mnuFPS.x;
         this.slider.value = fps;
         this.slider.visible = true;
      }
      
      private function onSlider(param1:Object) : void
      {
         if(parseInt(param1.value) == fps)
         {
            return;
         }
         fps = parseInt(param1.value);
         if(animating)
         {
            this.animate(false);
            this.animate(true);
         }
         if(param1.type == MouseEvent.MOUSE_UP)
         {
            this.slider.visible = false;
         }
      }
      
      private function saveSequence() : void
      {
         Popup.show(L.text("name-seq"),this.onNameSequence);
      }
      
      private function onNameSequence(param1:String = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.timeline.saveSequence(param1);
      }
      
      private function pickSequence(param1:Object) : void
      {
         var _loc2_:Point = this.localToGlobal(new Point(this.mnuPreset.x,this.mnuPreset.y));
         Picker.load(Globals.SEQUENCES,{
            "x":_loc2_.x,
            "y":_loc2_.y,
            "align":"bottom"
         },param1,true);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickSequence);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickSequence);
      }
      
      private function onPickSequence(param1:Object) : void
      {
         this.timeline.placeSequence(param1.value);
         this.onStateChange();
         Picker.hide();
         this.onClosePickSequence();
      }
      
      private function onClosePickSequence(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickSequence);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickSequence);
      }
      
      private function rewind() : void
      {
         this.setPlayhead(0);
      }
      
      private function hideTarget(param1:Boolean) : void
      {
         if(!this.timeline.hasDefaultChannel() || !this.timeline.hasKeyframe())
         {
            this.timeline.saveKeyframe(this.getTargetData());
            this.timeline.updateScene();
         }
         this.timeline.hideTarget(param1);
         this.onStateChange();
      }
      
      private function insertCell(param1:Boolean) : void
      {
         if(!param1 && this.timeline.hasKeyframe())
         {
            this.timeline.deleteKeyframe();
         }
         this.timeline.insertCell(param1,this.timeline.selectedMode);
         this.onStateChange();
      }
      
      private function saveKeyframe() : void
      {
         this.timeline.saveKeyframe(this.getTargetData());
         this.onStateChange();
      }
      
      private function deleteKeyframe() : void
      {
         this.timeline.deleteKeyframe();
         if(this.timeline.isEmpty())
         {
            this.rewind();
         }
         this.onStateChange();
      }
      
      private function autoAlignFeet() : void
      {
         autoMode = AUTO_ALIGN_FEET;
         autoStart = this.timeline.selectedPos;
         autoStop = TimelineSelection.getEnd();
         this.setPlayhead(TimelineSelection.getPos());
         this.animate(true);
      }
      
      private function autoAlignHandProp() : void
      {
         autoMode = AUTO_ALIGN_HAND_PROP;
         autoStart = this.timeline.selectedPos;
         autoStop = TimelineSelection.getEnd();
         this.setPlayhead(TimelineSelection.getPos());
         this.animate(true);
      }
      
      private function getFPSDelay() : Number
      {
         if(capturing)
         {
            return 40;
         }
         return 1000 / fps;
      }
      
      function animate(param1:Boolean) : void
      {
         if(param1 == animating)
         {
            return;
         }
         animating = param1;
         if(animating)
         {
            if(this.playInterval == -1)
            {
               this.playInterval = setInterval(this.onFrame,this.getFPSDelay());
            }
         }
         else if(this.playInterval != -1)
         {
            clearInterval(this.playInterval);
            this.playInterval = -1;
         }
         if(animating)
         {
            this.timeline.selectOneCell();
            if(capturing && startCaptureFrame == 0 || !capturing && this.timeline.atEnd())
            {
               this.rewind();
            }
         }
         else
         {
            clearInterval(interval);
            if(!capturing)
            {
               this.setPlayhead(this.timeline.selectedPos,true,false);
               this.timeline.updateScene();
               this.resetAutoAlign();
               this.redrawOnion();
               startCaptureFrame = 0;
            }
         }
         this.redraw();
      }
      
      private function autoScale() : void
      {
         this.autoSave(Editor.self,MODE_DEFAULT);
         if(!this.timeline.channelExists() || !this.timeline.hasKeyframe())
         {
            this.saveKeyframe();
         }
         this.timeline.autoScale();
      }
      
      private function resetAutoAlign() : void
      {
         autoStart = -1;
         autoMode = -1;
         autoStop = -1;
         autoAlignData = null;
         _prefsChanged = false;
      }
      
      function captureFrames() : void
      {
         capturing = true;
         this.clearCapture();
         startCaptureFrame = this.timeline.selectedPos;
         this.animate(true);
      }
      
      function clearCapture() : void
      {
         snapshots = [];
         completelyRendered = false;
      }
      
      private function captureFrame() : void
      {
         var _loc1_:Object = Pixton.getEditorImage(Editor.self,!!Main.isProfile() ? Number(Pixton.THUMBNAIL) : Number(Pixton.FULLSIZE));
         snapshots.push(_loc1_);
      }
      
      function getStoredImages() : Object
      {
         var _loc1_:Object = {"images":snapshots};
         if(completelyRendered)
         {
            _loc1_["bubbles"] = [];
         }
         return _loc1_;
      }
      
      function getImagesSize() : uint
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         var _loc3_:uint = snapshots.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ += snapshots[_loc2_].data.length;
            _loc2_++;
         }
         return _loc1_;
      }
      
      function getDialogData() : Array
      {
         var _loc3_:Dialog = null;
         var _loc4_:Object = null;
         var _loc1_:Array = Editor.self.getSpeechDialogs();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = {
               "text":_loc3_.text,
               "time":this.timeline.getAppearance(_loc3_ as Object)
            };
            _loc2_.push(_loc4_);
         }
         _loc2_.sortOn("time");
         return _loc2_;
      }
      
      private function setLooping(param1:Boolean) : void
      {
         isLooping = param1;
         this.mnuLoop.toggleState = isLooping;
      }
      
      private function onFrame() : void
      {
         if(!animating)
         {
            return;
         }
         Utils.monitorMemory();
         if(capturing)
         {
            Main.self.updateAnimationProgress((this.timeline.selectedPos + 1) / Channel.cellsUsed);
            this.captureFrame();
         }
         var _loc1_:uint = this.timeline.selectedPos + 1;
         var _loc2_:uint = Channel.cellsUsed - (!!Main.isProfile() ? 1 : 0);
         if(autoStop > -1 && _loc1_ >= autoStop)
         {
            this.animate(false);
            this.setPlayhead(autoStart);
         }
         else if(capturing && (_loc1_ >= _loc2_ || _loc1_ % RENDER_CHUNK_SIZE == 0))
         {
            completelyRendered = _loc1_ >= _loc2_;
            capturing = !completelyRendered;
            dispatchEvent(new PixtonEvent(PixtonEvent.COMPLETE));
            this.animate(false);
            this.setPlayhead(_loc1_);
         }
         else if(_loc1_ == Channel.cellsUsed - 1 && isLooping && !capturing && autoStop == -1)
         {
            this.rewind();
         }
         else if(_loc1_ >= Channel.cellsUsed)
         {
            this.animate(false);
            this.redraw();
         }
         else
         {
            this.setPlayhead(_loc1_);
         }
      }
      
      function allSaved() : Boolean
      {
         return !this.hasAnimation() || snapshots != null && snapshots.length > 0;
      }
      
      function getBottom() : Number
      {
         if(Main.displayManager.GET(this,DisplayManager.P_VIS))
         {
            return Main.displayManager.GET(this,DisplayManager.P_Y) + this.border.y + this.border.height + (!!this.scrollbar.visible ? this.scrollbar.height : 0) + MARGIN_BOTTOM;
         }
         return 0;
      }
      
      private function redraw(param1:Boolean = false) : void
      {
         dirty = true;
         if(param1)
         {
            this.onRender();
         }
         else
         {
            Utils.invalidate(this);
         }
      }
      
      private function onRender(param1:Event = null) : void
      {
         var _loc7_:uint = 0;
         if(!dirty || !Main.displayManager.GET(this,DisplayManager.P_VIS))
         {
            return;
         }
         dirty = false;
         var _loc2_:Boolean = this.timeline.channelExists();
         var _loc3_:Boolean = this.timeline.placementSelected();
         var _loc4_:uint = this.timeline.selectedTarget is Character ? uint(Editor.MODE_EXPR) : uint(Editor.MODE_MOVE);
         this.mnuStop.visible = animating;
         this.mnuPlay.visible = !this.timeline.isEmpty() && !animating;
         this.mnuRewind.enableState = this.timeline.selectedPos > 0;
         this.mnuBack.enableState = this.timeline.selectedPos > 0;
         this.mnuNext.enableState = this.timeline.selectedPos < Animation.maxFrames - 1;
         this.mnuBack2.enableState = this.mnuBack.enableState;
         this.mnuNext2.enableState = this.mnuNext.enableState;
         this.mnuEnd.enableState = this.mnuNext.enableState;
         this.mnuKAdd.enableState = !_loc3_ && Editor.self.mode <= _loc4_ && !this.timeline.hasKeyframe();
         this.mnuKDelete.enableState = !_loc3_ && this.timeline.hasDeletableKeyframe();
         this.mnuInsert.enableState = this.timeline.canInsert();
         this.mnuRemove.enableState = !_loc3_ && this.timeline.canRemove() && !this.mnuKDelete.enableState;
         this.mnuPreset.enableState = Sequence.hasType(this.timeline.selectedTarget);
         this.mnuSave.enableState = !_loc3_ && this.timeline.isSaveable();
         this.mnuSaveAnim.enableState = !this.timeline.isEmpty();
         this.mnuFPS.enableState = !this.timeline.isEmpty();
         this.mnuFeet.enableState = this.timeline.selectedTarget is Character;
         this.mnuHand.enableState = this.timeline.selectedTarget is Prop;
         this.mnuAutoScale.enableState = this.timeline.selectedTarget is Moveable;
         this.mnuClear.enableState = this.timeline.anyChannelsExist();
         this.mnuShow.visible = Editor.self.mode == Editor.MODE_MOVE && this.timeline.selectedTarget is Moveable && this.timeline.targetHidden(can(PREF_ONION));
         this.mnuHide.visible = Editor.self.mode == Editor.MODE_MOVE && this.timeline.selectedTarget is Moveable && (!_loc2_ || !this.mnuShow.visible);
         this.mnuShow.enableState = !_loc3_ && this.mnuShow.visible;
         this.mnuHide.enableState = !_loc3_ && this.mnuHide.visible;
         this.mnuBack.visible = false;
         this.mnuBack2.visible = false;
         this.mnuNext2.visible = false;
         this.mnuNext.visible = false;
         this.mnuEnd.visible = Animation.maxFrames > Channel.visibleCells;
         this.mnuPreset.visible = false;
         this.mnuAutoScale.visible = false;
         this.mnuFeet.visible = false;
         this.mnuHand.visible = false;
         this.mnuOnion.visible = false;
         this.mnuSave.visible = Main.isPosesUser();
         var _loc5_:int = 0;
         var _loc6_:int = this.border.width + MenuItem.GAP;
         var _loc8_:uint = this.menu.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(this.menu[_loc7_].visible)
            {
               if(Utils.inArray(this.menu[_loc7_],this.menuRight))
               {
                  this.menu[_loc7_].x = _loc6_ - MenuItem.SIZE - MenuItem.GAP;
                  _loc6_ -= MenuItem.SIZE + MenuItem.GAP;
               }
               else
               {
                  this.menu[_loc7_].x = _loc5_;
                  _loc5_ += MenuItem.SIZE + MenuItem.GAP;
               }
               if(this.menu[_loc7_] == this.mnuEnd)
               {
                  _loc5_ += 10;
               }
            }
            _loc7_++;
         }
         this.refit();
         Editor.self.redraw();
         this.redrawOnion();
         Main.resizeStage();
      }
      
      private function onTimelineChange(param1:PixtonEvent) : void
      {
         this.refit();
      }
      
      private function onPositionChange(param1:PixtonEvent) : void
      {
         this.setPlayhead(param1.value);
      }
      
      private function refit() : void
      {
         if(Animation.maxFrames > Channel.visibleCells)
         {
            this.border.height = TIMELINE_PADDING * 2 + this.timeline.getHeight();
            this.scrollbar.x = this.timeline.x;
            this.scrollbar.y = this.border.y + this.border.height - this.scrollbar.height - 9;
            this.scrollbar.setData(this.timeline.getScrollData());
            this.scrollbar.visible = true;
         }
         else
         {
            this.scrollbar.visible = false;
            this.border.height = this.timeline.y + this.timeline.getHeight();
         }
         this.scrim.height = -this.scrim.y + this.border.height;
         this.mnuLoop.y = Math.round(this.border.y + (this.border.height - MenuItem.SIZE) * 0.5);
      }
      
      private function clear() : void
      {
         if(this.timeline.channelExists())
         {
            this.timeline.clear();
         }
         else
         {
            this.timeline.clear(null,true);
         }
         if(this.timeline.isEmpty())
         {
            this.rewind();
         }
         this.onStateChange();
      }
      
      private function onStateChange(param1:PixtonEvent = null) : void
      {
         dispatchEvent(new PixtonEvent(PixtonEvent.STATE_CHANGE,this));
      }
      
      private function getTargetData(param1:Object = null, param2:Boolean = false) : Object
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            param1 = this.timeline.selectedTarget;
         }
         if(param1 is Editor)
         {
            _loc3_ = Editor(param1).getAnimationData();
         }
         else if(param1 is Character)
         {
            _loc3_ = Character(param1).getAnimationData(!!param2 ? uint(MODE_DEFAULT) : uint(this.timeline.selectedMode));
         }
         else if(param1 is Prop)
         {
            _loc3_ = Prop(param1).getAnimationData();
         }
         else if(param1 is Dialog)
         {
            _loc3_ = Dialog(param1).getAnimationData();
         }
         return _loc3_;
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = false;
         switch(param1.currentTarget)
         {
            case this.mnuRewind:
               _loc3_ = L.text("anim-rewind");
               break;
            case this.mnuBack:
               _loc3_ = L.text("anim-back");
               break;
            case this.mnuBack2:
               _loc3_ = L.text("anim-back-2");
               break;
            case this.mnuPlay:
               _loc3_ = L.text("anim-play");
               break;
            case this.mnuStop:
               _loc3_ = L.text("anim-stop");
               break;
            case this.mnuNext2:
               _loc3_ = L.text("anim-next-2");
               break;
            case this.mnuNext:
               _loc3_ = L.text("anim-next");
               break;
            case this.mnuEnd:
               _loc3_ = L.text("anim-end");
               break;
            case this.mnuKAdd:
               _loc3_ = L.text("anim-add");
               break;
            case this.mnuKDelete:
               _loc3_ = L.text("anim-del");
               break;
            case this.mnuInsert:
               _loc3_ = L.text("anim-insert");
               break;
            case this.mnuRemove:
               _loc3_ = L.text("anim-remove");
               break;
            case this.mnuShow:
               _loc3_ = L.text("anim-show");
               break;
            case this.mnuHide:
               _loc3_ = L.text("anim-hide");
               break;
            case this.mnuPreset:
               _loc3_ = L.text("anim-preset");
               break;
            case this.mnuSave:
               _loc3_ = L.text("anim-save");
               break;
            case this.mnuSaveAnim:
               _loc3_ = L.text("save-anim");
               break;
            case this.mnuFPS:
               _loc3_ = L.text("anim-fps");
               break;
            case this.mnuFeet:
               _loc3_ = L.text("align-feet");
               break;
            case this.mnuHand:
               _loc3_ = L.text("align-hand");
               break;
            case this.mnuAutoScale:
               _loc3_ = L.text("auto-scale");
               break;
            case this.mnuClear:
               _loc3_ = L.text("anim-clear");
               break;
            case this.mnuLoop:
               _loc3_ = L.text("toggle-looping");
         }
         if(_loc3_ != null)
         {
            Help.show(_loc3_,param1.currentTarget,_loc2_);
         }
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
   }
}
