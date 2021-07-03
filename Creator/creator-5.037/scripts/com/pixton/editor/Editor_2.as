package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.designer.Designer;
   import com.pixton.team.Team;
   import com.pixton.team.TeamRole;
   import fl.transitions.TweenEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.InterpolationMethod;
   import flash.display.MovieClip;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public final class Editor extends MovieClip
   {
      
      public static const PROP_CONTAINER:String = "containerC";
      
      static const MAJOR_SHIFT:Number = 10;
      
      static const MINOR_SHIFT:Number = 1;
      
      static const AUTO_SCALE_THRESHOLD:Number = 2;
      
      public static var undoLevels:uint = 25;
      
      public static const ZOOM_NONE:uint = 0;
      
      public static const ZOOM_FACE:uint = 1;
      
      public static const ZOOM_BODY:uint = 2;
      
      public static const BEGINNER_MODE:uint = 0;
      
      public static const ADVANCED_MODE:uint = 1;
      
      public static const NO_HELP:uint = 0;
      
      public static const SHOW_HELP:uint = 1;
      
      public static const WIDTH_CONTROLS:Number = 35;
      
      public static const HEIGHT_CONTROLS:Number = 35;
      
      private static const ZOOM_ANIMATED:Boolean = false;
      
      private static const ZOOM_TARGET_SPEED:Number = 0.1;
      
      public static const ACTION_PASTING:uint = 1;
      
      public static const ACTION_RESTORING:uint = 2;
      
      public static var COLOR:Array = [[253,216,53],[224,224,224],[129,212,250],[165,214,167],[255,171,145],[179,157,219],[244,143,177],[189,189,189]];
      
      public static var COLOR_OVER:Array = [[253,216,53],[224,224,224],[129,212,250],[165,214,167],[255,171,145],[179,157,219],[244,143,177],[189,189,189]];
      
      public static const HIGHLIGHT:uint = 0;
      
      public static const MODE_MAIN:uint = 1;
      
      public static const MODE_MOVE:uint = 2;
      
      public static const MODE_EXPR:uint = 3;
      
      public static const MODE_LOOKS:uint = 4;
      
      public static const MODE_COLORS:uint = 5;
      
      public static const MODE_SCALE:uint = 6;
      
      public static const MODE_BORDER:uint = 7;
      
      public static const GRID_SIZE:Number = 5;
      
      private static const ZOOM_DURATION:Number = 0.5;
      
      private static const MENU_FADED:Number = 0.7;
      
      private static const FADE_DURATION:Number = 0.5;
      
      public static var DEFAULT_SCALE_1:Number = 0.7;
      
      public static var DEFAULT_SCALE_2:Number = 0.7;
      
      private static const BORDER_THICKNESS:uint = 3;
      
      private static const ORIGIN_COLOR:uint = 15658734;
      
      private static const PADDING:Number = 2;
      
      private static const WIDTH_SNAP_TOLERANCE:Number = 0.1;
      
      private static const AUTO_RENDER_PADDING:Number = 15;
      
      private static const FACTOR_3D:Number = 1.1;
      
      private static const Z_MIN_DIFF:Number = 0.00002;
      
      public static var self:Editor;
      
      static var photosToLoad:uint = 0;
      
      static var photosLoaded:uint = 0;
      
      private static var clipboardScene:Object;
      
      private static var clipboardAsset:Object;
      
      private static var firstTime:Boolean = true;
      
      private static var currentMenuY:int = 0;
      
      private static var warnedFeatureLoss:Boolean = false;
      
      private static var warnedLengthLimit:Boolean = false;
      
      private static var _fullXMin:int = 0;
      
      private static var _fullXMax:int = 0;
      
      private static var _fullYMin:int = 0;
      
      private static var _fullYMax:int = 0;
       
      
      public var contents:MovieClip;
      
      public var border:MovieClip;
      
      public var rotateNE:HandleRotate;
      
      public var cornerNE:HandleRotate;
      
      public var cornerSE:HandleRotate;
      
      public var cornerSW:HandleRotate;
      
      public var cornerNW:HandleRotate;
      
      public var selector:Selector;
      
      public var namer:Namer;
      
      public var zoomer:Zoomer;
      
      public var slider:Zoomer;
      
      public var btnPan:EditorButton;
      
      public var btnEditLarge:MovieClip;
      
      public var circle:MovieClip;
      
      public var mnuBorder:MenuItem;
      
      public var mnuBShape:MenuItem;
      
      public var mnuBSize:MenuItem;
      
      public var mnuDialogLine:MenuItem;
      
      public var mnuFreestyle:MenuItem;
      
      public var mnuAddC:MenuItem;
      
      public var mnuAddD:MenuItem;
      
      public var mnuAddP:MenuItem;
      
      public var mnuAddPh:MenuItem;
      
      public var mnuDraw:MenuItem;
      
      public var mnuAddB:MenuItem;
      
      public var mnuSave:MenuItem;
      
      public var mnuSaveB:MenuItem;
      
      public var mnuHiRes:MenuItem;
      
      public var mnuUndo:MenuItem;
      
      public var mnuRedo:MenuItem;
      
      public var mnuRevert:MenuItem;
      
      public var mnuTrash:MenuItem;
      
      public var mnuClear:MenuItem;
      
      public var mnuClose:MenuItem;
      
      public var mnuUnlock:MenuItem;
      
      public var mnuLock:MenuItem;
      
      public var mnuColor:MenuItem;
      
      public var mnuGradient:MenuItem;
      
      public var mnuSilOn:MenuItem;
      
      public var mnuSilOff:MenuItem;
      
      public var mnuIsProp:MenuItem;
      
      public var mnuNotProp:MenuItem;
      
      public var mnuSwapC:MenuItem;
      
      public var mnuPanelTitle:MenuItem;
      
      public var mnuPanelDesc:MenuItem;
      
      public var mnuDescLen:MenuItem;
      
      public var mnuNotes:MenuItem;
      
      public var mnuPadding:MenuItem;
      
      public var mnuTColor:MenuItem;
      
      public var mnuSpike:MenuItem;
      
      public var mnuBubble:MenuItem;
      
      public var mnuAuto:MenuItem;
      
      public var mnuManual:MenuItem;
      
      public var mnuLeading:MenuItem;
      
      public var mnuSize:MenuItem;
      
      public var mnuFont:MenuItem;
      
      public var mnuRegular:MenuItem;
      
      public var mnuBold:MenuItem;
      
      public var mnuItalic:MenuItem;
      
      public var mnuKeypad:MenuItem;
      
      public var mnuColorD:MenuItem;
      
      public var mnuColorDB:MenuItem;
      
      public var mnuSound:MenuItem;
      
      public var mnuRecord:MenuItem;
      
      public var mnuVoice:MenuItem;
      
      public var mnuPen:MenuItem;
      
      public var mnuErase:MenuItem;
      
      public var mnuMore:MenuItem;
      
      public var mnuAlignL:MenuItem;
      
      public var mnuAlignC:MenuItem;
      
      public var mnuAlignR:MenuItem;
      
      public var mnuLink:MenuItem;
      
      public var mnuFlipH:MenuItem;
      
      public var mnuFlipV:MenuItem;
      
      public var mnuDupl:MenuItem;
      
      public var mnuToFront:MenuItem;
      
      public var mnuToBack:MenuItem;
      
      public var mnuToFront2:MenuItem;
      
      public var mnuToBack2:MenuItem;
      
      public var mnuDelete:MenuItem;
      
      public var mnuColor1:MenuItem;
      
      public var mnuColor2:MenuItem;
      
      public var mnuColor3:MenuItem;
      
      public var mnuColor4:MenuItem;
      
      public var mnuColor5:MenuItem;
      
      public var mnuLock2:MenuItem;
      
      public var mnuAlpha:MenuItem;
      
      public var mnuSet:MenuItem;
      
      public var mnuUnset:MenuItem;
      
      public var mnuBlurAmount:MenuItem;
      
      public var mnuBlurAngle:MenuItem;
      
      public var mnuGlowAmount:MenuItem;
      
      public var mnuPlay:MenuItem;
      
      public var mnuPause:MenuItem;
      
      public var mnuPose:MenuItem;
      
      public var mnuFace:MenuItem;
      
      public var mnuFlipZ:MenuItem;
      
      public var mnuRandFace:MenuItem;
      
      public var mnuRandPose:MenuItem;
      
      public var mnuSavePose:MenuItem;
      
      public var mnuSaveFace:MenuItem;
      
      public var mnuSave2:MenuItem;
      
      public var mnuRand:MenuItem;
      
      public var mnuRevert2:MenuItem;
      
      public var mnuOutfit:MenuItem;
      
      public var mnuMove:MenuItem;
      
      public var mnuTEdit:MenuItem;
      
      public var mnuDEdit:MenuItem;
      
      public var mnuPEdit:MenuItem;
      
      public var mnuExpr:MenuItem;
      
      public var mnuLooks:MenuItem;
      
      public var mnuColors:MenuItem;
      
      public var mnuScale:MenuItem;
      
      public var mnuZoomFace:MenuItem;
      
      public var mnuZoomBody:MenuItem;
      
      public var mnuColorB:MenuItem;
      
      public var mnuSaturation:MenuItem;
      
      public var mnuBrightness:MenuItem;
      
      public var mnuContrast:MenuItem;
      
      public var mnuLineAlpha:MenuItem;
      
      public var contentMask:MovieClip;
      
      public var selectorMask:MovieClip;
      
      public var crosshairs:MovieClip;
      
      public var bkgd:MovieClip;
      
      public var resizerH:Resizer;
      
      public var resizerV:Resizer;
      
      public var currentTarget:Object;
      
      public var activeMenu:uint;
      
      public var blurness:Number;
      
      public var sceneRotation:Number = 0;
      
      public var zOrder:Array;
      
      public var zOrderLegacy:Array;
      
      public var customBorder:Border;
      
      public var borderRect:Rectangle;
      
      public var panelInfo:PanelInfo;
      
      public var zoomMode:uint = 0;
      
      public var imageCredit:MovieClip;
      
      public var panelTitle:PanelTitle;
      
      public var panelDesc:PanelDesc;
      
      public var panelNotes:PanelNotes;
      
      public var animation:Animation;
      
      public var heightWithMenu:Number = 0;
      
      private var menu:Array;
      
      private var allButtons:Array;
      
      private var menuUndo:Array;
      
      private var horizontalItems:Array;
      
      private var modeMenu:Array;
      
      private var zoomMenu:Array;
      
      private var mainMenuItems:Array;
      
      private var excludeMenuItems:Array;
      
      private var clickTime:Number;
      
      private var containerB:MovieClip;
      
      var contentsC:MovieClip;
      
      var containerC:MovieClip;
      
      var containerD:MovieClip;
      
      private var startTouch:Point;
      
      private var startPoint:Point;
      
      private var startCursor:Point;
      
      private var characterData:Array;
      
      private var panelData:Object;
      
      private var borderData:Object;
      
      private var dialogData:Array;
      
      private var propData:Array;
      
      private var scaleData:Object;
      
      private var tweens:Array;
      
      private var loading:Boolean = false;
      
      private var originalAssetData:Object;
      
      private var originalPositionData:Object;
      
      private var unsaved:Array;
      
      private var noImage:Boolean;
      
      private var maxWidth:Number;
      
      private var maxHeight:Number;
      
      private var _colorID:uint;
      
      private var _gradientID:uint;
      
      private var currentColor:Array;
      
      private var mouseIsDown:Boolean = false;
      
      private var undoStack:Array;
      
      private var currentState:int;
      
      private var redoing:Boolean = false;
      
      private var undoing:Boolean = false;
      
      private var renderHide:Array;
      
      private var fx:FX;
      
      private var dirty:Boolean = false;
      
      private var prevTarget:Object;
      
      private var prevClickTime:Number = 0;
      
      private var preview:MovieClip;
      
      private var previewBM:Bitmap;
      
      private var firstRender:Boolean = true;
      
      private var _locked:Boolean = false;
      
      private var _saved:Boolean = true;
      
      private var _disableTeamStateUpdate:Boolean = false;
      
      private var snapshotBM:Bitmap;
      
      private var _panning:Boolean = false;
      
      private var menuExtra:Array;
      
      private var menuExtraShown:Boolean = false;
      
      private var _templateSetting:String = null;
      
      private var _templateScene:String = null;
      
      private var _imageCredit:String;
      
      private var _imageID:uint = 0;
      
      private var _hasPanelTitle:Boolean = false;
      
      private var _hasPanelDesc:Boolean = false;
      
      private var _descLines:uint;
      
      private var _notesLines:uint = 4;
      
      private var _textChangeTimeout:int = -1;
      
      private var _xComic:int = 0;
      
      private var _yComic:int = 0;
      
      public function Editor()
      {
         super();
         this.visible = false;
         this.contentMask.mouseEnabled = false;
         this.contentMask.mouseChildren = false;
         this.selectorMask.mouseEnabled = false;
         this.selectorMask.mouseChildren = false;
         this.bkgd.mouseEnabled = false;
         this.bkgd.mouseChildren = false;
         this.contents.mask = this.contentMask;
         this.selector.mask = this.selectorMask;
         this.zoomer.isFixed = false;
         this.zoomer.visible = false;
         this.circle.mouseEnabled = false;
         this.circle.mouseChildren = false;
         this.imageCredit.visible = false;
         this.fx = new FX(this.contentMask);
      }
      
      public static function makeExtraData(param1:String, param2:String) : Object
      {
         return {
            "st":param1,
            "sc":param2
         };
      }
      
      public static function canToggleMeta() : Boolean
      {
         return Main.isTemplatesUser() && (Comic.isFreestyle() || Main.isStoryboard() || Main.isTChart() || Main.isGrid());
      }
      
      public static function warnFeatureLoss() : void
      {
         if(warnedFeatureLoss)
         {
            return;
         }
         if(!Template.isActive())
         {
            Confirm.alert(L.text("warn-feat-loss") + " " + L.text("warn-feat-loss-" + (!!Globals.isFullVersion() ? "3" : "2"),Main.PLUS_NAME),false);
         }
         warnedFeatureLoss = true;
      }
      
      static function updateFromZ(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = param1.numChildren;
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.getChildAt(_loc2_);
            _loc5_.push(_loc4_);
            _loc2_++;
         }
         _loc5_.sortOn("z").reverse();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1.setChildIndex(_loc5_[_loc2_],0);
            _loc2_++;
         }
      }
      
      static function updateZ(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc3_:uint = param1.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.getChildAt(_loc2_);
            if(!isNaN(_loc5_) && Utils.toFixed(Moveable(_loc4_).zIndex,5) <= _loc5_)
            {
               Moveable(_loc4_).zIndex = _loc5_ + Z_MIN_DIFF;
            }
            _loc5_ = Utils.toFixed(Moveable(_loc4_).zIndex,5);
            _loc2_++;
         }
      }
      
      private static function disableMenuItem(param1:MenuItem) : void
      {
         if(!param1.visible)
         {
            return;
         }
         param1.disablable = true;
         param1.enableState = false;
      }
      
      private static function reuseCharacter(param1:Array, param2:Object) : Character
      {
         var _loc3_:Character = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = param1[_loc4_] as Character;
            if(_loc3_.getID() == param2.id)
            {
               param1.splice(_loc4_,1);
               _loc3_.reset();
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function init(param1:Editor) : void
      {
         Editor.self = param1;
         param1.mnuSave.alpha = Main.BUTTON_ALPHA;
         param1.mnuRevert.alpha = Main.BUTTON_ALPHA;
         param1.mnuSave2.alpha = Main.BUTTON_ALPHA;
         param1.mnuRevert2.alpha = Main.BUTTON_ALPHA;
         param1.border.visible = !Main.isReadOnly() && !Main.isCharCreate() && !Comic.isLockedPanels();
      }
      
      public static function setClipboard(param1:String, param2:Function = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(param1 != null)
         {
            clipboardScene = Utils.decode(param1);
            _loc3_ = [];
            for each(_loc4_ in clipboardScene.p)
            {
               if(_loc4_.s == Prop.PROP_SET && !Utils.inArray(_loc4_.id,_loc3_) && !PropSet.hasData(_loc4_.id))
               {
                  _loc3_.push(_loc4_.id);
               }
            }
            if(_loc3_.length > 0)
            {
               Main.self.loadPropSets(_loc3_,param2);
            }
            else if(param2 != null)
            {
               param2();
            }
         }
      }
      
      public static function copyData() : void
      {
         clipboardScene = self.getData();
      }
      
      public static function pasteData() : void
      {
         Utils.remote("getClipboard",null,function(param1:Object):void
         {
            if(param1.cb)
            {
               setClipboard(param1.cb,pasteLocalData);
            }
            else
            {
               pasteLocalData();
            }
         },true);
      }
      
      private static function pasteLocalData() : void
      {
         if(Editor.sceneInClipboard())
         {
            self.unsetData();
            self.setPositionData(self.originalPositionData);
            if(!Main.controlPressed || !self.resizerH.visible)
            {
               clipboardScene.w = self.getWidth();
            }
            if(!Main.controlPressed || !self.resizerV.visible)
            {
               clipboardScene.h = self.getHeight();
            }
            self.setData(clipboardScene,ACTION_PASTING);
            Main.self.updatePanelData(clipboardScene);
            self.onStateChange();
         }
         else
         {
            Utils.alert(L.text("clipboard-empty"));
         }
      }
      
      public static function charSelected(param1:Boolean = true) : Boolean
      {
         if(!(self.currentTarget is Character))
         {
            return false;
         }
         return !param1 || Character(self.currentTarget).hasID();
      }
      
      public static function makeNewCharacter() : void
      {
         if(!(self.currentTarget is Character))
         {
            return;
         }
         Character(self.currentTarget).promptOverwrite(false,true);
      }
      
      public static function duplicate() : void
      {
         copyAsset();
         pasteAsset(true);
      }
      
      public static function copyAsset(param1:Object = null) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:Boolean = false;
         if(param1 == null)
         {
            _loc2_ = true;
            param1 = self.currentTarget;
         }
         if(self.selector.visible)
         {
            _loc3_ = {};
            if(param1 is Character)
            {
               _loc3_ = Character(param1).getGenome();
               _loc3_.type = Character;
               _loc3_.size = Asset(param1).size;
               _loc3_.expression = Character(param1).getData(true);
            }
            else if(param1 is PropSet)
            {
               _loc3_ = Prop(param1).getData();
               _loc3_.type = PropSet;
            }
            else if(param1 is PropPhoto)
            {
               _loc3_ = PropPhoto(param1).getData();
               _loc3_.type = PropPhoto;
            }
            else if(param1 is WebPhoto)
            {
               _loc3_ = WebPhoto(param1).getData();
               _loc3_.type = WebPhoto;
            }
            else if(param1 is Prop)
            {
               _loc3_ = Prop(param1).getData();
               _loc3_.type = Prop;
            }
            else if(param1 is Dialog)
            {
               _loc3_ = Dialog(param1).getData();
               _loc3_.type = Dialog;
            }
            else if(param1 is Array)
            {
               _loc3_.array = [];
               _loc5_ = param1.length;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc3_.array[_loc4_] = copyAsset(param1[_loc4_]);
                  _loc4_++;
               }
               _loc3_.type = Array;
            }
            if(!(param1 is Array))
            {
               _loc3_.original = param1;
               _loc3_.depth = param1.parent.getChildIndex(param1);
            }
            if(_loc2_)
            {
               clipboardAsset = _loc3_;
            }
            return _loc3_;
         }
         return null;
      }
      
      public static function pasteAsset(param1:Boolean = false, param2:Object = null) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:Boolean = true;
         if(param2 == null)
         {
            param2 = clipboardAsset;
            _loc4_ = true;
         }
         if(self.selector.visible && self.currentTarget is Character && !param1 && param2 != null && param2.type == Character)
         {
            if(self.activeMenu == MODE_LOOKS)
            {
               Character(self.currentTarget).setGenome(param2,false);
               Character(self.currentTarget).redraw(true);
               Character(self.currentTarget).setSaved(false);
            }
            else if(clipboardAsset.expression != null)
            {
               Character(self.currentTarget).setData(param2.expression,true);
               Character(self.currentTarget).redraw(true);
            }
         }
         else
         {
            switch(param2.type)
            {
               case Character:
                  _loc3_ = self.addCharacter(param2.id) as MovieClip;
                  updateZ(self.containerC);
                  if(param2.id == 0 || param1)
                  {
                     Character(_loc3_).setGenome(param2,false);
                  }
                  Character(_loc3_).setData(param2.expression);
                  _loc3_.x += MAJOR_SHIFT / self.scale;
                  _loc3_.y += MAJOR_SHIFT / self.scale;
                  Character(_loc3_).size = param2.size;
                  Character(_loc3_).redraw(true);
                  if(_loc4_)
                  {
                     self.setSelection();
                     self.setSelection(_loc3_ as Character);
                  }
                  break;
               case Prop:
               case PropPhoto:
               case WebPhoto:
               case PropSet:
                  if(param2.type == PropSet)
                  {
                     _loc5_ = Prop.PROP_SET;
                  }
                  else if(param2.type == PropPhoto)
                  {
                     _loc5_ = Prop.PROP_PHOTO;
                  }
                  else if(param2.type == WebPhoto)
                  {
                     _loc5_ = Prop.PROP_WEB;
                  }
                  else
                  {
                     _loc5_ = Prop.PROP_PRESET;
                  }
                  _loc3_ = self.addProp(param2.id,_loc5_) as MovieClip;
                  updateZ(self.containerC);
                  if(_loc3_ != null)
                  {
                     Prop(_loc3_).setData(param2);
                     _loc3_.x += MAJOR_SHIFT;
                     _loc3_.y += MAJOR_SHIFT;
                     if(_loc4_)
                     {
                        self.setSelection();
                        self.setSelection(_loc3_ as Prop);
                     }
                  }
                  break;
               case Dialog:
                  _loc3_ = self.addDialog() as MovieClip;
                  Dialog(_loc3_).setData(param2);
                  Dialog(_loc3_).redraw();
                  _loc3_.x += 10;
                  _loc3_.y += 10;
                  if(_loc4_)
                  {
                     self.setSelection();
                     self.setSelection(_loc3_ as Dialog);
                  }
                  break;
               case Array:
                  _loc7_ = param2.array.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     pasteAsset(param1,param2.array[_loc6_]);
                     _loc6_++;
                  }
            }
            if(param2.type != Array && _loc3_ != null)
            {
               _loc8_ = param2.depth + 1;
               _loc3_.parent.setChildIndex(_loc3_,Math.min(_loc8_,_loc3_.parent.numChildren - 1));
            }
         }
         if(_loc4_)
         {
            self.onChange();
            self.redraw();
         }
         self.onStateChange();
      }
      
      public static function sceneInClipboard() : Boolean
      {
         return clipboardScene != null;
      }
      
      public static function assetInClipboard() : Boolean
      {
         return clipboardAsset != null;
      }
      
      public static function assetSelected(param1:Boolean = true) : Boolean
      {
         return self.assetSelected(param1);
      }
      
      public static function hasHidden() : Boolean
      {
         return self.hasHidden();
      }
      
      public static function isRenamableCharacter() : Boolean
      {
         return self.isRenamableCharacter();
      }
      
      public static function isHidable() : Boolean
      {
         return self.isHidable();
      }
      
      public static function hideAsset() : void
      {
         return self.hideAsset();
      }
      
      public static function showAsset() : void
      {
         return self.showAsset();
      }
      
      public static function editAsset() : void
      {
         return self.editAsset();
      }
      
      public static function getCopyLabel() : String
      {
         if(self.selector.visible)
         {
            switch(self.currentTarget.constructor)
            {
               case Character:
                  return "character";
               case Prop:
               case PropPhoto:
               case WebPhoto:
                  return "prop";
               case PropSet:
                  return "prop-set";
               case Dialog:
                  return "dialog";
               case Array:
                  return "objects";
            }
         }
         return "scene";
      }
      
      public static function getPasteLabel() : String
      {
         if(clipboardAsset != null)
         {
            switch(clipboardAsset.type)
            {
               case Character:
                  if(self.currentTarget is Character)
                  {
                     if(self.activeMenu == MODE_LOOKS)
                     {
                        return "looks";
                     }
                     return "expression";
                  }
                  return "character";
                  break;
               case Prop:
               case PropPhoto:
               case WebPhoto:
                  return "prop";
               case PropSet:
                  return "prop-set";
               case Dialog:
                  return "dialog";
               case Array:
                  return "objects";
            }
         }
         return "scene";
      }
      
      public static function getXY() : Object
      {
         return {
            "x":self.x,
            "y":self.y
         };
      }
      
      public static function getTargetInfo(param1:Object, param2:Object) : void
      {
         param1.t = Pixton.getTargetType(param2);
         param1.i = param2.parent.getChildIndex(param2);
      }
      
      public static function getTargetFromInfo(param1:Object) : Object
      {
         if(param1.t == Pixton.TARGET_CHARACTER || param1.t == Pixton.TARGET_PROP)
         {
            if(self.containerC.numChildren > param1.i)
            {
               return self.containerC.getChildAt(param1.i);
            }
            return null;
         }
         if(param1.t == Pixton.TARGET_DIALOG)
         {
            if(self.containerD.numChildren > param1.i)
            {
               return self.containerD.getChildAt(param1.i);
            }
            return null;
         }
         if(param1.t == Pixton.TARGET_EDITOR)
         {
            return self;
         }
         return null;
      }
      
      public static function update() : void
      {
         if(self == null)
         {
            return;
         }
         self.refreshMenu();
      }
      
      public static function getContainer(param1:DisplayObject) : MovieClip
      {
         return self.contents;
      }
      
      static function getRect() : Rectangle
      {
         return self.borderRect;
      }
      
      public static function startLock(param1:Boolean = true, param2:Boolean = false) : void
      {
         if(param1)
         {
            Team.keepLocked = true;
         }
         self.destroySnapshot();
         self.restartTeamTimer(param2);
      }
      
      public static function endLock() : void
      {
         Team.keepLocked = false;
      }
      
      public static function swapCharacter() : void
      {
         self.pickCharacter(Character.lastPool);
      }
      
      static function onNewPhoto() : void
      {
         ++photosToLoad;
      }
      
      static function onPhotoLoaded() : void
      {
         ++photosLoaded;
         checkPhotosLoaded();
      }
      
      static function checkPhotosLoaded() : void
      {
         if(photosLoaded < photosToLoad)
         {
            return;
         }
         self.dispatchEvent(new PixtonEvent(PixtonEvent.COMPLETE));
      }
      
      static function hasPhotosLoading() : Boolean
      {
         return photosToLoad > photosLoaded;
      }
      
      public static function getTotalScale(param1:Asset) : Number
      {
         var _loc2_:Rectangle = param1.getBounds(self.containerC);
         return _loc2_.height / self.getHeight();
      }
      
      public function init() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         this.menu = [];
         this.menu[MODE_MAIN] = [this.mnuRedo,this.mnuUndo,this.mnuAddC,this.mnuAddD,this.mnuAddP,this.mnuAddB,this.mnuDraw,this.mnuAddPh,this.mnuBorder,this.mnuSave,this.mnuColor,this.mnuGradient,this.mnuSaveB,this.mnuSet,this.mnuFlipH,this.mnuLock,this.mnuUnlock,this.mnuHiRes,this.mnuPanelTitle,this.mnuPanelDesc,this.mnuDescLen,this.mnuNotes,this.mnuRevert,this.mnuClear,this.mnuClose,this.mnuMore,this.mnuTrash];
         this.menu[MODE_MOVE] = [this.mnuVoice,this.mnuRand,this.mnuBubble,this.mnuSpike,this.mnuFont,this.mnuSize,this.mnuRegular,this.mnuBold,this.mnuItalic,this.mnuDialogLine,this.mnuPadding,this.mnuAuto,this.mnuManual,this.mnuLeading,this.mnuIsProp,this.mnuNotProp,this.mnuRedo,this.mnuUndo,this.mnuToBack,this.mnuToFront,this.mnuFlipH,this.mnuFlipV,this.mnuDupl,this.mnuAlpha,this.mnuBlurAmount,this.mnuBlurAngle,this.mnuGlowAmount,this.mnuSilOn,this.mnuSilOff,this.mnuColor,this.mnuPlay,this.mnuPause,this.mnuSet,this.mnuUnset,this.mnuLock2,this.mnuRecord,this.mnuSound,this.mnuAlignL,this.mnuAlignC,this.mnuAlignR,this.mnuPose,this.mnuFace,this.mnuSwapC,this.mnuLink,this.mnuMore,this.mnuDelete];
         this.menu[MODE_EXPR] = [this.mnuRedo,this.mnuUndo,this.mnuVoice,this.mnuRand,this.mnuFace,this.mnuRandFace,this.mnuSaveFace,this.mnuPose,this.mnuRandPose,this.mnuSavePose,this.mnuFlipH,this.mnuFlipZ,this.mnuZoomFace,this.mnuZoomBody,this.mnuFont,this.mnuRegular,this.mnuBold,this.mnuItalic,this.mnuSize,this.mnuColor,this.mnuRecord,this.mnuSound,this.mnuAlignL,this.mnuAlignC,this.mnuAlignR,this.mnuPen,this.mnuLink,this.mnuErase,this.mnuKeypad,this.mnuMore];
         this.menu[MODE_LOOKS] = [this.mnuRedo,this.mnuUndo,this.mnuRand,this.mnuRevert2,this.mnuSave2,this.mnuOutfit,this.mnuZoomFace,this.mnuZoomBody];
         this.menu[MODE_SCALE] = [this.mnuRedo,this.mnuUndo,this.mnuRevert2,this.mnuSave2,this.mnuZoomFace,this.mnuZoomBody];
         this.menu[MODE_COLORS] = [this.mnuRedo,this.mnuUndo,this.mnuRand,this.mnuRevert2,this.mnuSave2,this.mnuZoomFace,this.mnuZoomBody,this.mnuTColor,this.mnuColorD,this.mnuColorDB,this.mnuColor1,this.mnuColor2,this.mnuColor3,this.mnuColor4,this.mnuColor5];
         this.menu[MODE_BORDER] = [this.mnuRedo,this.mnuUndo,this.mnuBShape,this.mnuBSize,this.mnuColorB,this.mnuSaturation,this.mnuBrightness,this.mnuContrast,this.mnuLineAlpha,this.mnuFreestyle,this.mnuToBack2,this.mnuToFront2];
         this.menuExtra = [this.mnuRand,this.mnuDialogLine,this.mnuPadding,this.mnuVoice,this.mnuRegular,this.mnuBold,this.mnuItalic,this.mnuAlignL,this.mnuAlignC,this.mnuAlignR,this.mnuTColor,this.mnuColorDB,this.mnuAuto,this.mnuManual,this.mnuLeading,this.mnuSilOn,this.mnuSilOff,this.mnuSound,this.mnuFlipH,this.mnuFlipV,this.mnuDupl,this.mnuLock,this.mnuSaveB,this.mnuSet,this.mnuColor,this.mnuGradient,this.mnuRevert,this.mnuTrash,this.mnuClear,this.mnuLink,this.mnuBlurAmount,this.mnuSilOn,this.mnuLock2,this.mnuGlowAmount,this.mnuPanelTitle,this.mnuPanelDesc,this.mnuDescLen,this.mnuNotes];
         this.menuUndo = [this.mnuUndo,this.mnuRedo];
         MenuItem.addShortcut(this.mnuAddC,"C");
         MenuItem.addShortcut(this.mnuAddD,"D");
         MenuItem.addShortcut(this.mnuAddP,"P");
         MenuItem.addShortcut(this.mnuAddB,"B");
         MenuItem.addShortcut(this.mnuAddPh,"E");
         MenuItem.addShortcut(this.mnuBShape,"S");
         MenuItem.addShortcut(this.mnuBSize,"L");
         MenuItem.addShortcut(this.mnuDialogLine,"L");
         MenuItem.addShortcut(this.mnuRedo,"Y");
         MenuItem.addShortcut(this.mnuUndo,"Z");
         MenuItem.addShortcut(this.mnuSave,"S");
         MenuItem.addShortcut(this.mnuDelete,"DEL");
         MenuItem.addShortcut(this.mnuClose,"W");
         MenuItem.addShortcut(this.mnuUnlock,"U");
         MenuItem.addShortcut(this.mnuFont,"T");
         MenuItem.addShortcut(this.mnuRegular,"B");
         MenuItem.addShortcut(this.mnuBold,"B");
         MenuItem.addShortcut(this.mnuItalic,"B");
         MenuItem.addShortcut(this.mnuAlignL,"A");
         MenuItem.addShortcut(this.mnuAlignC,"A");
         MenuItem.addShortcut(this.mnuAlignR,"A");
         MenuItem.addShortcut(this.mnuSize,"S");
         MenuItem.addShortcut(this.mnuPadding,"P");
         MenuItem.addShortcut(this.mnuTColor,"K");
         MenuItem.addShortcut(this.mnuAuto,"L");
         MenuItem.addShortcut(this.mnuManual,"L");
         MenuItem.addShortcut(this.mnuFlipH,"H");
         MenuItem.addShortcut(this.mnuFlipV,"V");
         MenuItem.addShortcut(this.mnuDupl,"M");
         MenuItem.addShortcut(this.mnuToFront,"F");
         MenuItem.addShortcut(this.mnuToBack,"D");
         MenuItem.addShortcut(this.mnuToFront2,"F");
         MenuItem.addShortcut(this.mnuToBack2,"D");
         MenuItem.addShortcut(this.mnuLock,"L");
         MenuItem.addShortcut(this.mnuLock2,"L");
         MenuItem.addShortcut(this.mnuColor,"K");
         MenuItem.addShortcut(this.mnuGradient,"G");
         MenuItem.addShortcut(this.mnuColorB,"K");
         MenuItem.addShortcut(this.mnuPose,"A");
         MenuItem.addShortcut(this.mnuFace,"S");
         MenuItem.addShortcut(this.mnuFlipZ,"F");
         MenuItem.addShortcut(this.mnuSave2,"S");
         MenuItem.addShortcut(this.mnuRandFace,"F");
         MenuItem.addShortcut(this.mnuRandPose,"P");
         MenuItem.addShortcut(this.mnuRevert2,"O");
         MenuItem.addShortcut(this.mnuMove,"F1");
         MenuItem.addShortcut(this.mnuTEdit,"F2");
         MenuItem.addShortcut(this.mnuPEdit,"F2");
         MenuItem.addShortcut(this.mnuExpr,"F2");
         MenuItem.addShortcut(this.mnuLooks,"F3");
         MenuItem.addShortcut(this.mnuScale,"F4");
         MenuItem.addShortcut(this.mnuColors,"F5");
         MenuItem.addShortcut(this.mnuColor1,"1");
         MenuItem.addShortcut(this.mnuColor2,"2");
         MenuItem.addShortcut(this.mnuColor3,"3");
         MenuItem.addShortcut(this.mnuColor4,"4");
         MenuItem.addShortcut(this.mnuColor5,"5");
         MenuItem.addShortcut(this.mnuZoomFace,"O");
         MenuItem.addShortcut(this.mnuZoomBody,"P");
         MenuItem.addShortcut(this.mnuSilOn,"J");
         MenuItem.addShortcut(this.mnuSilOff,"J");
         this.mnuRevert.disablable = true;
         this.mnuRevert2.disablable = true;
         this.mnuSave.disablable = true;
         this.mnuUndo.disablable = true;
         this.mnuSave2.disablable = true;
         this.modeMenu = [this.mnuMove,this.mnuTEdit,this.mnuPEdit,this.mnuDEdit,this.mnuExpr,this.mnuLooks,this.mnuScale,this.mnuColors];
         this.mainMenuItems = [this.mnuAddC,this.mnuAddD,this.mnuAddP,this.mnuAddB,this.mnuAddPh,this.mnuDraw];
         this.excludeMenuItems = [this.mnuZoomFace,this.mnuZoomBody,this.mnuUndo,this.mnuRedo,this.mnuBorder];
         this.horizontalItems = [];
         _loc2_ = this.menu.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            for each(_loc3_ in this.menu[_loc1_])
            {
               _loc3_.visible = false;
               if(_loc3_.y > 300)
               {
                  this.horizontalItems.push(_loc3_);
               }
            }
            _loc1_++;
         }
         this.slider.visible = false;
         this.containerB = new MovieClip();
         this.containerB.name = "containerB";
         this.contents.addChild(this.containerB);
         this.contentsC = new MovieClip();
         this.contentsC.name = "contentsC";
         this.contents.addChild(this.contentsC);
         this.containerC = new MovieClip();
         this.containerC.name = PROP_CONTAINER;
         this.contentsC.addChild(this.containerC);
         this.containerD = new MovieClip();
         this.containerD.name = "containerD";
         this.contents.addChild(this.containerD);
         this.fx.register(this.containerB,this.containerC,this.containerD);
         this.customBorder = new Border();
         addChild(this.customBorder);
         setChildIndex(this.customBorder,getChildIndex(this.contentMask));
         this.crosshairs.visible = false;
         if(!Main.isReadOnly())
         {
            Utils.addListener(stage,MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
            Utils.addListener(stage,KeyboardEvent.KEY_DOWN,this.onDownKey);
            Utils.addListener(stage,KeyboardEvent.KEY_UP,this.onUpKey);
            this.btnPan.setHandler(this.togglePanning,false);
            Utils.addListener(this.btnPan,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.addListener(this.btnPan,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.useHand(this.btnEditLarge);
            Utils.addListener(this.btnEditLarge,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.addListener(this.btnEditLarge,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.addListener(this.btnEditLarge,MouseEvent.MOUSE_OVER,this.updateLarge);
            Utils.addListener(this.btnEditLarge,MouseEvent.MOUSE_OUT,this.updateLarge);
            Utils.addListener(this.btnEditLarge,MouseEvent.CLICK,this.editLarge);
            Utils.addListener(this.animation,PixtonEvent.STATE_CHANGE,this.onStateChange);
         }
         Edit3D.init(this);
         if(Team.isVisible)
         {
            Utils.addListener(this.contents,MouseEvent.MOUSE_DOWN,this.onBeginAction);
            Utils.addListener(this.selector,MouseEvent.MOUSE_DOWN,this.onBeginAction);
            Utils.addListener(this.zoomer,MouseEvent.MOUSE_DOWN,this.onBeginAction);
            Utils.addListener(this.cornerSE,MouseEvent.MOUSE_DOWN,this.onBeginAction);
         }
         this.allButtons = Utils.toUnique(Utils.mergeArrays(this.modeMenu,this.menu[MODE_MAIN],this.menu[MODE_MOVE],this.menu[MODE_EXPR],this.menu[MODE_LOOKS],this.menu[MODE_SCALE],this.menu[MODE_COLORS],this.menu[MODE_BORDER],this.menuUndo,this.zoomer,this.btnPan,this.resizerH,this.resizerV,this.rotateNE,this.cornerNE));
         if(Main.isPhotoEssay())
         {
            Utils.useHand(this.imageCredit.bkgd);
            Utils.useHand(this.imageCredit.btnReport);
            Utils.addListener(this.imageCredit.bkgd,MouseEvent.CLICK,this.onImageCredit);
            this.imageCredit.txtValue.mouseEnabled = false;
            Utils.addListener(this.imageCredit.btnReport,MouseEvent.CLICK,this.onImageReport);
            Utils.addListener(this.imageCredit.btnReport,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.addListener(this.imageCredit.btnReport,MouseEvent.ROLL_OUT,this.hideHelp);
         }
      }
      
      private function editLarge(param1:MouseEvent) : void
      {
         Main.setLargeMode(!Main.isLargeMode());
      }
      
      public function setViewScale(param1:Number) : void
      {
         this.scaleX = param1;
         this.scaleY = this.scaleX;
         this.offsetBorder(param1);
      }
      
      private function offsetBorder(param1:Number) : void
      {
         if(param1 > 1)
         {
            this.customBorder.x = (param1 - 1) * 0.5;
         }
         else
         {
            this.customBorder.x = 0;
         }
         this.customBorder.y = this.customBorder.x;
      }
      
      private function updateLarge(param1:MouseEvent) : void
      {
         this.btnEditLarge.icon.scaleX = param1.type == MouseEvent.MOUSE_OVER ? 1.1 : 1;
         this.btnEditLarge.icon.scaleY = this.btnEditLarge.icon.scaleX;
      }
      
      public function fixSize() : void
      {
         removeChild(this.resizerH);
         removeChild(this.resizerV);
      }
      
      public function getPositionData() : Object
      {
         return {
            "x":this.xPos,
            "y":this.yPos,
            "r":this.sceneRotation,
            "z":this.scale
         };
      }
      
      public function getPanelData() : Object
      {
         this.updatePanelData();
         return this.panelData;
      }
      
      public function getBorderData() : Object
      {
         this.updateBorderData();
         return this.borderData;
      }
      
      public function getWHData() : Object
      {
         return {
            "w":this.getWidth(),
            "h":this.getHeight()
         };
      }
      
      private function updatePanelData() : void
      {
         this.panelData = {
            "pt":this.panelTitle.getText(),
            "pd":this.panelDesc.getText()
         };
         if(this.panelNotes.hasText() || Main.notesAlwaysVisible())
         {
            this.panelData["pn"] = this.panelNotes.getText();
         }
         if(canToggleMeta() || Comic.hasPanelTitles(true))
         {
            this.panelData["hasPT"] = this._hasPanelTitle;
         }
         if(canToggleMeta() || Comic.hasPanelDescriptions(true))
         {
            this.panelData["hasPD"] = this._hasPanelDesc;
         }
         if(canToggleMeta() || Comic.hasPanelDescriptions(true))
         {
            if(this._descLines != Comic.getDefDescLines())
            {
               this.panelData["descLen"] = this._descLines;
            }
            else
            {
               this.panelData["descLen"] = 0;
            }
         }
      }
      
      public function updateBorderData() : void
      {
         this.borderData = {"b":this.customBorder.getData()};
      }
      
      private function isFirstRow() : Boolean
      {
         return Comic.self.getIndex() < Comic.getSize();
      }
      
      public function getData(param1:Boolean = false) : Object
      {
         updateZ(this.containerC);
         updateZ(this.containerD);
         this.updateAssetData(param1);
         this.updatePanelData();
         this.updateBorderData();
         var _loc2_:Object = {
            "w":this.getWidth(),
            "h":this.getHeight(),
            "x":this.xPos,
            "y":this.yPos,
            "r":this.sceneRotation,
            "a":0,
            "c":this.characterData,
            "d":this.dialogData,
            "p":this.propData,
            "k":this._colorID,
            "bs":this._gradientID,
            "m":-1,
            "q":Animation.getData()
         };
         _loc2_ = Utils.mergeObjects(_loc2_,this.panelData);
         _loc2_ = Utils.mergeObjects(_loc2_,this.borderData);
         if(this.zoomMode != ZOOM_NONE && this.scaleData != null)
         {
            _loc2_["x"] = this.scaleData.x;
            _loc2_["y"] = this.scaleData.y;
            _loc2_["z"] = this.scaleData.scale;
         }
         else
         {
            _loc2_["z"] = this.scale;
         }
         if(Comic.isFreestyle())
         {
            _loc2_["xp"] = this._xComic;
            _loc2_["yp"] = this._yComic;
         }
         var _loc3_:Object = this.getExtraData();
         if(_loc3_ == null)
         {
            _loc2_["extraData"] = null;
         }
         else
         {
            _loc2_["extraData"] = Utils.encode(_loc3_);
         }
         if(Comic.isFreestyle())
         {
            _loc2_["border"] = this.hasDefaultBorder();
         }
         return _loc2_;
      }
      
      public function hasPanelDesc() : Boolean
      {
         return this._hasPanelDesc;
      }
      
      public function promptDescLen() : void
      {
         Popup.show(L.text("desc-len"),this.onDescLen,null,this._descLines.toString());
      }
      
      public function toggleNotes() : void
      {
         this.panelNotes.visible = !this.panelNotes.visible;
         Comic.self.setNotesVisible(this.panelNotes.visible);
         Main.saveComicMeta("noted",!!this.panelNotes.visible ? true : null);
         Main.setNotesAlwaysVisible(this.panelNotes.visible);
      }
      
      private function onDescLen(param1:String, param2:Function = null) : void
      {
         var _loc3_:uint = parseInt(param1);
         if(_loc3_ > 0)
         {
            this._descLines = _loc3_;
            this.updateDimensions();
         }
      }
      
      private function hasDefaultBorder() : Boolean
      {
         return this.customBorder.thickness == 1 && this.customBorder.shape == Border.SQUARE && this.customBorder.isDefaultColor() && this.customBorder.hasSquareCorners();
      }
      
      private function getExtraData() : Object
      {
         if(this._templateSetting && this._templateScene)
         {
            return makeExtraData(this._templateSetting,this._templateScene);
         }
         return null;
      }
      
      private function setExtraData(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._templateSetting = param1.st;
         this._templateScene = param1.sc;
         Template.setSetting(this._templateSetting);
      }
      
      public function getDialogData() : Array
      {
         this.updateAssetData(false,true);
         return this.dialogData;
      }
      
      public function getCharData() : Array
      {
         this.updateAssetData(false,false,true);
         return this.characterData;
      }
      
      private function updateAssetData(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         if(param2)
         {
            this.dialogData = [];
         }
         else if(param3)
         {
            this.characterData = [];
         }
         else
         {
            this.dialogData = [];
            this.characterData = [];
            this.propData = [];
         }
         if(!param2 && this.getHeight() > 0)
         {
            _loc6_ = this.containerC.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = this.containerC.getChildAt(_loc4_)) is Dialog)
               {
                  if(!param3)
                  {
                     this.dialogData.push(Dialog(_loc5_).getData());
                  }
               }
               else if(_loc5_ is Character)
               {
                  this.characterData.push(Character(_loc5_).getData(false,param1));
               }
               else if(_loc5_ is Prop)
               {
                  if(!param3)
                  {
                     this.propData.push(Prop(_loc5_).getData());
                  }
               }
               _loc4_++;
            }
         }
         if(!param3 && this.getHeight() > 0)
         {
            _loc6_ = this.containerD.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc5_ = this.containerD.getChildAt(_loc4_);
               this.dialogData.push(Dialog(_loc5_).getData());
               _loc4_++;
            }
         }
      }
      
      public function setDialogMode(param1:Dialog) : void
      {
         if(param1.stage != null && param1.parent.parent.parent is Editor)
         {
            if(param1.isProp())
            {
               this.containerC.addChild(param1);
            }
            else
            {
               this.containerD.addChild(param1);
            }
         }
      }
      
      public function getSpeechDialogs(param1:Character = null) : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc4_:Array = [];
         _loc3_ = this.containerD.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.containerD.getChildAt(_loc2_);
            if(Dialog(_loc5_).target != null)
            {
               if(param1 == null || Dialog(_loc5_).target == param1)
               {
                  _loc4_.push(_loc5_);
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function resetUndo() : void
      {
         this.undoStack = [];
         this.currentState = -1;
         this.loading = true;
         this.onStateChange();
         this.loading = false;
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         Utils.monitorMemory("editor");
         this.dirty = true;
         if(param1 || !OS.canInvalidate() || Main.isHiResRender())
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
         if(!this.dirty)
         {
            return;
         }
         this.dirty = false;
         this.updateDialogSpikes();
         this.updateSelector();
         this.updateColor();
         if(this.firstRender)
         {
            this.firstRender = false;
            this.onPreview();
         }
      }
      
      public function setData(param1:Object, param2:uint = 0, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:MovieClip = null;
         var _loc12_:Panel = null;
         var _loc6_:* = param2 == ACTION_PASTING;
         var _loc7_:* = param2 == ACTION_RESTORING;
         if(!_loc6_ && !_loc7_ && !param5 && !Main.isAutoRender())
         {
            if(_loc12_ = Comic.self.getActivePanel())
            {
               param1.w = _loc12_.getWidth();
               param1.h = _loc12_.getHeight(true,true);
            }
         }
         this.circle.visible = Main.isPixture() && !Main.isBusiness();
         stage.focus = null;
         this.loading = true;
         if(!_loc6_ && !_loc7_ && !param5 && !Main.isAutoRender())
         {
            this.originalAssetData = param1;
         }
         else
         {
            _loc10_ = this.getData();
         }
         if(_loc6_ && _loc10_ && !Main.controlPressed)
         {
            if(_loc10_.hasPT != null)
            {
               param1.hasPT = _loc10_.hasPT;
            }
            if(_loc10_.hasPD != null)
            {
               param1.hasPD = _loc10_.hasPD;
               if(_loc10_.descLen != null && _loc10_.descLen != 0)
               {
                  param1.descLen = _loc10_.descLen;
               }
            }
            if(_loc10_.pn != null)
            {
               param1.pn = _loc10_.pn;
            }
            if(_loc10_.b != null)
            {
               param1.b = _loc10_.b;
            }
         }
         if(Main.isTChart() || Main.isGrid())
         {
            if(this.isFirstRow())
            {
               param1.hasPT = true;
            }
            else if(!Comic.self.getPanelKey())
            {
               param1.hasPT = null;
               param1.pt = null;
            }
         }
         this.updateZoomerRange();
         if(param4)
         {
            this.scale = param1.z;
            this.zoomer.updateValue(this.zoomer.calculateValue(this.scale));
            this.redraw(true);
         }
         else
         {
            this.zoomer.value = this.zoomer.calculateValue(param1.z);
         }
         this.customBorder.setData(param1.b);
         this._descLines = Comic.getDefDescLines();
         if(canToggleMeta() || Comic.hasPanelTitles(true))
         {
            this._hasPanelTitle = param1.hasPT || Main.isTemplatesUser() && (Main.isTChart() || Main.isGrid()) && this.isFirstRow() && Comic.hasPanelTitles();
         }
         if(canToggleMeta() || Comic.hasPanelDescriptions(true))
         {
            this._hasPanelDesc = param1.hasPD || Main.isTemplatesUser() && (Main.isTChart() || Main.isGrid()) && this.isFirstRow() && Comic.hasPanelDescriptions();
            if(param1.descLen != null && param1.descLen != 0)
            {
               this._descLines = param1.descLen;
            }
         }
         if(!param3)
         {
            if(Main.isPhotoEssay())
            {
               this.setColor(Palette.BLACK_ID);
            }
            else
            {
               this.setColor(param1.k);
            }
            if(param1.bs != null && param1.bs <= Palette.GRADIENT_MAX)
            {
               this.setGradient(param1.bs);
            }
            else
            {
               this.setGradient(Palette.GRADIENT_NONE);
            }
            if(!(_loc6_ || _loc7_) || TeamRole.can(TeamRole.PANELS))
            {
               if((_loc6_ || _loc7_) && _loc10_.xp != null && _loc10_.yp != null)
               {
                  param1.xp = _loc10_.xp;
                  param1.yp = _loc10_.yp;
               }
               if(param1.xp != null && param1.yp != null && Border.canView())
               {
                  this.setComicXY(param1.xp,param1.yp,true);
               }
               if(param1.w != null && param1.h != null)
               {
                  this.setDimensions(param1.w,param1.h);
               }
            }
            this.zOrder = [];
            this.zOrderLegacy = [];
            this.loadCharacters(param1.c,param1.m);
            photosToLoad = 0;
            photosLoaded = 0;
            Prop.load(this,param1.p);
            checkPhotosLoaded();
            if(!((_loc6_ || _loc7_) && Main.controlPressed))
            {
               this.loadDialog(param1.d);
            }
            this.checkBounds(this.getWidth(),this.getHeight());
         }
         if(param4)
         {
            this.setColor(param1.k);
         }
         this.xPos = param1.x;
         this.yPos = param1.y;
         this.setRotation(param1.r);
         if(!param3 && Animation.isAvailable())
         {
            Animation.setData(param1.q,_loc6_ || _loc7_);
         }
         if(param1.extraData)
         {
            this.setExtraData(Utils.decode(param1.extraData));
         }
         this.panelTitle.setEditable(TeamRole.can(TeamRole.DIALOG));
         this.panelDesc.setEditable(TeamRole.can(TeamRole.DIALOG));
         this.panelNotes.setEditable(TeamRole.can(TeamRole.DIALOG));
         this.panelTitle.setDefaultValue(L.text("panel-title"));
         this.panelDesc.setDefaultValue(L.text("panel-desc"));
         this.panelNotes.setDefaultValue(L.text("panel-notes"));
         this.updateTextVis();
         if(this.panelTitle.isEditable())
         {
            Utils.addListener(this.panelTitle,PixtonEvent.CHANGE,this.onChangePanelTitle);
         }
         else
         {
            Utils.removeListener(this.panelTitle,PixtonEvent.CHANGE,this.onChangePanelTitle);
         }
         if(this.panelDesc.isEditable())
         {
            Utils.addListener(this.panelDesc,PixtonEvent.CHANGE,this.onChangePanelDesc);
         }
         else
         {
            Utils.removeListener(this.panelDesc,PixtonEvent.CHANGE,this.onChangePanelDesc);
         }
         if(this.panelNotes.isEditable())
         {
            Utils.addListener(this.panelNotes,PixtonEvent.CHANGE,this.onChangePanelNotes);
         }
         else
         {
            Utils.removeListener(this.panelNotes,PixtonEvent.CHANGE,this.onChangePanelNotes);
         }
         if(!_loc6_)
         {
            this.panelTitle.setText(param1.pt);
            this.panelDesc.setText(param1.pd);
            if(Main.allowNotes())
            {
               if(param1.pn && param1.pn != "" || Main.notesAlwaysVisible())
               {
                  this.panelNotes.visible = true;
                  this.panelNotes.setText(param1.pn);
               }
               else
               {
                  this.panelNotes.setText("");
               }
            }
         }
         if(!_loc6_ && !_loc7_ && !param5)
         {
            this.mode = MODE_MAIN;
            this.onLoadTeamRoles();
            this.setSelection();
         }
         this.firstRender = true;
         if(Main.hasPreview())
         {
            this.showPreview();
         }
         _loc9_ = this.menu.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            for each(_loc11_ in this.menu[_loc8_])
            {
               Utils.addListener(_loc11_,MouseEvent.ROLL_OVER,this.showHelp);
               Utils.addListener(_loc11_,MouseEvent.ROLL_OUT,this.hideHelp);
               Utils.addListener(_loc11_,MouseEvent.CLICK,this.onMenu);
            }
            _loc8_++;
         }
         for each(_loc11_ in this.modeMenu)
         {
            Utils.addListener(_loc11_,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.addListener(_loc11_,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.addListener(_loc11_,MouseEvent.CLICK,this.onMenu);
         }
         Utils.addListener(this.selector,PixtonEvent.MOVE_TARGET,this.onTargetMoved);
         Utils.addListener(this.selector,PixtonEvent.STATE_CHANGE,this.onSelectorStateChange);
         if(Template.isActive())
         {
            this.lockAll(false,true);
         }
         Main.showEditor();
         Main.resizeStage();
         this.loading = false;
         if(OS.canInvalidate() && !Main.isHiResRender())
         {
            Utils.addListener(this,Event.RENDER,this.onRender);
         }
         Utils.monitorMemory();
      }
      
      private function onChangePanelTitle(param1:PixtonEvent) : void
      {
         if(this.loading)
         {
            return;
         }
         this.onChangePanelText(this.panelTitle.getText() == "");
         this.setSaved(false);
      }
      
      private function onChangePanelDesc(param1:PixtonEvent) : void
      {
         if(this.loading)
         {
            return;
         }
         this.onChangePanelText(this.panelDesc.getText() == "");
         this.setSaved(false);
      }
      
      private function onChangePanelNotes(param1:PixtonEvent) : void
      {
         if(this.loading)
         {
            return;
         }
         this.onChangePanelText(this.panelNotes.getText() == "");
         this.setSaved(false);
      }
      
      private function onChangePanelText(param1:Boolean = false) : void
      {
         this.clearPanelTextTimeout();
         if(param1)
         {
            this.onChangePanelTextTimeout();
         }
         else
         {
            this._textChangeTimeout = setTimeout(this.onChangePanelTextTimeout,3000);
         }
      }
      
      private function onChangePanelTextTimeout() : void
      {
         this.clearPanelTextTimeout();
         this.onStateChange(null,false);
      }
      
      private function clearPanelTextTimeout() : void
      {
         if(this._textChangeTimeout != -1)
         {
            clearTimeout(this._textChangeTimeout);
            this._textChangeTimeout = -1;
         }
      }
      
      public function doAutoAction() : void
      {
         if(Main.isCharMap() && this.getHeight() > 0 && this.containerC.numChildren == 0)
         {
            this.pickCharacter(Pixton.POOL_MINE);
         }
      }
      
      private function updateTextVis() : void
      {
         if(Main.isMindMap() && this.getHeight() == 0)
         {
            this.panelTitle.visible = true;
            this.panelDesc.visible = false;
         }
         else
         {
            this.panelTitle.visible = Comic.hasPanelTitles() || this._hasPanelTitle;
            this.panelDesc.visible = Comic.hasPanelDescriptions() || this._hasPanelDesc;
         }
         this.panelTitle.allowMultiline(!this.panelDesc.visible && this.getHeight() == 0);
      }
      
      public function showPreview() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:BitmapData = new BitmapData(Main.previewWidth,Main.previewHeight,true,1711276032);
         if(this.preview == null)
         {
            this.preview = new MovieClip();
            this.preview.x = Main.widthUI - Math.round(Main.previewWidth * Main.previewScale);
            Utils.useHand(this.preview);
            addChild(this.preview);
            this.previewBM = new Bitmap(_loc1_);
            this.previewBM.scaleX = Main.previewScale;
            this.previewBM.scaleY = Main.previewScale;
            this.preview.addChild(this.previewBM);
            _loc2_ = new MovieClip();
            this.preview.addChild(_loc2_);
            Utils.drawBorder(_loc2_,this.previewBM,Palette.colorText);
            Utils.addListener(this.preview,MouseEvent.CLICK,this.onPreview);
         }
         this.previewBM.bitmapData = _loc1_;
         this.preview.visible = true;
      }
      
      private function onPreview(param1:MouseEvent = null) : void
      {
         if(!Main.hasPreview() || this.preview == null)
         {
            return;
         }
         this.previewBM.bitmapData = Pixton.getEditorImage(this,Pixton.THUMBNAIL,null,false,true);
         this.previewBM.smoothing = true;
      }
      
      private function loadDialog(param1:Array) : void
      {
         var _loc2_:Dialog = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         Dialog.load(this,param1);
         _loc4_ = this.containerD.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.containerD.getChildAt(_loc3_) as Dialog;
            _loc2_.target = this.getTarget(_loc2_.tempTarget);
            _loc2_.redraw();
            _loc3_++;
         }
      }
      
      public function showOnlyContents() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = getChildAt(_loc2_);
            _loc1_.visible = _loc1_.name == "contents";
            _loc2_++;
         }
      }
      
      public function setPositionData(param1:Object, param2:Boolean = false) : void
      {
         this.originalPositionData = param1;
         this.setComicXY(param1.x,param1.y + Comic.contentYOffset);
         this.noImage = param1.noImage;
         this.maxWidth = param1.maxWidth;
         this.maxHeight = Comic.maxHeight;
         this.setDimensions(param1.w,this.getHeight());
         Utils.addListener(this.zoomer,PixtonEvent.CHANGE,this.updateZoom);
         if(Border.canMove())
         {
            Utils.useHand(this.border.top);
            Utils.addListener(this.border.top,MouseEvent.MOUSE_DOWN,this.startMoveScene);
            Utils.addListener(this.border.top,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.addListener(this.border.top,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.addListener(this.border.top,MouseEvent.ROLL_OVER,this.changeCursor);
            Utils.addListener(this.border.top,MouseEvent.ROLL_OUT,this.revertCursor);
         }
         if(!Main.isReadOnly())
         {
            Utils.addListener(this.customBorder,PixtonEvent.CHANGE,this.onBorderChange);
            Utils.addListener(stage,MouseEvent.MOUSE_DOWN,this.startMove);
            Utils.addListener(this.zoomer,PixtonEvent.STATE_CHANGE,this.onZoomerStateChange);
            this.rotateNE.setTarget(this.contentsC,this.updateRotate,this.onRotateStateChange);
            this.resizerH.setTarget(this.bkgd,this.updateResize,this.onStateChange);
            this.resizerV.setTarget(this.bkgd,this.updateResize,this.onStateChange);
            this.cornerNE.setTarget(this.customBorder,this.updateCorner,this.onStateChange);
            this.cornerSE.setTarget(this.customBorder,this.updateCorner,this.onStateChange);
            this.cornerSW.setTarget(this.customBorder,this.updateCorner,this.onStateChange);
            this.cornerNW.setTarget(this.customBorder,this.updateCorner,this.onStateChange);
         }
         if(param2)
         {
            this.setSaved(true);
         }
      }
      
      public function setSaved(param1:Boolean, param2:Boolean = false, param3:Boolean = true) : void
      {
         if(Main.isPropPreview())
         {
            return;
         }
         this._saved = param1;
         this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_STATE,param1,param3));
         if(param2)
         {
            this.refreshMenu();
         }
      }
      
      public function getSaved() : Boolean
      {
         return this._saved;
      }
      
      public function isSaved() : Boolean
      {
         if(!Main.displayManager.GET(this,DisplayManager.P_VIS))
         {
            return true;
         }
         this.setSelection();
         return this.getSaved();
      }
      
      private function updateDimensions() : void
      {
         this.setDimensions(this.getWidth(),this.getHeight());
      }
      
      private function setDimensions(param1:Number, param2:Number, param3:Boolean = false, param4:Resizer = null) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:MenuItem = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         if(param4 != this.resizerV)
         {
            if(isNaN(param1))
            {
               param1 = this.getWidth();
            }
            if(param3)
            {
               if(Comic.isFreestyle() || Main.isPregenUser())
               {
                  param1 = Math.round(param1 / GRID_SIZE) * GRID_SIZE;
               }
               else
               {
                  _loc12_ = 1;
                  _loc5_ = 2;
                  while(_loc5_ <= 5)
                  {
                     _loc10_ = this.maxWidth - (_loc5_ - 1) * Comic.PADDING_H;
                     _loc9_ = _loc5_ * (param1 / _loc10_);
                     if((_loc11_ = Math.round(_loc9_)) < _loc5_ && Math.abs(_loc9_ - _loc11_) < WIDTH_SNAP_TOLERANCE)
                     {
                        param1 = Math.ceil(_loc11_ / _loc5_ * _loc10_);
                        break;
                     }
                     _loc5_++;
                  }
               }
            }
            if(Comic.fixedWidth)
            {
               param1 = this.maxWidth;
            }
            else if(Comic.isFreestyle())
            {
               param1 = Utils.limit(Math.floor(param1),Comic.minWidth,this.maxWidth - x);
            }
            else
            {
               param1 = Utils.limit(Math.floor(param1),Comic.minWidth,this.maxWidth);
            }
            if(Comic.maxPanelWidth > 0 && param1 > Comic.maxPanelWidth)
            {
               param1 = Comic.maxPanelWidth;
            }
            if(param4 == this.resizerH && param1 == this.getWidth())
            {
               return;
            }
         }
         else
         {
            param1 = this.getWidth();
         }
         if(param4 != this.resizerH)
         {
            if(isNaN(param2))
            {
               param2 = this.getHeight();
            }
            if(param3)
            {
               param2 = Math.round(param2 / GRID_SIZE) * GRID_SIZE;
            }
            if(param2 != 0)
            {
               if(Comic.fixedWidth)
               {
                  param2 = Comic.defaultHeight;
               }
               else if(Comic.isFreestyle() || Main.canChangeRowHeight() || Main.isPregenUser())
               {
                  param2 = Utils.limit(Math.floor(param2),canToggleMeta() && (this._hasPanelTitle || this._hasPanelDesc) ? Number(0) : Number(Comic.minHeight),this.maxHeight);
               }
               else
               {
                  param2 = Comic.defaultHeight;
               }
            }
            if(param4 == this.resizerV && param2 == this.getHeight())
            {
               return;
            }
         }
         else
         {
            param2 = this.getHeight();
         }
         for each(_loc7_ in this.horizontalItems)
         {
            _loc7_.y = param2 + 1;
         }
         this.border.top.width = this.border.bottom.width = param1 + BORDER_THICKNESS * 2;
         this.border.bottom.y = this.border.left.height = this.border.right.height = param2;
         this.border.right.x = param1;
         if(this.panelTitle.visible)
         {
            this.panelTitle.setWidth(this.border.top.width);
            this.panelTitle.x = this.border.x - this.border.left.width;
            this.panelTitle.y = -this.panelTitle.getHeight();
         }
         if(this.panelDesc.visible)
         {
            this.panelDesc.setWidth(this.border.top.width);
            this.panelDesc.setHeight(Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * this._descLines);
            this.panelDesc.x = this.panelTitle.x;
            this.panelDesc.y = param2 + this.border.bottom.height;
         }
         if(Main.allowNotes())
         {
            this.panelNotes.setHeight(Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * this._notesLines);
            this.panelNotes.x = this.panelTitle.x;
         }
         this.rotateNE.x = this.border.top.width - 4.5;
         this.rotateNE.y = param2 + 1.5;
         _fullXMax = this.zoomer.x + this.zoomer.width;
         var _loc8_:Number = param1 - this.getWidth();
         this.bkgd.width = param1;
         this.bkgd.height = param2;
         this.limitBorderCorners();
         this.updateEditLarge();
         this.resizerH.x = param1;
         this.resizerH.y = 0;
         this.resizerH.setHeight(param2,!!Border.canEdit() ? Number(0.5) : Number(-48));
         this.resizerV.x = 0;
         this.resizerV.y = param2;
         this.resizerV.setHeight(param1,!!Border.canEdit() ? Number(0.5) : Number(-48));
         this.contentsC.x = param1 * 0.5;
         if(this.resizerH.active)
         {
            this.checkBounds(param1,param2);
         }
         this.contentsC.y = param2 * 0.5;
         this.crosshairs.x = param1 * 0.5;
         this.crosshairs.y = param2 * 0.5;
         this.mnuBorder.x = param1 * 0.5;
         this.resizerH.setPixels(param1);
         this.resizerV.setPixels(param2);
         this.onBorderChange();
         this.mnuZoomBody.x = this.getWidth() - MenuItem.SIZE + BORDER_THICKNESS;
         this.mnuZoomFace.x = this.mnuZoomBody.x - MenuItem.SIZE - MenuItem.GAP;
         if(Comic.isFreestyle())
         {
            Comic.self.requireEdges();
            this.customBorder.setComicCorners(Comic.edges);
         }
         this.updatePropInners();
         this.setDialogMaxWidth(param1);
         this.onChange();
         this.redraw();
         if(this.visible)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.RESIZE_SCENE,this.getSizeData()));
         }
      }
      
      private function updatePropInners() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:uint = this.containerC.numChildren;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.containerC.getChildAt(_loc3_);
            if(_loc2_ is Prop)
            {
               Prop(_loc2_).updateInners();
            }
            _loc3_++;
         }
      }
      
      public function getAsset(param1:Class) : Moveable
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:MovieClip = param1 == Dialog ? this.containerD : this.containerC;
         var _loc3_:uint = _loc2_.numChildren;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            if((_loc4_ = _loc2_.getChildAt(_loc5_)) is param1)
            {
               return _loc4_ as Moveable;
            }
            _loc5_++;
         }
         return null;
      }
      
      private function checkBounds(param1:Number, param2:Number) : void
      {
         var _loc3_:Dialog = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = this.containerD.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.containerD.getChildAt(_loc4_) as Dialog;
            _loc3_.checkBounds(param1,param2);
            _loc4_++;
         }
      }
      
      private function updateMenuPosition() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:MenuItem = null;
         var _loc1_:Number = this.getWidth(true) + this.border.left.width;
         var _loc2_:Number = this.getHeight();
         var _loc3_:Number = -(MenuItem.SIZE + MenuItem.GAP + BORDER_THICKNESS);
         var _loc4_:Number = Math.max(_loc2_ + (Comic.hasPanelDescriptions() || this._hasPanelDesc ? Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * this._descLines : 0) + BORDER_THICKNESS * 2,150);
         for each(_loc6_ in this.menuUndo)
         {
            _loc4_ -= MenuItem.SIZE + MenuItem.GAP;
            _loc6_.y = _loc4_;
            _loc5_ = _loc4_;
         }
         currentMenuY = -BORDER_THICKNESS;
         _loc4_ = -BORDER_THICKNESS;
         this.heightWithMenu = 0;
         if(this.mode == MODE_MAIN)
         {
            for each(_loc6_ in this.mainMenuItems)
            {
               if(!(!_loc6_.visible || Utils.inArray(_loc6_,this.excludeMenuItems)))
               {
                  _loc6_.parent.setChildIndex(_loc6_,0);
                  _loc6_.x = _loc3_;
                  _loc6_.y = _loc4_;
                  if((_loc4_ += MenuItem.SIZE + MenuItem.GAP) + MenuItem.SIZE + MenuItem.GAP > _loc5_)
                  {
                     _loc4_ = -BORDER_THICKNESS;
                     _loc3_ -= MenuItem.SIZE + MenuItem.GAP;
                  }
               }
            }
         }
         _fullXMin = _loc3_;
         _loc3_ = -BORDER_THICKNESS;
         currentMenuY = this.getHeight(false) + BORDER_THICKNESS + MenuItem.GAP;
         for each(_loc6_ in this.menu[this.mode])
         {
            if(!(!_loc6_.visible || Utils.inArray(_loc6_,this.excludeMenuItems) || this.mode == MODE_MAIN && Utils.inArray(_loc6_,this.mainMenuItems)))
            {
               _loc6_.parent.setChildIndex(_loc6_,0);
               _loc6_.x = _loc3_;
               _loc6_.y = currentMenuY;
               this.heightWithMenu = Math.max(this.heightWithMenu,_loc6_.y + MenuItem.SIZE + MenuItem.GAP);
               _loc3_ += MenuItem.SIZE + MenuItem.GAP;
               _fullYMax = currentMenuY + MenuItem.SIZE;
               if(_loc3_ + MenuItem.SIZE > _loc1_)
               {
                  _loc3_ = -BORDER_THICKNESS;
                  currentMenuY += MenuItem.SIZE + MenuItem.GAP;
               }
            }
         }
         if(Main.allowNotes())
         {
            this.panelNotes.setWidth(this.getWidth(true));
            this.panelNotes.y = _fullYMax + PADDING * 2;
         }
         this.zoomer.x = this.getWidth(true) + this.border.left.width * 2;
         this.btnPan.x = this.zoomer.x;
      }
      
      private function onBorderChange(param1:PixtonEvent = null, param2:MovieClip = null) : void
      {
         var _loc3_:uint = this.getWidth();
         var _loc4_:uint = this.getHeight();
         this.customBorder.draw(this.contentMask,_loc3_,_loc4_);
         this.customBorder.draw(this.selectorMask,_loc3_,_loc4_);
         this.customBorder.draw(null,_loc3_,_loc4_,param2);
         this.customBorder.updateFilters([this.containerB,this.containerC]);
         this.updateCornerHandles();
         this.updateMenuPosition();
      }
      
      public function getSizeData() : Object
      {
         return {
            "x":x,
            "y":y,
            "width":this.getWidth(),
            "height":this.getHeight()
         };
      }
      
      public function getWidth(param1:Boolean = false) : Number
      {
         if(param1)
         {
            return Math.max(this.getWidth(),(MenuItem.SIZE + MenuItem.GAP) * 3 - MenuItem.GAP);
         }
         return this.bkgd.width;
      }
      
      public function getHeight(param1:Boolean = true, param2:Boolean = false) : Number
      {
         var _loc3_:uint = 0;
         if(param2)
         {
            if(this.panelNotes.visible)
            {
               _loc3_ += Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * this._notesLines;
            }
         }
         else
         {
            _loc3_ += this.bkgd.height;
            if(!param1 && this.panelDesc.visible)
            {
               _loc3_ += Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * this._descLines;
            }
         }
         return _loc3_;
      }
      
      public function unsetData() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         AppState.clear();
         this.prevClickTime = 0;
         if(this.isPanning())
         {
            this.togglePanning();
         }
         Utils.removeListener(this,Event.RENDER,this.onRender);
         this.zoomOut();
         this.onClickAway();
         Utils.removeListener(this.customBorder,PixtonEvent.CHANGE,this.onBorderChange);
         Utils.removeListener(stage,MouseEvent.MOUSE_DOWN,this.startMove);
         Utils.removeListener(this.zoomer,PixtonEvent.CHANGE,this.updateZoom);
         Utils.removeListener(this.zoomer,PixtonEvent.STATE_CHANGE,this.onZoomerStateChange);
         if(Border.canMove())
         {
            Utils.removeListener(this.border.top,MouseEvent.MOUSE_DOWN,this.startMoveScene);
            Utils.removeListener(this.border.top,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.removeListener(this.border.top,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.removeListener(this.border.top,MouseEvent.ROLL_OVER,this.changeCursor);
            Utils.removeListener(this.border.top,MouseEvent.ROLL_OUT,this.revertCursor);
         }
         if(Team.isActive)
         {
            this.clearTeamTimer();
         }
         this.clearPanelTextTimeout();
         this.destroySnapshot();
         this.rotateNE.setTarget();
         this.resizerH.setTarget();
         this.resizerV.setTarget();
         this.cornerNE.setTarget();
         this.cornerSE.setTarget();
         this.cornerSW.setTarget();
         this.cornerNW.setTarget();
         this.selector.visible = false;
         this.namer.visible = false;
         this.clearBackground();
         Animation.unsetData();
         warnedFeatureLoss = false;
         var _loc3_:uint = this.menu.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            for each(_loc1_ in this.menu[_loc2_])
            {
               Utils.removeListener(_loc1_,MouseEvent.ROLL_OVER,this.showHelp);
               Utils.removeListener(_loc1_,MouseEvent.ROLL_OUT,this.hideHelp);
               Utils.removeListener(_loc1_,MouseEvent.CLICK,this.onMenu);
            }
            _loc2_++;
         }
         for each(_loc1_ in this.modeMenu)
         {
            Utils.removeListener(_loc1_,MouseEvent.ROLL_OVER,this.showHelp);
            Utils.removeListener(_loc1_,MouseEvent.ROLL_OUT,this.hideHelp);
            Utils.removeListener(_loc1_,MouseEvent.CLICK,this.onMenu);
         }
         Utils.removeListener(this.selector,PixtonEvent.MOVE_TARGET,this.onTargetMoved);
         Utils.removeListener(this.selector,PixtonEvent.Z_MOVE_TARGET,this.onTargetZMoved);
         Utils.removeListener(this.selector,PixtonEvent.STATE_CHANGE,this.onSelectorStateChange);
         this.setSaved(true);
         Main.showEditor(false);
      }
      
      public function onClickAway() : void
      {
         if(!Main.enableState || Guide.isBlockingClickAway())
         {
            return;
         }
         if(Main.isCharCreate())
         {
            return;
         }
         if(Picker.isVisible())
         {
            Picker.hide();
         }
         else
         {
            this.mode = MODE_MAIN;
            this.setSelection();
         }
         stage.focus = null;
         this.cleanDialogProps();
      }
      
      private function cleanDialogProps() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:Object = null;
         var _loc2_:uint = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_) as Object;
            if(_loc3_ is Dialog && Dialog(_loc3_).isEmpty())
            {
               this.remove(_loc3_);
               _loc1_--;
               _loc2_--;
            }
            _loc1_++;
         }
      }
      
      private function updateCorner(param1:PixtonEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         this.restartTeamTimer();
         if(param1.value == null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
         }
         else if(Main.controlPressed)
         {
            _loc3_ = param1.value.x;
            _loc4_ = param1.value.y;
         }
         else
         {
            switch(param1.target)
            {
               case this.cornerNE:
                  _loc5_ = [1,3];
                  break;
               case this.cornerSE:
                  _loc5_ = [0,2];
                  break;
               case this.cornerSW:
                  _loc5_ = [3,1];
                  break;
               case this.cornerNW:
                  _loc5_ = [0,2];
            }
            _loc3_ = Math.round(param1.value.x / GRID_SIZE) * GRID_SIZE;
            if(Math.abs(_loc3_ - Border.cornerOffsets[_loc5_[0]].x) < GRID_SIZE)
            {
               _loc3_ = Border.cornerOffsets[_loc5_[0]].x;
            }
            _loc4_ = Math.round(param1.value.y / GRID_SIZE) * GRID_SIZE;
            if(Math.abs(_loc4_ - Border.cornerOffsets[_loc5_[1]].y) < GRID_SIZE)
            {
               _loc4_ = Border.cornerOffsets[_loc5_[1]].y;
            }
         }
         switch(param1.target)
         {
            case this.cornerNE:
               _loc2_ = 0;
               break;
            case this.cornerSE:
               _loc2_ = 1;
               break;
            case this.cornerSW:
               _loc2_ = 2;
               break;
            case this.cornerNW:
               _loc2_ = 3;
         }
         Border.setCornerOffset(_loc2_,_loc3_,_loc4_);
         this.limitBorderCorners();
         this.onBorderChange(null,param1.target as MovieClip);
      }
      
      private function adjustDimensions() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(Border.cornerOffsets[0].x != 0 || Border.cornerOffsets[1].x != 0)
         {
            _loc3_ = Math.max(Border.cornerOffsets[0].x,Border.cornerOffsets[1].x);
            _loc1_ += _loc3_;
            Border.cornerOffsets[0].x -= _loc3_;
            Border.cornerOffsets[1].x -= _loc3_;
         }
         if(Border.cornerOffsets[2].x != 0 || Border.cornerOffsets[3].x != 0)
         {
            _loc3_ = Math.min(Border.cornerOffsets[2].x,Border.cornerOffsets[3].x);
            _loc1_ -= _loc3_;
            if(_loc3_ < 0)
            {
               _loc4_ = _loc3_;
            }
            Border.cornerOffsets[2].x -= _loc3_;
            Border.cornerOffsets[3].x -= _loc3_;
         }
         if(Border.cornerOffsets[3].y != 0 || Border.cornerOffsets[0].y != 0)
         {
            _loc3_ = Math.min(Border.cornerOffsets[3].y,Border.cornerOffsets[0].y);
            _loc2_ -= _loc3_;
            if(_loc3_ < 0)
            {
               _loc5_ = _loc3_;
            }
            Border.cornerOffsets[3].y -= _loc3_;
            Border.cornerOffsets[0].y -= _loc3_;
         }
         if(Border.cornerOffsets[1].y != 0 || Border.cornerOffsets[2].y != 0)
         {
            _loc3_ = Math.max(Border.cornerOffsets[1].y,Border.cornerOffsets[2].y);
            _loc2_ += _loc3_;
            Border.cornerOffsets[1].y -= _loc3_;
            Border.cornerOffsets[2].y -= _loc3_;
         }
         if(_loc1_ != 0 || _loc2_ != 0)
         {
            this.setDimensions(this.getWidth() + _loc1_,this.getHeight() + _loc2_);
         }
         if(_loc4_ != 0 || _loc5_ != 0)
         {
            this.setComicXY(this._xComic + _loc4_,this._yComic + _loc5_,true);
         }
      }
      
      private function limitBorderCorners() : void
      {
         if(!Border.canEdit())
         {
            return;
         }
         var _loc1_:Number = this.getWidth();
         var _loc2_:Number = this.getHeight();
         if(_loc1_ + Border.cornerOffsets[0].x < Border.cornerOffsets[3].x + this.customBorder.thickness)
         {
            Border.setCornerOffset(0,Border.cornerOffsets[3].x - _loc1_ + this.customBorder.thickness,Border.cornerOffsets[0].y);
         }
         if(_loc1_ + Border.cornerOffsets[0].x < Border.cornerOffsets[3].x + this.customBorder.thickness)
         {
            Border.setCornerOffset(3,_loc1_ + Border.cornerOffsets[0].x - this.customBorder.thickness,Border.cornerOffsets[3].y);
         }
         if(_loc1_ + Border.cornerOffsets[1].x < Border.cornerOffsets[2].x + this.customBorder.thickness)
         {
            Border.setCornerOffset(1,Border.cornerOffsets[2].x - _loc1_ + this.customBorder.thickness,Border.cornerOffsets[1].y);
         }
         if(_loc1_ + Border.cornerOffsets[1].x < Border.cornerOffsets[2].x + this.customBorder.thickness)
         {
            Border.setCornerOffset(2,_loc1_ + Border.cornerOffsets[1].x - this.customBorder.thickness,Border.cornerOffsets[2].y);
         }
         if(_loc2_ + Border.cornerOffsets[1].y < Border.cornerOffsets[0].y + this.customBorder.thickness)
         {
            Border.setCornerOffset(1,Border.cornerOffsets[1].x,Border.cornerOffsets[0].y - _loc2_ + this.customBorder.thickness);
         }
         if(_loc2_ + Border.cornerOffsets[1].y < Border.cornerOffsets[0].y + this.customBorder.thickness)
         {
            Border.setCornerOffset(0,Border.cornerOffsets[0].x,_loc2_ + Border.cornerOffsets[1].y - this.customBorder.thickness);
         }
         if(_loc2_ + Border.cornerOffsets[2].y < Border.cornerOffsets[3].y + this.customBorder.thickness)
         {
            Border.setCornerOffset(2,Border.cornerOffsets[2].x,Border.cornerOffsets[3].y - _loc2_ + this.customBorder.thickness);
         }
         if(_loc2_ + Border.cornerOffsets[2].y < Border.cornerOffsets[3].y + this.customBorder.thickness)
         {
            Border.setCornerOffset(3,Border.cornerOffsets[3].x,_loc2_ + Border.cornerOffsets[2].y - this.customBorder.thickness);
         }
      }
      
      private function updateCornerHandles() : void
      {
         var _loc1_:Number = this.getWidth();
         var _loc2_:Number = this.getHeight();
         this.cornerNE.x = _loc1_ + 1.5 + Border.cornerOffsets[0].x;
         this.cornerNE.y = -1.5 + Border.cornerOffsets[0].y;
         this.cornerSE.x = _loc1_ + 1.5 + Border.cornerOffsets[1].x;
         this.cornerSE.y = _loc2_ + 1.5 + Border.cornerOffsets[1].y;
         this.cornerSW.x = -1.5 + Border.cornerOffsets[2].x;
         this.cornerSW.y = _loc2_ + 1.5 + Border.cornerOffsets[2].y;
         this.cornerNW.x = -1.5 + Border.cornerOffsets[3].x;
         this.cornerNW.y = -1.5 + Border.cornerOffsets[3].y;
      }
      
      private function updateResize(param1:PixtonEvent) : void
      {
         if(this.scaleX != 1)
         {
            Main.setLargeMode(false);
         }
         this.restartTeamTimer();
         Comic.self.dirtyMargins();
         if(param1.value == null)
         {
            if(Border.canEdit() || Main.canChangeRowHeight())
            {
               if(param1.value2 == this.resizerH)
               {
                  this.setDimensions(this.getHeight(),this.getHeight(),false,param1.value2 as Resizer);
               }
               else
               {
                  this.setDimensions(this.getWidth(),this.getWidth(),false,param1.value2 as Resizer);
               }
            }
            else
            {
               this.setDimensions(Comic.defaultWidth,Comic.defaultHeight);
            }
         }
         else if(Border.canEdit() || Main.isPregenUser() || Main.canChangeRowHeight() || param1.target == this.resizerH)
         {
            this.setDimensions(param1.value.x,param1.value.y,!Main.controlPressed,param1.target as Resizer);
         }
         else
         {
            this.resizerV.stopAction();
            Main.promptFreestyle();
         }
         this.redraw();
         Main.resizeStage();
      }
      
      function setComicXY(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param3)
         {
            this._xComic = param1 - Comic.self.x;
            this._yComic = param2 - Comic.self.y;
            if(!Main.controlPressed)
            {
               param1 = Math.round(param1 / GRID_SIZE) * GRID_SIZE;
               param2 = Math.round(param2 / GRID_SIZE) * GRID_SIZE;
            }
            this._xComic = Utils.limit(param1,0,this.maxWidth - this.getWidth());
            if(param2 > Comic.maxRows * Comic.maxHeight - this.getHeight() && !warnedLengthLimit)
            {
               warnedLengthLimit = true;
               Confirm.alert(L.text("warn-length"),false);
            }
            this._yComic = Utils.limit(param2,0,Comic.maxRows * Comic.maxHeight - this.getHeight());
            Comic.updatePosition(this._xComic,this._yComic);
         }
         else
         {
            this._xComic = param1;
            this._yComic = param2;
         }
         if(Comic.isFreestyle() || param4)
         {
            Main.displayManager.SET(this,"x",this._xComic + Comic.self.x - 0.5 * (this.getWidth() * (this.scaleX - 1)));
            Main.displayManager.SET(this,"y",this._yComic + Comic.self.y - 0.5 * (this.getHeight() * (this.scaleY - 1)));
         }
         else
         {
            Main.displayManager.SET(this,"x",this._xComic - 0.5 * (this.getWidth() * (this.scaleX - 1)));
            Main.displayManager.SET(this,"y",this._yComic - 0.5 * (this.getHeight() * (this.scaleY - 1)));
         }
         if(this.scaleX > 1)
         {
            _loc5_ = Main.getLeftX() + WIDTH_CONTROLS * this.scaleX;
            if((_loc6_ = Main.getRightX() - (this.getWidth() + WIDTH_CONTROLS) * this.scaleX) < _loc5_)
            {
               Main.displayManager.SET(this,"x",_loc5_);
            }
            else
            {
               Main.displayManager.SET(this,"x",Utils.limit(Main.displayManager.GET(this,DisplayManager.P_X),_loc5_,_loc6_));
            }
            _loc7_ = Math.max(Comic.self.y,Main.stageTopY);
            if((_loc8_ = Comic.isFreestyle() || param4 ? Number(this._yComic + Comic.self.y) : Number(this._yComic)) < _loc7_)
            {
               Main.displayManager.SET(this,"y",Math.max(Comic.self.y,_loc8_));
            }
            else
            {
               Main.displayManager.SET(this,"y",Utils.limit(Main.displayManager.GET(this,DisplayManager.P_Y),_loc7_,_loc8_));
            }
         }
      }
      
      private function startMoveScene(param1:MouseEvent) : void
      {
         if(this.scaleX > 1 || !TeamRole.can(TeamRole.PANELS))
         {
            return;
         }
         startLock();
         this.startPoint = new Point(this._xComic,this._yComic);
         this.startCursor = new Point(param1.stageX,param1.stageY);
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateMoveScene);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopMoveScene);
      }
      
      private function updateMoveScene(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.stageX - this.startCursor.x;
         var _loc3_:int = param1.stageY - this.startCursor.y;
         this.setComicXY(this.startPoint.x + _loc2_,this.startPoint.y + _loc3_,true);
         Main.resizeStage();
      }
      
      private function stopMoveScene(param1:MouseEvent) : void
      {
         endLock();
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateMoveScene);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopMoveScene);
         if(param1.stageX != this.startCursor.x || param1.stageY != this.startCursor.y)
         {
            this.onStateChange();
         }
         this.startPoint = null;
         this.startCursor = null;
      }
      
      private function startMove(param1:MouseEvent) : void
      {
         if(param1.currentTarget == stage)
         {
            if(param1.target == this.bkgd)
            {
               this.onClickAway();
               return;
            }
            if(param1.target != this.containerB && param1.target.parent != this.contentsC)
            {
               return;
            }
         }
         if(!Template.isActive() && !Main.isReadOnly() && !this.selector.visible && !Main.isCharCreate() && TeamRole.can(TeamRole.PANELS))
         {
            Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
            Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
            this.startPoint = new Point(this.xPos,this.yPos);
            this.startCursor = new Point(param1.stageX,param1.stageY);
         }
         this.onClickAway();
      }
      
      private function stopMove(param1:MouseEvent = null) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         if(param1 != null && (param1.stageX != this.startCursor.x || param1.stageY != this.startCursor.y))
         {
            this.onStateChange();
         }
         this.startPoint = null;
         this.startCursor = null;
      }
      
      private function nudgeZoom(param1:Number) : void
      {
         if(this.currentTarget == null)
         {
            this.zoomer.value += param1;
            this.onStateChange();
         }
         else if(this.currentTarget is Asset)
         {
            if(Main.shiftPressed)
            {
               param1 *= MAJOR_SHIFT;
            }
            Asset(this.currentTarget).size = Asset(this.currentTarget).size + param1 * 0.01 / this.scale;
            this.onStateChange();
         }
      }
      
      private function nudgeRotation(param1:Number) : void
      {
         if(this.currentTarget == null)
         {
            this.setRotation(this.sceneRotation + param1);
            this.onStateChange();
         }
         else if(this.currentTarget is Asset)
         {
            Asset(this.currentTarget).rotation = Asset(this.currentTarget).rotation + param1;
            this.onStateChange();
         }
         this.redraw();
      }
      
      private function nudge(param1:Number, param2:Number) : void
      {
         this.startPoint = new Point(this.xPos,this.yPos);
         var _loc3_:Number = Utils.d2r(this.contentsC.rotation);
         var _loc4_:Number = Math.sin(_loc3_);
         var _loc5_:Number = Math.cos(_loc3_);
         this.setXY(this.startPoint.x + param1 * _loc5_ + param2 * _loc4_,this.startPoint.y - param1 * _loc4_ + param2 * _loc5_);
         this.startPoint = null;
         this.onStateChange();
         this.redraw();
      }
      
      function setXY(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.xPos;
         this.xPos = param1;
         this.yPos = param2;
      }
      
      private function updateMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = Utils.d2r(this.contentsC.rotation);
         var _loc3_:Number = Math.sin(_loc2_);
         var _loc4_:Number = Math.cos(_loc2_);
         var _loc5_:Number = (param1.stageX - this.startCursor.x) / this.scaleX;
         var _loc6_:Number = (param1.stageY - this.startCursor.y) / this.scaleY;
         this.setXY(this.startPoint.x + _loc5_ * _loc4_ + _loc6_ * _loc3_,this.startPoint.y - _loc5_ * _loc3_ + _loc6_ * _loc4_);
         this.onChange(false);
         this.redraw();
      }
      
      private function setDialogMaxWidth(param1:Number) : void
      {
         var _loc2_:uint = 0;
         Dialog.maxWidth = param1;
         this.borderRect = this.customBorder.getBounds(stage);
         var _loc3_:uint = this.containerD.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Dialog(this.containerD.getChildAt(_loc2_)).updateWrapping();
            _loc2_++;
         }
      }
      
      public function updateDialogSpikes() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc2_:uint = this.containerD.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerD.getChildAt(_loc1_);
            if(_loc3_ != this.currentTarget)
            {
               Dialog(_loc3_).drawBubble();
            }
            _loc1_++;
         }
      }
      
      private function onMove(param1:PixtonEvent) : void
      {
         var _loc2_:Object = null;
         if(!Animation.isAvailable())
         {
            return;
         }
         _loc2_ = this.currentTarget.getAnimationPositionData();
         if(_loc2_ != null)
         {
            Animation.previewOnion(_loc2_);
         }
      }
      
      public function getNearestHandData(param1:Prop) : Object
      {
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc11_:Point = null;
         var _loc4_:* = this.containerC.numChildren;
         var _loc10_:Number = Comic.maxWidth * Comic.maxWidth;
         _loc8_ = param1.parent.localToGlobal(new Point(param1.x,param1.y));
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.containerC.getChildAt(_loc2_);
            if(_loc3_ is Character)
            {
               _loc5_ = 1;
               while(_loc5_ <= 2)
               {
                  _loc11_ = Character(_loc3_).getHandPosition(_loc5_);
                  if((_loc7_ = Point.distance(_loc8_,_loc11_)) < _loc10_)
                  {
                     _loc10_ = _loc7_;
                     _loc6_ = Character(_loc3_).bodyParts.getPart("hand" + _loc5_).target;
                     _loc9_ = _loc11_;
                  }
                  _loc5_++;
               }
            }
            _loc2_++;
         }
         _loc8_ = _loc6_.globalToLocal(param1.parent.localToGlobal(new Point(param1.x,param1.y)));
         return {
            "hand":_loc6_,
            "x":_loc8_.x,
            "y":_loc8_.y
         };
      }
      
      public function clearBackground() : void
      {
         this.containerB.graphics.clear();
      }
      
      public function set xPos(param1:Number) : void
      {
         this.containerC.x = param1;
         this.redraw();
      }
      
      public function set yPos(param1:Number) : void
      {
         this.containerC.y = param1;
         this.redraw();
      }
      
      public function get xPos() : Number
      {
         return this.containerC.x;
      }
      
      public function get yPos() : Number
      {
         return this.containerC.y;
      }
      
      private function updateZoom(param1:PixtonEvent) : void
      {
         switch(param1.target)
         {
            case this.zoomer:
               this.changeScale(this.zoomer.calculateScale(param1.value));
         }
         this.onChange(false);
      }
      
      private function changeScale(param1:Number) : void
      {
         var _loc4_:Point = null;
         var _loc2_:Number = this.scale;
         this.scale = param1;
         var _loc3_:Number = this.scale / _loc2_;
         if(this.scale > _loc2_ && this.currentTarget != null && this.currentTarget is Moveable)
         {
            _loc4_ = Moveable(this.currentTarget).getAttachPos();
            _loc4_ = this.containerC.parent.globalToLocal(_loc4_);
            this.xPos = this.xPos * _loc3_ * (1 - ZOOM_TARGET_SPEED) + (this.containerC.x - _loc4_.x) * ZOOM_TARGET_SPEED;
            this.yPos = this.yPos * _loc3_ * (1 - ZOOM_TARGET_SPEED) + (this.containerC.y - _loc4_.y) * ZOOM_TARGET_SPEED;
         }
         else
         {
            this.xPos *= _loc3_;
            this.yPos *= _loc3_;
         }
         this.redraw();
      }
      
      function requireSelection(param1:uint, param2:Class, param3:int = -1) : Boolean
      {
         if(param1 == MODE_MAIN)
         {
            if(param1 != this.activeMenu)
            {
               this.onClickAway();
            }
            return true;
         }
         var _loc4_:Object;
         if((_loc4_ = this.getObject(param2,param3)) == null)
         {
            return false;
         }
         this.setSelection(_loc4_);
         if(param1 != this.activeMenu)
         {
            this.mode = param1;
         }
         return true;
      }
      
      public function set mode(param1:uint) : void
      {
         var _loc2_:* = undefined;
         var _loc6_:Boolean = false;
         if(Main.isReadOnly())
         {
            this.activeMenu = param1;
            return;
         }
         this.hideHelp();
         this.mouseIsDown = false;
         if(!isNaN(this.activeMenu))
         {
            for each(_loc2_ in this.menu[this.activeMenu])
            {
               _loc2_.visible = false;
            }
         }
         if(param1 != this.activeMenu)
         {
            this.menuExtraShown = false;
         }
         for each(_loc2_ in this.menu[param1])
         {
            _loc2_.enableState = !this.isLocked() && !Main.isReadOnly();
         }
         if(!FileUpload.imagesEnabled && Main.isSchools() || !AppSettings.isAdvanced && !FileUpload.forcedVisible)
         {
            this.mnuAddPh.visible = false;
         }
         if(this.panelTitle)
         {
            this.panelTitle.enableState = !this.isLocked() && !Main.isReadOnly();
         }
         if(this.panelDesc)
         {
            this.panelDesc.enableState = !this.isLocked() && !Main.isReadOnly();
         }
         if(this.panelNotes)
         {
            this.panelNotes.enableState = !this.isLocked() && !Main.isReadOnly();
         }
         if(Main.isPhotoEssay())
         {
            this.mnuAddC.visible = false;
            this.mnuAddP.visible = false;
         }
         if(!PhotoDrawing.ENABLED || !AppSettings.isAdvanced)
         {
            this.mnuDraw.visible = false;
         }
         if((param1 == MODE_MAIN || param1 == MODE_MOVE) && Picker.clickMode)
         {
            this.hidePicker();
         }
         this.mnuColor1.enableState = false;
         this.mnuColor2.enableState = false;
         this.mnuColor3.enableState = false;
         this.mnuColor4.enableState = false;
         this.mnuColor5.enableState = false;
         this.mnuColorD.enableState = false;
         this.mnuColorDB.enableState = false;
         this.mnuSound.enableState = false;
         this.mnuRecord.enableState = false;
         this.mnuLink.enableState = false;
         this.mnuVoice.enableState = false;
         this.mnuSilOn.enableState = false;
         this.mnuSilOff.enableState = false;
         this.mnuGradient.enableState = false;
         this.mnuIsProp.enableState = false;
         this.mnuNotProp.enableState = false;
         this.mnuAlpha.enableState = false;
         this.mnuSet.enableState = false;
         this.mnuUnset.enableState = false;
         this.mnuSavePose.enableState = false;
         this.mnuSaveFace.enableState = false;
         this.mnuFont.enableState = false;
         this.mnuRegular.enableState = false;
         this.mnuBold.enableState = false;
         this.mnuItalic.enableState = false;
         this.mnuAlignL.enableState = false;
         this.mnuAlignC.enableState = false;
         this.mnuAlignR.enableState = false;
         this.mnuSize.enableState = false;
         this.mnuKeypad.enableState = false;
         this.mnuTColor.enableState = false;
         this.mnuPadding.enableState = false;
         this.mnuBubble.enableState = false;
         this.mnuSpike.enableState = false;
         this.mnuAuto.enableState = false;
         this.mnuManual.enableState = false;
         this.mnuLeading.enableState = false;
         this.mnuToFront.enableState = false;
         this.mnuDupl.enableState = false;
         this.mnuToBack.enableState = false;
         this.mnuToFront2.enableState = false;
         this.mnuToBack2.enableState = false;
         this.mnuFace.enableState = false;
         this.mnuPose.enableState = false;
         this.mnuRandFace.enableState = false;
         this.mnuRandPose.enableState = false;
         this.mnuBlurAmount.enableState = false;
         this.mnuBlurAngle.enableState = false;
         this.mnuGlowAmount.enableState = false;
         this.mnuPlay.enableState = false;
         this.mnuPause.enableState = false;
         this.mnuBSize.enableState = false;
         this.mnuDialogLine.enableState = false;
         this.mnuRand.enableState = false;
         this.mnuRevert2.enableState = false;
         this.mnuSave2.enableState = false;
         this.mnuZoomFace.enableState = false;
         this.mnuZoomBody.enableState = false;
         this.mnuLock.enableState = false;
         this.mnuColor.enableState = false;
         this.mnuRevert2.visible = false;
         this.mnuSave2.visible = false;
         this.cornerNE.visible = param1 == MODE_BORDER && Border.canEdit() && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         this.cornerSE.visible = param1 == MODE_BORDER && Border.canEdit() && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         this.cornerSW.visible = param1 == MODE_BORDER && Border.canEdit() && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         this.cornerNW.visible = param1 == MODE_BORDER && Border.canEdit() && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         this.rotateNE.visible = !this.cornerNE.visible && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && Main.isFun() && !Main.isFunStudent();
         this.mnuBorder.visible = param1 == MODE_MAIN && TeamRole.can(TeamRole.PANELS) && !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && !(Comic.isLockedPanels() && this.getHeight() == 0);
         this.btnPan.visible = param1 == MODE_MAIN && !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         this.mnuMore.visible = (param1 == MODE_MAIN || param1 == MODE_MOVE) && AppSettings.isAdvanced && !AppSettings.getActive(AppSettings.MORE) && !Template.isActive() && !this.menuExtraShown;
         this.contents.mouseEnabled = param1 != MODE_BORDER && !this.isLocked();
         this.contents.mouseChildren = this.contents.mouseEnabled;
         this.border.mouseEnabled = !this.isLocked() && !Template.isActive();
         this.border.mouseChildren = this.border.mouseEnabled;
         if(this.currentTarget is Array)
         {
            if(param1 == MODE_MOVE && !Template.isActive())
            {
               this.mnuFlipH.enableState = false;
               this.mnuFlipV.enableState = false;
               this.mnuSet.enableState = this.currentTarget.length > 1 && AppSettings.isAdvanced;
            }
         }
         else if(this.currentTarget is Character)
         {
            Utils.removeListener(this.currentTarget,PixtonEvent.CHANGE_CHARACTER,this.onChangeCharacter);
            Utils.removeListener(this.currentTarget,PixtonEvent.EDIT_CHARACTER,this.onEditCharacter);
            Utils.removeListener(this.currentTarget,PixtonEvent.DOUBLE_CLICK,this.onDoubleClick);
            Utils.removeListener(this.currentTarget,PixtonEvent.STATE_CHANGE,this.onTargetStateChange);
            if(param1 != MODE_MOVE)
            {
               if(param1 == MODE_EXPR)
               {
                  this.mnuPose.enableState = !Template.isActive() && Pose.hasType(this.currentTarget,Globals.POSES) && this.zoomMode != ZOOM_FACE;
                  this.mnuFace.enableState = !Template.isActive() && Pose.hasType(this.currentTarget,Globals.FACES) && this.zoomMode != ZOOM_BODY;
                  this.mnuFlipH.enableState = !Template.isActive();
                  this.mnuFlipZ.enableState = !Template.isActive() && (Character(this.currentTarget).skinType == Globals.HUMAN && Animation.self.visible && this.zoomMode == ZOOM_NONE);
                  this.mnuRandFace.enableState = this.mnuFace.enableState && this.zoomMode == ZOOM_FACE;
                  this.mnuRandPose.enableState = this.mnuPose.enableState && this.zoomMode == ZOOM_BODY;
                  this.mnuSaveFace.enableState = this.mnuRandFace.enableState && AppSettings.isAdvanced && !Comic.presetPosesOnly;
                  this.mnuSavePose.enableState = this.mnuRandPose.enableState && AppSettings.isAdvanced && !Comic.presetPosesOnly;
                  this.mnuPen.visible = false;
                  this.mnuErase.visible = false;
               }
               else
               {
                  this.mnuSave2.visible = true;
                  this.mnuRevert2.visible = true;
                  this.mnuSave2.enableState = !Character(this.currentTarget).getSaved() || Main.isOutfitsAdmin();
                  this.mnuRevert2.enableState = !Character(this.currentTarget).getSaved();
                  this.mnuOutfit.visible = param1 == MODE_LOOKS && Character.has(Pixton.POOL_PRESET_OUTFIT,Character(this.currentTarget).skinType) && (this.zoomMode != ZOOM_FACE || Main.isCharCreate());
               }
            }
         }
         else if(this.currentTarget is Dialog)
         {
            _loc6_ = Dialog(this.currentTarget).canVaryStyles() && AppSettings.isAdvanced;
            if(param1 == MODE_MOVE)
            {
               this.mnuFont.enableState = (AppSettings.isAdvanced || Fonts.allowChoice) && Fonts.getNum() > 1 && !Template.isActive();
               this.mnuSize.enableState = AppSettings.isAdvanced && !Template.isActive();
               this.mnuPadding.enableState = !Dialog(this.currentTarget).isProp() && AppSettings.isAdvanced && !Template.isActive();
               this.mnuColor.enableState = false;
               this.mnuDialogLine.enableState = AppSettings.isAdvanced && !Template.isActive();
               this.mnuRegular.enableState = false;
               this.mnuBold.enableState = false;
               this.mnuItalic.enableState = false;
               this.mnuAlignL.enableState = AppSettings.isAdvanced && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_CENTER && !Template.isActive();
               this.mnuAlignC.enableState = AppSettings.isAdvanced && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_RIGHT && !Template.isActive();
               this.mnuAlignR.enableState = AppSettings.isAdvanced && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_LEFT && !Template.isActive();
               this.mnuBubble.enableState = !Dialog(this.currentTarget).isProp() && !Template.isActive();
               this.mnuSpike.enableState = !Dialog(this.currentTarget).isProp() && AppSettings.isAdvanced && !Template.isActive();
               this.mnuAuto.enableState = false;
               this.mnuManual.enableState = false;
               this.mnuLeading.enableState = AppSettings.isAdvanced && !Template.isActive();
               this.mnuFlipH.enableState = false;
               this.mnuFlipV.enableState = false;
               this.mnuToFront.enableState = (this.containerD.numChildren > 1 || Dialog(this.currentTarget).isProp()) && !Template.isActive();
               this.mnuToBack.enableState = (this.containerD.numChildren > 1 || Dialog(this.currentTarget).isProp()) && !Template.isActive();
               this.mnuDupl.enableState = !Template.isActive();
               this.mnuSound.enableState = Main.canUploadSound() && AppSettings.isAdvanced && !Dialog(this.currentTarget).hasLink() && !Template.isActive();
               this.mnuRecord.enableState = this.mnuSound.enableState;
               this.mnuLink.enableState = (!Main.isFun() || Main.isFunStudent()) && !Dialog(this.currentTarget).hasSound() && !Template.isActive();
               this.mnuVoice.enableState = this.mnuColorD.enableState && L.isEnglish() && SoundRecorder.hasSpeechToText && AppSettings.isAdvanced;
               this.mnuSilOn.enableState = false;
               this.mnuSilOff.enableState = false;
               this.mnuColor.enableState = false;
               this.mnuNotProp.enableState = false;
               this.mnuIsProp.enableState = false;
            }
            else if(param1 == MODE_EXPR)
            {
               this.mnuRegular.enableState = _loc6_ && Fonts.hasStyles() && Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getFeature(Dialog.FEATURE_STYLE) == Dialog.STYLE_ITALIC && !Template.isActive();
               this.mnuBold.enableState = _loc6_ && Fonts.hasStyles() && Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getFeature(Dialog.FEATURE_STYLE) == Dialog.STYLE_REGULAR && !Template.isActive();
               this.mnuItalic.enableState = _loc6_ && Fonts.hasStyles() && Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getFeature(Dialog.FEATURE_STYLE) == Dialog.STYLE_BOLD && !Template.isActive();
               this.mnuAlignL.enableState = AppSettings.isAdvanced && !Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_CENTER && !Template.isActive();
               this.mnuAlignC.enableState = AppSettings.isAdvanced && !Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_RIGHT && !Template.isActive();
               this.mnuAlignR.enableState = AppSettings.isAdvanced && !Dialog(this.currentTarget).hasSelection() && Dialog(this.currentTarget).getTextAlign() == Dialog.ALIGN_LEFT && !Template.isActive();
               this.mnuSound.enableState = Main.canUploadSound() && AppSettings.isAdvanced && !Dialog(this.currentTarget).hasSelection() && !Dialog(this.currentTarget).hasLink() && !Template.isActive();
               this.mnuRecord.enableState = this.mnuSound.enableState;
               this.mnuLink.enableState = !Main.isFun() && !Dialog(this.currentTarget).hasSelection() && !Dialog(this.currentTarget).hasSound() && !Template.isActive();
               this.mnuVoice.enableState = !Dialog(this.currentTarget).isProp() && !Dialog(this.currentTarget).hasSelection() && L.isEnglish() && SoundRecorder.hasSpeechToText && AppSettings.isAdvanced;
               this.mnuPose.enableState = false;
               this.mnuFace.enableState = false;
               this.mnuFlipZ.enableState = false;
               this.mnuZoomFace.enableState = false;
               this.mnuZoomBody.enableState = false;
               this.mnuFont.enableState = Dialog(this.currentTarget).hasSelection() && (AppSettings.isAdvanced || Fonts.allowChoice) && Fonts.getNum() > 1 && !Template.isActive();
               this.mnuSize.enableState = Dialog(this.currentTarget).hasSelection() && AppSettings.isAdvanced && !Template.isActive();
               this.mnuKeypad.enableState = L.showKeypad;
               this.mnuColor.enableState = Dialog(this.currentTarget).hasSelection() && AppSettings.isAdvanced && !Template.isActive();
               this.mnuPen.visible = false;
               this.mnuErase.visible = false;
               this.mnuFlipH.enableState = false;
            }
            else if(param1 == MODE_COLORS)
            {
               this.mnuTColor.enableState = true;
               this.mnuColorD.enableState = true;
               this.mnuColorDB.enableState = true;
               this.mnuRevert2.visible = false;
               this.mnuSave2.visible = false;
            }
            if(param1 != MODE_EXPR)
            {
               Dialog(this.currentTarget).resetSelection();
            }
            Dialog(this.currentTarget).stopEdit();
            Utils.removeListener(this.currentTarget,PixtonEvent.CHANGE,this.onChangeDialog);
            Utils.removeListener(this.currentTarget,PixtonEvent.STATE_CHANGE,this.onTargetStateChange);
         }
         else if(this.currentTarget is Prop)
         {
            Utils.removeListener(this.currentTarget,PixtonEvent.DOUBLE_CLICK,this.onDoubleClick);
            if(param1 == MODE_MOVE)
            {
               if(Prop(this.currentTarget).hasFill(0))
               {
                  this.mnuAlpha.enableState = Prop(this.currentTarget).isAlphable() && AppSettings.isAdvanced && !Main.isPhotoEssay();
               }
               this.mnuUnset.enableState = this.currentTarget is PropSet && PropSet(this.currentTarget).isEditable();
               this.mnuPlay.enableState = false;
               this.mnuPause.enableState = false;
            }
            else if(param1 == MODE_EXPR)
            {
               this.mnuPose.enableState = false;
               this.mnuFace.enableState = false;
               this.mnuFlipZ.enableState = false;
               this.mnuFlipH.enableState = false;
               this.mnuPen.visible = PhotoDrawing.ENABLED && this.currentTarget is PhotoDrawing;
               this.mnuErase.visible = this.mnuPen.visible;
            }
            else if(param1 == MODE_COLORS)
            {
               if(Prop(this.currentTarget).hasFill(0))
               {
                  this.mnuColor1.enableState = true;
               }
               if(!(this.currentTarget is PropSet) && Prop(this.currentTarget).hasFill(1))
               {
                  this.mnuColor2.enableState = true;
               }
               if(!(this.currentTarget is PropSet) && Prop(this.currentTarget).hasFill(2))
               {
                  this.mnuColor3.enableState = true;
               }
               if(!(this.currentTarget is PropSet) && Prop(this.currentTarget).hasFill(3))
               {
                  this.mnuColor4.enableState = true;
               }
               if(!(this.currentTarget is PropSet) && Prop(this.currentTarget).hasFill(4))
               {
                  this.mnuColor5.enableState = true;
               }
               this.mnuRevert2.visible = false;
               this.mnuSave2.visible = false;
            }
         }
         if(this.currentTarget is Character || this.currentTarget is Prop)
         {
            if(param1 == MODE_MOVE)
            {
               this.mnuToFront.enableState = this.currentTarget.parent == this.containerC && this.containerC.numChildren > 1 && !Template.isActive();
               this.mnuToBack.enableState = this.mnuToFront.enableState;
               this.mnuDupl.enableState = this.currentTarget.parent == this.containerC && !Template.isActive() && !(this.currentTarget is Character && !Character(this.currentTarget).hasID());
               this.mnuFlipV.enableState = this.currentTarget is Prop;
               if(Asset(this.currentTarget).canSilhouette())
               {
                  this.mnuSilOn.enableState = !Asset(this.currentTarget).silhouette && AppSettings.isAdvanced && !Template.isActive();
                  this.mnuSilOff.enableState = Asset(this.currentTarget).silhouette && AppSettings.isAdvanced && !Template.isActive();
                  this.mnuColor.enableState = this.mnuSilOff.enableState;
               }
               if(this.currentTarget is Character)
               {
                  this.mnuColor.enableState = (Asset(this.currentTarget).silhouette || Character(this.currentTarget).isLockedLooks() || Character(this.currentTarget).getGlowAmount() > 0) && !Template.isActive();
               }
               else
               {
                  this.mnuColor.enableState = true;
               }
               this.mnuBlurAmount.enableState = AppSettings.isAdvanced && !Template.isActive();
               this.mnuGlowAmount.enableState = this.currentTarget is Character && AppSettings.isAdvanced && !Template.isActive();
            }
         }
         this.zoomer.visible = !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
         Edit3D.setActive(false);
         if(Main.isPregenUser())
         {
            this.resizerV.visible = true;
            this.resizerH.visible = true;
         }
         else if(Main.isReadOnly() || Main.isCharCreate() || Template.isActive() || Main.isPropPreview())
         {
            this.resizerV.visible = false;
            this.resizerH.visible = false;
         }
         else if(Main.canChangeRowHeight())
         {
            this.resizerH.visible = this.resizerV.visible = TeamRole.can(TeamRole.PANELS) && !Comic.fixedWidth && !Border.locked && !this.isLocked();
         }
         else if(Border.canEdit() && !this.isLocked())
         {
            this.resizerV.visible = TeamRole.can(TeamRole.PANELS) && AppSettings.isAdvanced;
            this.resizerH.visible = this.resizerV.visible && !Comic.fixedWidth && !Border.locked;
         }
         else
         {
            this.resizerV.visible = false;
            this.resizerH.visible = TeamRole.can(TeamRole.PANELS) && !Comic.fixedWidth && !Border.locked && !this.isLocked();
         }
         switch(param1)
         {
            case MODE_MAIN:
               this.mnuAddB.enableState = !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Main.isPhotoEssay();
               this.mnuSave.enableState = !this.isLocked() && !Main.isReadOnly() && !Main.isPropPreview();
               this.mnuSaveB.enableState = !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && !Main.isPhotoEssay();
               this.mnuSet.enableState = !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && !Main.isPhotoEssay();
               this.mnuHiRes.enableState = !this.isLocked() && Main.allowHiRes() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate();
               this.mnuPanelTitle.enableState = this.mnuPanelDesc.enableState = this.mnuDescLen.enableState = !this.isLocked() && !Main.isReadOnly() && canToggleMeta();
               this.mnuNotes.enableState = Main.allowNotes() && !Main.notesHidden();
               this.mnuGradient.enableState = !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && !Main.isPhotoEssay();
               this.mnuRevert.enableState = !this.isLocked() && (!this.getSaved() || Team.isActive) && !Main.isReadOnly() && !Template.isActive();
               this.mnuColor.enableState = !Template.isActive() && !Main.isReadOnly() && !Main.isPhotoEssay();
               this.mnuTrash.enableState = (this.getHeight() > 0 || Main.isTemplatesUser()) && !(Comic.minPanels > 0 && Comic.self.numSceneKeys() <= Comic.minPanels) && !((Main.isTChart() || Main.isGrid()) && (Comic.isSingle(Template.isActive()) || Comic.isLockedPanels() && !(Comic.canAddRows() && !this.isFirstRow()))) && !(this.noImage && this.isEmptyScene()) && !this.isLocked() && !Main.isReadOnly() && TeamRole.can(TeamRole.PANELS);
               this.mnuClear.enableState = !(this.isEmptyScene() || Template.isActive()) && !this.isLocked() && !Main.isReadOnly() && TeamRole.can(TeamRole.PANELS);
               this.mnuClose.enableState = !this.noImage && !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate();
               this.mnuUnlock.enableState = this.somethingLocked() && !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive();
               this.mnuLock.enableState = !this.mnuUnlock.enableState && (TeamRole.can(TeamRole.PANELS) || TeamRole.can(TeamRole.CHARACTERS) || TeamRole.can(TeamRole.PROPS)) && !this.isLocked() && AppSettings.isAdvanced && !Main.isReadOnly() && !Main.isCharCreate() && !Template.isActive() && !Main.isPhotoEssay();
               this.mnuFlipH.enableState = !this.isLocked() && !Main.isReadOnly() && !Main.isCharCreate();
               if(this.isLocked() || Main.isReadOnly() || Template.isActive())
               {
                  this.mnuRevert.visible = false;
                  this.mnuHiRes.visible = false;
                  this.mnuPanelTitle.visible = this.mnuPanelDesc.visible = this.mnuDescLen.visible = false;
               }
               else if(!TeamRole.can(TeamRole.PANELS) && this.isEmptyScene())
               {
                  this.mnuTrash.enableState = false;
                  this.mnuClear.enableState = false;
               }
               if(Comic.isLockedPanels())
               {
                  this.mnuPanelTitle.visible = this.mnuPanelDesc.visible = this.mnuDescLen.visible = false;
               }
               break;
            case MODE_MOVE:
               this.mnuLock2.enableState = this.currentTarget is Asset && AppSettings.isAdvanced && !Template.isActive() && !Main.isPhotoEssay();
               this.mnuRand.enableState = Dialog.RANDOM_PHRASES && this.currentTarget is Dialog && !Template.isActive();
               this.mnuPose.enableState = this.currentTarget is Character && Template.isActive();
               this.mnuFace.enableState = this.mnuPose.enableState;
               this.mnuSwapC.enableState = Template.isActive() && this.currentTarget is Character && Character(this.currentTarget).hasID();
               if(Template.isActive())
               {
                  if(this.currentTarget is Character)
                  {
                     this.mnuColor.enableState = true;
                  }
                  else
                  {
                     this.mnuTrash.visible = false;
                     this.mnuClear.visible = false;
                  }
               }
               break;
            case MODE_EXPR:
               this.mnuRand.enableState = Dialog.RANDOM_PHRASES && this.currentTarget is Dialog && !Template.isActive();
               break;
            case MODE_BORDER:
               this.mnuSaturation.visible = true;
               this.mnuBrightness.visible = true;
               this.mnuContrast.visible = true;
               this.mnuLineAlpha.visible = Debug.ACTIVE;
               this.mnuBShape.enableState = Border.canEdit();
               this.mnuBSize.enableState = Border.canEdit();
               this.mnuColorB.enableState = Border.canEdit();
               this.mnuFreestyle.enableState = Main.canSwitchToFreestyle() && !Border.canEdit() && !Comic.isFreestyle() && Globals.isFullVersion();
               this.mnuToBack2.enableState = Border.canEdit() && Comic.self.index > 0;
               this.mnuToFront2.enableState = Border.canEdit() && Comic.self.index < Comic.self.numSceneKeys() - 1;
               if(this.mnuToBack2.enableState)
               {
                  this.mnuToBack2.icon.txt.text = Comic.self.index - 1 + 1;
               }
               if(this.mnuToFront2.enableState)
               {
                  this.mnuToFront2.icon.txt.text = Comic.self.index + 1 + 1;
               }
               this.zoomer.visible = false;
               this.resizerH.visible = !Comic.fixedWidth && !Border.locked;
         }
         this.mnuUndo.enableState = this.undoStack != null && this.currentState > 0 && !this.isLocked();
         this.mnuRedo.enableState = this.undoStack != null && this.currentState < this.undoStack.length - 1 && !this.isLocked();
         this.mnuUndo.visible = this.mnuUndo.enableState || this.mnuRedo.enableState;
         this.mnuZoomFace.enableState = this.currentTarget is Character && (param1 == MODE_EXPR || param1 == MODE_LOOKS || param1 == MODE_SCALE || param1 == MODE_COLORS) && !this.isLocked();
         this.mnuZoomBody.enableState = this.mnuZoomFace.visible;
         if(this.isLocked() || Main.isReadOnly() || Main.isCharCreate())
         {
            this.mnuUndo.visible = false;
            this.mnuRedo.visible = false;
         }
         var _loc3_:Array = COLOR[param1];
         var _loc4_:Array = COLOR_OVER[param1];
         var _loc5_:Number = 0;
         for each(_loc2_ in this.menu[param1])
         {
            if(_loc2_.visible)
            {
               if(_loc2_ == this.mnuSave)
               {
                  MenuItem(_loc2_).setColor(Palette.GREEN,Palette.GREEN_OVER);
               }
               else if(_loc2_ == this.mnuTrash || _loc2_ == this.mnuDelete)
               {
                  MenuItem(_loc2_).setColor(Palette.RED,Palette.RED_OVER);
               }
               else if(Utils.inArray(_loc2_,this.mainMenuItems))
               {
                  MenuItem(_loc2_).setColor(COLOR[0],COLOR_OVER[0]);
               }
               else
               {
                  MenuItem(_loc2_).setColor(_loc3_,_loc4_);
               }
               if(!_loc2_.enableState)
               {
               }
               if(!Utils.inArray(_loc2_,this.excludeMenuItems))
               {
                  _loc5_++;
               }
            }
         }
         switch(param1)
         {
            case MODE_MAIN:
               this.rotateNE.setColor(_loc3_);
               this.resizerH.setColor(_loc3_);
               this.resizerV.setColor(_loc3_);
               this.mnuBorder.setColor(_loc3_,_loc4_);
               if(this.currentTarget is Character)
               {
                  Character(this.currentTarget).setMode(MODE_MOVE);
                  this.activateTarget(this.currentTarget as MovieClip);
               }
               else if(this.currentTarget is Prop)
               {
                  Prop(this.currentTarget).setMode(MODE_MOVE);
               }
               this.showModeMenu(false);
               this.zoomOut();
               break;
            case MODE_MOVE:
               this.rotateNE.setColor(_loc3_);
               this.resizerH.setColor(_loc3_);
               this.resizerV.setColor(_loc3_);
               this.mnuBorder.setColor(_loc3_,_loc4_);
               this.selector.setColor(_loc3_);
               this.namer.setColor(_loc3_);
               this.showModeMenu(true);
               if(this.currentTarget is Dialog)
               {
                  Utils.addListener(this.currentTarget,PixtonEvent.CHANGE,this.onChangeDialog);
               }
               else if(this.currentTarget is Character)
               {
                  Character(this.currentTarget).setMode(param1);
                  this.activateTarget(this.currentTarget as MovieClip);
               }
               else if(this.currentTarget is Prop)
               {
                  Prop(this.currentTarget).setMode(param1);
               }
               this.zoomOut();
               break;
            case MODE_EXPR:
            case MODE_LOOKS:
            case MODE_SCALE:
            case MODE_COLORS:
               this.rotateNE.setColor(_loc3_);
               this.resizerH.setColor(_loc3_);
               this.resizerV.setColor(_loc3_);
               this.mnuBorder.setColor(_loc3_,_loc4_);
               this.selector.setColor(_loc3_);
               this.namer.setColor(_loc3_);
               this.showModeMenu(this.currentTarget is Character || param1 == MODE_EXPR && (this.currentTarget is Dialog || this.currentTarget is PhotoDrawing) || param1 == MODE_EXPR && this.currentTarget is Prop && AppSettings.isAdvanced && Prop(this.currentTarget).hasMovables() || param1 == MODE_COLORS && (this.currentTarget is Dialog || this.currentTarget is Prop));
               if(this.currentTarget is Character)
               {
                  Character(this.currentTarget).setMode(param1);
                  this.deactivateTarget(this.currentTarget as MovieClip);
                  if(param1 == MODE_EXPR)
                  {
                     Utils.addListener(this.currentTarget,PixtonEvent.CHANGE_CHARACTER,this.onChangeCharacter);
                     Utils.addListener(this.currentTarget,PixtonEvent.DOUBLE_CLICK,this.onDoubleClick);
                  }
                  else
                  {
                     Utils.addListener(this.currentTarget,PixtonEvent.EDIT_CHARACTER,this.onEditCharacter);
                  }
                  Utils.addListener(this.currentTarget,PixtonEvent.STATE_CHANGE,this.onTargetStateChange);
                  Utils.addListener(this.selector,PixtonEvent.STATE_CHANGE,this.onSelectorStateChange);
               }
               else if(param1 == MODE_EXPR && this.currentTarget is Dialog)
               {
                  Dialog(this.currentTarget).startEdit();
                  Utils.addListener(this.currentTarget,PixtonEvent.CHANGE,this.onChangeDialog);
                  Utils.addListener(this.currentTarget,PixtonEvent.STATE_CHANGE,this.onTargetStateChange);
               }
               else if(param1 == MODE_EXPR && this.currentTarget is Prop)
               {
                  Prop(this.currentTarget).setMode(param1);
                  Utils.addListener(this.currentTarget,PixtonEvent.STATE_CHANGE,this.onTargetStateChange);
                  Utils.addListener(this.currentTarget,PixtonEvent.DOUBLE_CLICK,this.onDoubleClick);
               }
               break;
            case MODE_BORDER:
               this.rotateNE.setColor(_loc3_);
               this.resizerH.setColor(_loc3_);
               this.resizerV.setColor(_loc3_);
               this.mnuBorder.setColor(_loc3_,_loc4_);
               this.selector.setColor(_loc3_);
               this.namer.setColor(_loc3_);
               this.cornerNE.setColor(_loc3_);
               this.cornerSE.setColor(_loc3_);
               this.cornerSW.setColor(_loc3_);
               this.cornerNW.setColor(_loc3_);
               this.zoomOut();
         }
         Utils.setColor(this.border.top.fill,_loc3_);
         Utils.setColor(this.border.right.fill,_loc3_);
         Utils.setColor(this.border.bottom.fill,_loc3_);
         Utils.setColor(this.border.left.fill,_loc3_);
         this.zoomer.setColor(_loc3_);
         this.slider.setColor(_loc3_);
         if(!TeamRole.can(TeamRole.CHARACTERS))
         {
            disableMenuItem(this.mnuAddC);
         }
         if(!TeamRole.can(TeamRole.PROPS))
         {
            disableMenuItem(this.mnuAddP);
            disableMenuItem(this.mnuAddB);
            disableMenuItem(this.mnuAddPh);
            disableMenuItem(this.mnuDraw);
            disableMenuItem(this.mnuSaveB);
            disableMenuItem(this.mnuSet);
         }
         if(!TeamRole.can(TeamRole.PANELS))
         {
            disableMenuItem(this.mnuTrash);
            disableMenuItem(this.mnuClear);
            disableMenuItem(this.mnuColor);
            disableMenuItem(this.mnuFlipH);
            disableMenuItem(this.mnuGradient);
            this.btnPan.visible = false;
            this.zoomer.visible = false;
         }
         if(!TeamRole.can(TeamRole.DIALOG))
         {
            disableMenuItem(this.mnuAddD);
         }
         if(!TeamRole.can(TeamRole.PANELS) && !TeamRole.can(TeamRole.CHARACTERS) && !TeamRole.can(TeamRole.PROPS) && !TeamRole.can(TeamRole.DIALOG))
         {
            disableMenuItem(this.mnuSave);
            disableMenuItem(this.mnuRevert);
            disableMenuItem(this.mnuLock);
         }
         if(this.mnuMore.visible)
         {
            for each(_loc2_ in this.menuExtra)
            {
               if(_loc2_.visible)
               {
                  _loc2_.visible = false;
               }
            }
         }
         for each(_loc2_ in this.allButtons)
         {
            if(!EditorConfig.has(_loc2_.name))
            {
               _loc2_.visible = false;
            }
         }
         if(Template.isActive())
         {
            this.mnuAddD.visible = false;
            this.mnuAddP.visible = param1 == MODE_MAIN && Prop.hasFeaturedProps;
            this.mnuAddPh.visible = false;
            if(param1 != MODE_MOVE)
            {
               this.mnuColor.visible = false;
            }
            this.mnuColor1.visible = false;
            if(this.mnuFlipH.visible && !(param1 == MODE_MOVE && (this.currentTarget is Character || this.currentTarget is Prop)))
            {
               this.mnuFlipH.visible = false;
            }
            this.mnuFlipV.visible = false;
            this.mnuUnset.visible = false;
         }
         else if(Main.isCharCreate())
         {
            this.mnuAddC.visible = false;
            this.mnuAddD.visible = false;
            this.mnuAddP.visible = false;
            this.mnuAddB.visible = false;
            this.mnuAddPh.visible = false;
            this.mnuColor.visible = false;
            this.mnuTrash.visible = false;
            this.mnuClear.visible = false;
            this.mnuDelete.visible = false;
            this.mnuFlipH.visible = false;
            this.mnuSave.visible = false;
            this.mnuClose.visible = false;
            this.mnuRevert.visible = false;
            this.mnuBlurAmount.visible = false;
            this.mnuDupl.visible = false;
            this.mnuGlowAmount.visible = false;
            this.mnuSilOn.visible = false;
            this.mnuLock.visible = false;
            this.mnuLock2.visible = false;
            this.mnuZoomFace.visible = false;
            this.mnuZoomBody.visible = false;
            this.mnuRand.visible = false;
            this.mnuRevert2.visible = false;
            this.mnuSave2.visible = false;
            this.mnuOutfit.visible = false;
         }
         this.btnEditLarge.visible = AppSettings.getActive(AppSettings.ZOOM) && !Template.isActive() && !Main.isPoster();
         if(this.getHeight() == 0)
         {
            this.mnuAddC.visible = false;
            this.mnuAddD.visible = false;
            this.mnuAddP.visible = false;
            this.mnuAddB.visible = false;
            this.mnuAddPh.visible = false;
            this.mnuColor.visible = false;
            this.mnuGradient.visible = false;
            this.mnuClear.visible = false;
            this.mnuFlipH.visible = false;
            this.mnuSaveB.visible = false;
            this.mnuSet.visible = false;
            this.mnuLock.visible = false;
            this.mnuBShape.visible = false;
            this.mnuBSize.visible = false;
            this.mnuColorB.visible = false;
            this.mnuSaturation.visible = false;
            this.mnuBrightness.visible = false;
            this.mnuContrast.visible = false;
            this.mnuLineAlpha.visible = false;
            this.rotateNE.visible = false;
            this.cornerNE.visible = this.cornerSE.visible = this.cornerSW.visible = this.cornerNW.visible = false;
            this.resizerH.visible = false;
            this.zoomer.visible = this.btnPan.visible = false;
            this.btnEditLarge.visible = false;
            this.mnuUndo.visible = this.mnuRedo.visible = false;
         }
         if(Comic.isLockedPanels())
         {
            this.rotateNE.visible = false;
            this.cornerNE.visible = this.cornerSE.visible = this.cornerSW.visible = this.cornerNW.visible = false;
            this.resizerH.visible = this.resizerV.visible = false;
            this.mnuBShape.visible = false;
            this.mnuBSize.visible = false;
            this.mnuColorB.visible = false;
            this.mnuLineAlpha.visible = false;
            this.mnuToFront2.visible = this.mnuToBack2.visible = false;
         }
         this.activeMenu = param1;
         this.updateMenuPosition();
         Animation.update(this.currentTarget == null ? this : this.currentTarget,param1,false);
         this.redraw();
         Main.resizeStage();
      }
      
      function cancelPropSet(param1:PropSet) : void
      {
         this.explodePropSet(param1);
      }
      
      public function refreshMenu() : void
      {
         this.mode = this.mode;
      }
      
      public function updateEditLarge() : void
      {
         this.btnEditLarge.icon.iconPlus.visible = this.scaleX == 1;
         this.btnEditLarge.icon.iconMinus.visible = !this.btnEditLarge.icon.iconPlus.visible;
         this.btnEditLarge.scaleX = 1 / this.scaleX;
         this.btnEditLarge.scaleY = this.btnEditLarge.scaleX;
         this.btnEditLarge.x = this.getWidth();
         this.btnEditLarge.y = 0;
      }
      
      function onLoadTeamRoles() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:DisplayObject = null;
         if(!Team.isActive && L.multiLangID <= 0 && !TeamRole.hasRoles())
         {
            return;
         }
         var _loc2_:uint = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_);
            if(_loc3_ is Character && !TeamRole.can(TeamRole.CHARACTERS) || _loc3_ is Dialog && !TeamRole.can(TeamRole.DIALOG) || _loc3_ is Prop && !TeamRole.can(TeamRole.PROPS))
            {
               Moveable(_loc3_).disallow();
            }
            else
            {
               Moveable(_loc3_).allow();
               if(_loc3_ is Prop)
               {
                  if(!Prop.permitted(Prop(_loc3_).id,Prop.getType(_loc3_)))
                  {
                     this.containerC.removeChild(_loc3_);
                     _loc1_--;
                     _loc2_--;
                  }
               }
            }
            _loc1_++;
         }
         _loc2_ = this.containerD.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerD.getChildAt(_loc1_);
            if(_loc3_ is Dialog && !TeamRole.can(TeamRole.DIALOG))
            {
               Moveable(_loc3_).disallow();
            }
            else
            {
               Moveable(_loc3_).allow();
            }
            _loc1_++;
         }
         this.refreshMenu();
      }
      
      public function get mode() : uint
      {
         return this.activeMenu;
      }
      
      private function showModeMenu(param1:Boolean) : void
      {
         var _loc3_:* = false;
         var _loc4_:MenuItem = null;
         if(Main.isReadOnly())
         {
            return;
         }
         var _loc2_:Number = -BORDER_THICKNESS;
         for each(_loc4_ in this.modeMenu)
         {
            if(Template.isActive())
            {
               _loc3_ = false;
            }
            else if(this.currentTarget is Array)
            {
               _loc3_ = false;
            }
            else if(Main.isReadOnly() || Main.isCharCreate())
            {
               _loc3_ = false;
            }
            else if(!param1)
            {
               _loc3_ = false;
            }
            else if(_loc4_ == this.mnuTEdit && (this.currentTarget is Character || this.currentTarget is Prop))
            {
               _loc3_ = false;
            }
            else if(_loc4_ == this.mnuPEdit)
            {
               _loc3_ = false;
            }
            else if(_loc4_ == this.mnuDEdit)
            {
               _loc3_ = this.currentTarget is PhotoDrawing;
            }
            else if(this.currentTarget is PhotoDrawing && _loc4_ != this.mnuMove)
            {
               _loc3_ = false;
            }
            else if(this.currentTarget is Dialog && _loc4_ != this.mnuMove && _loc4_ != this.mnuTEdit && _loc4_ != this.mnuColors)
            {
               _loc3_ = false;
            }
            else if(this.currentTarget is Prop && _loc4_ != this.mnuMove && _loc4_ != this.mnuPEdit && _loc4_ != this.mnuDEdit && _loc4_ != this.mnuColors)
            {
               _loc3_ = false;
            }
            else if(_loc4_ == this.mnuExpr && this.currentTarget is Character && !Character(this.currentTarget).bodyParts.hasExpressions())
            {
               _loc3_ = false;
            }
            else if(this.currentTarget is Character && (_loc4_ == this.mnuLooks || _loc4_ == this.mnuScale))
            {
               _loc3_ = Boolean(!Character(this.currentTarget).isLockedLooks() && AppSettings.isAdvanced && !Comic.presetCharsOnly);
            }
            else if(_loc4_ == this.mnuColors)
            {
               if(this.currentTarget is Character)
               {
                  _loc3_ = !Character(this.currentTarget).isLockedLooks();
               }
               else if(this.currentTarget is Prop)
               {
                  _loc3_ = Boolean(!(this.currentTarget is PropSet) && !(this.currentTarget is PropPhoto));
               }
               else
               {
                  _loc3_ = true;
               }
            }
            else if(_loc4_ == this.mnuMove)
            {
               _loc3_ = !(this.currentTarget is Prop && (this.currentTarget is PropSet || this.currentTarget is PropPhoto));
            }
            else
            {
               _loc3_ = true;
            }
            if(_loc3_)
            {
               _loc4_.y = _loc2_;
               _loc2_ += MenuItem.SIZE + MenuItem.GAP;
            }
            _loc4_.visible = _loc3_;
         }
      }
      
      private function onMenu(param1:MouseEvent) : void
      {
         var success:Boolean = false;
         var p:Point = null;
         var d:Dialog = null;
         var keypadP:Point = null;
         var fillType:uint = 0;
         var evt:MouseEvent = param1;
         if(this.isPanning())
         {
            this.togglePanning();
         }
         this.hideHelp();
         this.mouseIsDown = false;
         var isDoubleClick:Boolean = evt.currentTarget == this.prevTarget && getTimer() - this.prevClickTime < Pixton.CLICK_TIME;
         if(evt.currentTarget is MenuItem)
         {
            p = this.getMenuPosition(evt.currentTarget as MenuItem);
         }
         this.prevTarget = evt.currentTarget;
         this.prevClickTime = getTimer();
         switch(evt.currentTarget)
         {
            case this.mnuAddC:
               if(Template.isActive() && this.getNumChars() >= Template.MAX_NUM_CHARS)
               {
                  Confirm.alert(L.text("beginner-chars",L.text("editor-basic")));
               }
               else
               {
                  this.pickCharacter(Character.lastPool);
               }
               break;
            case this.mnuSwapC:
               this.pickCharacter(Character.lastPool);
               break;
            case this.mnuAddD:
               d = this.addDialog();
               d.setData();
               d.redraw();
               this.setSelection(d,MODE_EXPR);
               break;
            case this.mnuAddP:
               this.pickProp(Globals.PROPS,Prop.lastPool,PropPack.lastPoolValue);
               break;
            case this.mnuAddPh:
               this.pickProp(Globals.PHOTOS);
               break;
            case this.mnuDraw:
               this.addProp(0,Prop.PROP_DRAWING);
               break;
            case this.mnuAlpha:
               this.preShowPicker();
               Picker.load(Globals.ALPHA,{
                  "x":this.mnuAlpha.x,
                  "y":this.mnuAlpha.y + 1,
                  "slider":this.slider
               },this.currentTarget as Asset,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuSaveB:
               this.newPropSet(true);
               break;
            case this.mnuHiRes:
               this.dispatchEvent(new PixtonEvent(PixtonEvent.DOWNLOAD_SCENE,null));
               break;
            case this.mnuPanelTitle:
               this._hasPanelTitle = !this._hasPanelTitle;
               this.updateTextVis();
               this.updateDimensions();
               break;
            case this.mnuPanelDesc:
               this._hasPanelDesc = !this._hasPanelDesc;
               this.updateTextVis();
               this.updateDimensions();
               break;
            case this.mnuDescLen:
               this.promptDescLen();
               break;
            case this.mnuNotes:
               this.toggleNotes();
               break;
            case this.mnuSet:
               if(this.mode == MODE_MAIN)
               {
                  success = this.newPropSet();
               }
               else
               {
                  success = this.newPropSet();
                  if(success)
                  {
                     this.mode = MODE_MOVE;
                  }
               }
               if(success)
               {
                  this.onStateChange();
               }
               break;
            case this.mnuUnset:
               if(this.currentTarget is PropSet)
               {
                  this.explodePropSet(this.currentTarget as PropSet);
               }
               this.mode = MODE_MOVE;
               this.onStateChange();
               break;
            case this.mnuAddB:
               this.pickPropSet(PropSet.BACKGROUND);
               break;
            case this.mnuBorder:
               this.mode = MODE_BORDER;
               break;
            case this.mnuBShape:
               this.preShowPicker();
               Picker.load(Globals.BORDER_SHAPE,{
                  "x":p.x - Picker.OFFSET_X,
                  "y":p.y,
                  "align":"bottom"
               },this.customBorder,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuDialogLine:
               this.preShowPicker();
               Picker.load(Globals.BUBBLE_BORDER,{
                  "x":this.mnuDialogLine.x,
                  "y":this.mnuDialogLine.y + 1,
                  "slider":this.slider
               },this.currentTarget,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuBSize:
               this.preShowPicker();
               Picker.load(Globals.BORDER_SIZE,{
                  "x":this.mnuBSize.x,
                  "y":this.mnuBSize.y + 1,
                  "slider":this.slider
               },this.customBorder,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuGradient:
               this.preShowPicker();
               Picker.load(Globals.BKGD_GRADIENT,{
                  "x":p.x - Picker.OFFSET_X,
                  "y":p.y,
                  "align":"bottom"
               },this,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuColorB:
               this.pickColor(Globals.BORDER_COLOR,this.customBorder);
               break;
            case this.mnuSaturation:
               if(FeatureTrial.can(FeatureTrial.BLUR))
               {
                  this.preShowPicker();
                  Picker.load(Globals.PANEL_SATURATION,{
                     "x":this.mnuSaturation.x,
                     "y":this.mnuSaturation.y + 1,
                     "slider":this.slider
                  },this.customBorder,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.BLUR);
               }
               break;
            case this.mnuBrightness:
               if(FeatureTrial.can(FeatureTrial.BLUR))
               {
                  this.preShowPicker();
                  Picker.load(Globals.PANEL_BRIGHTNESS,{
                     "x":this.mnuBrightness.x,
                     "y":this.mnuBrightness.y + 1,
                     "slider":this.slider
                  },this.customBorder,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.BLUR);
               }
               break;
            case this.mnuContrast:
               if(FeatureTrial.can(FeatureTrial.BLUR))
               {
                  this.preShowPicker();
                  Picker.load(Globals.PANEL_CONTRAST,{
                     "x":this.mnuContrast.x,
                     "y":this.mnuContrast.y + 1,
                     "slider":this.slider
                  },this.customBorder,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.BLUR);
               }
               break;
            case this.mnuLineAlpha:
               this.preShowPicker();
               Picker.load(Globals.LINE_ALPHA,{
                  "x":this.mnuLineAlpha.x,
                  "y":this.mnuLineAlpha.y + 1,
                  "slider":this.slider
               },this,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuColorD:
               this.preShowPicker();
               Picker.load(Globals.ASSET_COLOR,{
                  "x":p.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
                  "y":p.y
               },this.currentTarget,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuColorDB:
               this.preShowPicker();
               Picker.load(Globals.BUBBLE_BORDER_COLOR,{
                  "x":p.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
                  "y":p.y
               },this.currentTarget,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuSound:
               this.uploadSound();
               break;
            case this.mnuLink:
               Popup.show(L.text("add-link-title"),this.setLink,this.onSetLink,Dialog(this.currentTarget).getLink(),null,true,false,true);
               break;
            case this.mnuRecord:
               if(!SoundRecorder.isAvailable())
               {
                  Utils.alert(L.text("require-mic"));
               }
               else if(!SoundRecorder.wasPermitted())
               {
                  if(SoundRecorder.SHOW_INSTRUCTIONS)
                  {
                     Utils.alert(L.text("require-mic-chromebooks"));
                  }
                  else
                  {
                     Utils.alert(L.text("require-mic-p"));
                  }
               }
               else
               {
                  this.recordSound();
               }
               break;
            case this.mnuMore:
               this.menuExtraShown = true;
               this.refreshMenu();
               break;
            case this.mnuVoice:
               SoundRecorder.speechToText(this.currentTarget as Dialog);
               break;
            case this.mnuColor:
            case this.mnuColors:
            case this.mnuTColor:
            case this.mnuColor1:
            case this.mnuColor2:
            case this.mnuColor3:
            case this.mnuColor4:
            case this.mnuColor5:
               if(this.currentTarget == null)
               {
                  this.pickColor(Globals.BKGD_COLOR,this);
               }
               else if(evt.currentTarget == this.mnuTColor || evt.currentTarget == this.mnuColor && this.currentTarget is Dialog)
               {
                  this.preShowPicker();
                  Picker.load(Globals.TEXT_COLOR,{
                     "x":p.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
                     "y":p.y
                  },this.currentTarget,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else if(evt.currentTarget == this.mnuColors)
               {
                  this.mode = MODE_COLORS;
               }
               else if(Template.isActive() && evt.currentTarget == this.mnuColor && this.currentTarget is Character)
               {
                  p = this.getMenuPosition(this.mnuColor);
                  this.preShowPicker();
                  Picker.load(Globals.SKIN_COLOR,{
                     "colorRange":Palette.RANGE_SKIN,
                     "x":p.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
                     "y":p.y
                  },this.currentTarget,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else
               {
                  if(evt.currentTarget == this.mnuColor1 || evt.currentTarget == this.mnuColor || evt.currentTarget == this.mnuColors)
                  {
                     fillType = 0;
                  }
                  else if(evt.currentTarget == this.mnuColor2)
                  {
                     fillType = 1;
                  }
                  else if(evt.currentTarget == this.mnuColor3)
                  {
                     fillType = 2;
                  }
                  else if(evt.currentTarget == this.mnuColor4)
                  {
                     fillType = 3;
                  }
                  else if(evt.currentTarget == this.mnuColor5)
                  {
                     fillType = 4;
                  }
                  this.preShowPicker();
                  Picker.load(Globals.ASSET_COLOR,{
                     "x":p.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
                     "y":p.y,
                     "type":fillType
                  },this.currentTarget,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               break;
            case this.mnuLock:
               this.lockAll();
               this.onClickAway();
               break;
            case this.mnuLock2:
               Asset(this.currentTarget).lock();
               this.onClickAway();
               break;
            case this.mnuUnlock:
               this.unlockAll();
               this.mode = MODE_MAIN;
               break;
            case this.mnuSave:
               Main.self.resetSave();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_SCENE,null));
               break;
            case this.mnuRevert:
               startLock();
               Confirm.open("Pixton.comic.confirm",L.text("revert"),function(param1:Boolean):*
               {
                  endLock();
                  if(param1)
                  {
                     revert();
                  }
               });
               break;
            case this.mnuUndo:
               this.undo();
               break;
            case this.mnuRedo:
               this.redo();
               break;
            case this.mnuTrash:
               Confirm.open("Pixton.comic.confirm",L.text("confirm-delete-scene"),function(param1:Boolean):*
               {
                  if(param1)
                  {
                     self.dispatchEvent(new PixtonEvent(PixtonEvent.DELETE_SCENE,null));
                  }
               });
               break;
            case this.mnuClear:
               if(Main.controlPressed)
               {
                  this.clearAll(true);
                  this.setSaved(false);
                  this.mode = MODE_MAIN;
               }
               else
               {
                  startLock();
                  Confirm.open("Pixton.comic.confirm",L.text("clear-scene"),function(param1:Boolean):*
                  {
                     endLock();
                     if(param1)
                     {
                        clearAll(true);
                        setSaved(false);
                        mode = MODE_MAIN;
                     }
                  });
               }
               break;
            case this.mnuClose:
               this.closePanel();
               break;
            case this.mnuMove:
               this.mode = MODE_MOVE;
               break;
            case this.mnuTEdit:
            case this.mnuPEdit:
            case this.mnuDEdit:
            case this.mnuExpr:
               this.mode = MODE_EXPR;
               break;
            case this.mnuLooks:
               this.mode = MODE_LOOKS;
               break;
            case this.mnuScale:
               this.mode = MODE_SCALE;
               break;
            case this.mnuBubble:
               this.preShowPicker();
               Picker.load(Globals.BUBBLE_SHAPE,{
                  "x":p.x - Picker.OFFSET_X,
                  "y":p.y,
                  "align":"bottom"
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuSpike:
               this.preShowPicker();
               Picker.load(Globals.BUBBLE_SPIKE,{
                  "x":p.x - Picker.OFFSET_X,
                  "y":p.y,
                  "align":"bottom"
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuAuto:
               Dialog(this.currentTarget).setSizeMode(Dialog.AUTO_SIZE);
               this.refreshMenu();
               this.selector.updatePosition();
               this.namer.updatePosition();
               Dialog(this.currentTarget).redraw();
               this.onStateChange();
               break;
            case this.mnuManual:
               Dialog(this.currentTarget).setSizeMode(Dialog.MANUAL_SIZE);
               this.refreshMenu();
               this.selector.updatePosition();
               this.namer.updatePosition();
               Dialog(this.currentTarget).redraw();
               this.onStateChange();
               break;
            case this.mnuLeading:
               this.preShowPicker();
               Picker.load(Globals.LEADING,{
                  "x":this.mnuLeading.x,
                  "y":this.mnuLeading.y + 1,
                  "slider":this.slider
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuFont:
               this.preShowPicker();
               Picker.load(Globals.FONT_FACE,{
                  "x":p.x - Picker.OFFSET_X,
                  "y":p.y,
                  "align":"bottom"
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuRegular:
               Dialog(this.currentTarget).incrementStyle();
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuBold:
               Dialog(this.currentTarget).incrementStyle();
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuItalic:
               Dialog(this.currentTarget).incrementStyle();
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuKeypad:
               Dialog(this.currentTarget).rememberCaret();
               keypadP = new Point(this.mnuKeypad.x + MenuItem.SIZE + MenuItem.GAP,this.mnuKeypad.y + 1);
               keypadP = this.mnuKeypad.parent.localToGlobal(keypadP);
               Utils.javascript("Pixton.keypad.show",{
                  "x":keypadP.x - Main.getLeftX(),
                  "y":keypadP.y - Main.stageTopY
               });
               break;
            case this.mnuAlignL:
               Dialog(this.currentTarget).setTextAlign(Dialog.ALIGN_LEFT);
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuAlignC:
               Dialog(this.currentTarget).setTextAlign(Dialog.ALIGN_CENTER);
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuAlignR:
               Dialog(this.currentTarget).setTextAlign(Dialog.ALIGN_RIGHT);
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuSize:
               this.preShowPicker();
               Picker.load(Globals.FONT_SIZE,{
                  "x":this.mnuSize.x,
                  "y":this.mnuSize.y + 1,
                  "slider":this.slider
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuPadding:
               this.preShowPicker();
               Picker.load(Globals.PADDING,{
                  "x":this.mnuPadding.x,
                  "y":this.mnuPadding.y + 1,
                  "slider":this.slider
               },this.currentTarget as Dialog,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuFlipH:
               if(this.mode == MODE_MAIN)
               {
                  this.flipScene();
               }
               else
               {
                  this.flip(this.currentTarget,Globals.FLIP_X);
                  if(this.currentTarget is Asset)
                  {
                     Asset(this.currentTarget).drawTargets();
                     Asset(this.currentTarget).redraw();
                  }
               }
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuFlipV:
               this.flip(this.currentTarget,Globals.FLIP_Y);
               if(this.currentTarget is Asset)
               {
                  Asset(this.currentTarget).drawTargets();
               }
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuGlowAmount:
               this.preShowPicker();
               Picker.load(Globals.GLOW_AMOUNT,{
                  "x":this.mnuGlowAmount.x,
                  "y":this.mnuGlowAmount.y + 1,
                  "slider":this.slider
               },this.currentTarget as Asset,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuBlurAmount:
               if(FeatureTrial.can(FeatureTrial.BLUR))
               {
                  this.preShowPicker();
                  Picker.load(Globals.BLUR_AMOUNT,{
                     "x":this.mnuBlurAmount.x,
                     "y":this.mnuBlurAmount.y + 1,
                     "slider":this.slider
                  },this.currentTarget as Asset,true);
                  Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.BLUR);
               }
               break;
            case this.mnuBlurAngle:
               this.preShowPicker();
               Picker.load(Globals.BLUR_ANGLE,{
                  "x":this.mnuBlurAngle.x,
                  "y":this.mnuBlurAngle.y + 1,
                  "slider":this.slider
               },this.currentTarget as Asset,true);
               Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
               break;
            case this.mnuPlay:
               Prop(this.currentTarget).setAnimating(true);
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuPause:
               Prop(this.currentTarget).setAnimating(false);
               this.refreshMenu();
               this.onStateChange();
               break;
            case this.mnuFlipZ:
               this.flip(this.currentTarget,Globals.FLIP_Z);
               if(this.currentTarget is Asset)
               {
                  Asset(this.currentTarget).drawTargets();
                  Asset(this.currentTarget).redraw();
               }
               this.onStateChange();
               break;
            case this.mnuToFront:
               this.bringForward(this.currentTarget,isDoubleClick);
               updateZ(this.containerC);
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuToBack:
               this.sendBack(this.currentTarget,isDoubleClick);
               updateZ(this.containerC);
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuDupl:
               duplicate();
               break;
            case this.mnuToFront2:
               Comic.bringForward(isDoubleClick);
               this.onArrange();
               break;
            case this.mnuToBack2:
               Comic.sendBack(isDoubleClick);
               this.onArrange();
               break;
            case this.mnuFreestyle:
               Main.promptFreestyle();
               break;
            case this.mnuDelete:
               this.remove(this.currentTarget);
               this.currentTarget = null;
               this.onClickAway();
               this.onStateChange();
               this.mode = MODE_MAIN;
               break;
            case this.mnuZoomFace:
               this.setZoom(ZOOM_FACE);
               break;
            case this.mnuZoomBody:
               this.setZoom(ZOOM_BODY);
               break;
            case this.mnuSilOn:
               if(this.currentTarget is Asset)
               {
                  Asset(this.currentTarget).setSilhouette(true);
               }
               else
               {
                  Dialog(this.currentTarget).setSilhouette(true);
               }
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuSilOff:
               if(this.currentTarget is Asset)
               {
                  Asset(this.currentTarget).setSilhouette(false);
               }
               else
               {
                  Dialog(this.currentTarget).setSilhouette(false);
               }
               this.onStateChange();
               this.onBeginAction();
               break;
            case this.mnuIsProp:
               Dialog(this.currentTarget).setProp(true);
               Utils.transposePosition(this.currentTarget,this.containerD,this.containerC);
               this.onStateChange();
               break;
            case this.mnuNotProp:
               Dialog(this.currentTarget).setProp(false);
               Utils.transposePosition(this.currentTarget,this.containerC,this.containerD);
               this.onStateChange();
               break;
            case this.mnuPose:
               this.pickPose();
               break;
            case this.mnuSavePose:
               if(FeatureTrial.can(FeatureTrial.SAVE_POSES))
               {
                  Popup.show(L.text("name-pose"),this.onNamePose,Globals.POSES);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.SAVE_POSES);
               }
               break;
            case this.mnuSaveFace:
               if(FeatureTrial.can(FeatureTrial.SAVE_POSES))
               {
                  Popup.show(L.text("name-face"),this.onNamePose,Globals.FACES);
               }
               else
               {
                  Main.promptUpgrade(FeatureTrial.SAVE_POSES);
               }
               break;
            case this.mnuFace:
               this.pickFace();
               break;
            case this.mnuRandFace:
               this.randomizeExpression(Globals.FACES);
               break;
            case this.mnuRandPose:
               this.randomizeExpression(Globals.POSES);
               break;
            case this.mnuRand:
               if(this.currentTarget is Dialog)
               {
                  Dialog(this.currentTarget).randomPhrase();
               }
               else if(this.currentTarget is Character)
               {
                  Character(this.currentTarget).rerandomize(this.activeMenu);
                  Character(this.currentTarget).redraw(true);
                  this.updateSelector();
               }
               this.onStateChange();
               break;
            case this.mnuSave2:
               this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_CHARACTER,this.currentTarget));
               this.onClickAway();
               break;
            case this.mnuRevert2:
               Character(this.currentTarget).revert();
               break;
            case this.mnuOutfit:
               this.pickOutfit();
         }
         this.redraw();
      }
      
      private function onArrange() : void
      {
         if(!AppSettings.getActive(AppSettings.NUMBERS))
         {
            AppSettings.setActive(AppSettings.NUMBERS);
         }
         Comic.self.updateNumbers();
         this.refreshMenu();
         this.onStateChange();
      }
      
      private function recordSound() : void
      {
         SoundRecorder.show(this.saveSound,null);
      }
      
      private function uploadSound() : void
      {
         FileUpload.prompt(this.saveSound,FileUpload.MEDIA_SOUND,null);
      }
      
      private function saveSound(param1:String) : void
      {
         Dialog(this.currentTarget).setSound(param1);
         this.onChange();
      }
      
      private function explodePropSet(param1:PropSet) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = param1.explode(this);
         this.remove(param1);
         if(this.mode == MODE_MOVE)
         {
            this.currentTarget = null;
            for each(_loc2_ in _loc3_)
            {
               this.addSelection(_loc2_);
            }
         }
         updateZ(this.containerC);
      }
      
      function onSelectPhoto(param1:uint) : void
      {
         this.onPickProp(new PixtonEvent(PixtonEvent.CHANGE,param1,Prop.PROP_WEB));
      }
      
      private function newPropPhoto(param1:uint, param2:Function) : void
      {
         Main.self.reloadPropPhotos(param1,param2);
      }
      
      private function newPropSet(param1:Boolean = false) : Boolean
      {
         var propSet:PropSet = null;
         var props:Array = null;
         var i:uint = 0;
         var prop:Prop = null;
         var sortOnChildIndex:Function = null;
         var bkgdProps:Object = null;
         var saveAsBkgd:Boolean = param1;
         if(!FeatureTrial.can(FeatureTrial.PROP_GROUPING))
         {
            Main.promptUpgrade(FeatureTrial.PROP_GROUPING);
            return false;
         }
         propSet = new PropSet();
         if(this.mode == MODE_MOVE && this.currentTarget is Array)
         {
            props = this.currentTarget as Array;
            sortOnChildIndex = function(param1:MovieClip, param2:MovieClip):Number
            {
               if(param1.parent.getChildIndex(param1) > param2.parent.getChildIndex(param2))
               {
                  return 1;
               }
               return -1;
            };
            props.sort(sortOnChildIndex);
            if(!this.cleanseSelection())
            {
               if(this.currentTarget is Array && this.currentTarget.length == 0)
               {
                  this.onClickAway();
               }
               return false;
            }
         }
         else
         {
            bkgdProps = this.getBkgdProps(saveAsBkgd);
            props = bkgdProps.props;
            if(props.length == 0)
            {
               if(bkgdProps.numIgnored > 0)
               {
                  Confirm.alert(L.text("no-bkgd-set-n",bkgdProps.numIgnored),false);
               }
               else
               {
                  Confirm.alert("no-bkgd-set");
               }
               return false;
            }
            if(props.length == 1 && props[0] is PropSet && PropSet(props[0]).isBkgd())
            {
               Confirm.alert("already-bkgd",true);
               return false;
            }
            propSet.bkgdColor = this.getColor();
            propSet.bkgdGradient = this.getGradient();
         }
         var ni:uint = props.length;
         i = 0;
         while(i < ni)
         {
            prop = props[i] as Prop;
            if(prop is PropSet && !PropSet(prop).isEditable())
            {
               props.splice(i--,1);
               ni--;
            }
            i++;
         }
         if(props.length == 0)
         {
            Confirm.alert("locked-sets");
            return false;
         }
         if(!saveAsBkgd)
         {
            propSet.bkgdColor = 0;
         }
         this.deactivateTarget(props);
         propSet.addProps(props,this.customBorder);
         updateZ(this.containerC);
         if(saveAsBkgd)
         {
            propSet.setBorderData(this.customBorder.getBorderData(propSet));
         }
         if(this.mode == MODE_MOVE)
         {
            this.setSelection(propSet);
         }
         this._disableTeamStateUpdate = true;
         propSet.promptForName(function(param1:Boolean):void
         {
            onPropSetNamed(param1,props,propSet);
         });
         return true;
      }
      
      private function bleeds(param1:DisplayObject) : Boolean
      {
         var _loc2_:Rectangle = param1.getBounds(stage);
         var _loc3_:Rectangle = !!this.customBorder.visible ? this.customBorder.getBounds(stage) : this.border.getBounds(stage);
         return _loc2_.left < _loc3_.left || _loc2_.top < _loc3_.top || _loc2_.bottom > _loc3_.bottom || _loc2_.right > _loc3_.right;
      }
      
      private function getBkgdProps(param1:Boolean = true) : Object
      {
         var _loc6_:uint = 0;
         var _loc8_:DisplayObject = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc7_:uint = this.containerC.numChildren;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if((_loc8_ = this.containerC.getChildAt(_loc6_)) is Character)
            {
               _loc4_.push(_loc8_);
            }
            else if(_loc8_ is Prop && Prop(_loc8_).isLocked() || _loc8_ is Dialog && Dialog(_loc8_).isLocked())
            {
               _loc5_.push(_loc8_);
            }
            else if(this.isOverlapping(_loc8_,_loc4_))
            {
               _loc3_.push(_loc8_);
               _loc4_.push(_loc8_);
            }
            else
            {
               _loc2_.push(_loc8_);
            }
            _loc6_++;
         }
         if(!param1 && _loc3_.length > 0)
         {
            return {
               "props":_loc3_,
               "numIgnored":0
            };
         }
         return {
            "props":_loc2_,
            "numIgnored":_loc3_.length
         };
      }
      
      private function rearrange(param1:DisplayObject, param2:Boolean, param3:int) : void
      {
         var _loc4_:DisplayObject;
         if((_loc4_ = Utils.getOverlapping(param1 as MovieClip,param3)) != null)
         {
            Utils.rearrange(param1,param2,param3,_loc4_);
         }
         else
         {
            Utils.rearrange(param1,true,param3);
         }
      }
      
      private function sendBack(param1:Object, param2:Boolean = false) : void
      {
         if(!(param1 is DisplayObject))
         {
            return;
         }
         this.rearrange(param1 as DisplayObject,param2,-1);
      }
      
      private function bringForward(param1:Object, param2:Boolean = false) : void
      {
         if(!(param1 is DisplayObject))
         {
            return;
         }
         this.rearrange(param1 as DisplayObject,param2,1);
      }
      
      private function isOverlapping(param1:DisplayObject, param2:Array) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc4_:uint = param2.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param2[_loc3_];
            if(Collision.isColliding(_loc5_,param1,this.containerC,true))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function onPropSetNamed(param1:Boolean, param2:Array, param3:PropSet) : void
      {
         if(!param1)
         {
            this.explodePropSet(param3);
            param3 = null;
            this.onPropSetSaved();
            return;
         }
         this.activateTarget(param3);
         this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_PROPSET,param3));
         this.onStateChange();
      }
      
      function onPropSetSaved() : void
      {
         this._disableTeamStateUpdate = false;
         this.onStateChange();
      }
      
      private function onNamePose(param1:String, param2:uint) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:Pose = new Pose();
         _loc3_.setTarget(this.currentTarget);
         _loc3_.setName(param1);
         _loc3_.setMode(param2);
         _loc3_.setPoseData(Character(this.currentTarget).getPoseData(param2));
         Main.savePose(_loc3_);
      }
      
      private function pickFX(param1:uint, param2:*, param3:int, param4:int, param5:MenuItem) : void
      {
         if(Picker.isVisible() && Picker.type == Globals.EFFECTS)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(Globals.EFFECTS,{
            "id":param1,
            "target":param2,
            "min":param3,
            "max":param4,
            "fx":this.fx,
            "x":param5.x,
            "y":param5.y + 1,
            "slider":this.slider
         },this.currentTarget,true);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
      }
      
      private function preShowPicker() : void
      {
         startLock();
      }
      
      private function hidePicker(param1:MouseEvent = null) : void
      {
         if(Main.isPixton() && Main.controlPressed)
         {
            return;
         }
         endLock();
         Picker.hide();
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
         if(param1 != null)
         {
            this.onStateChange();
         }
      }
      
      function positionNew(param1:MovieClip, param2:uint = 0) : void
      {
         var p:Point = null;
         var r:Rectangle = null;
         var numChars:uint = 0;
         var xOffset:int = 0;
         var yOffset:int = 0;
         var mcToCenter:MovieClip = null;
         var headBounds:Rectangle = null;
         var headX:Number = NaN;
         var headY:Number = NaN;
         var speechlessCharacter:Asset = null;
         var mc:DisplayObject = null;
         var i:uint = 0;
         var ni:uint = 0;
         var unattachedDialog:Dialog = null;
         var target:MovieClip = param1;
         var propType:uint = param2;
         if(target is Prop)
         {
            p = target.parent.globalToLocal(this.crosshairs.parent.localToGlobal(new Point(this.crosshairs.x,this.crosshairs.y)));
            target.x = p.x;
            target.y = p.y;
            if(Main.isPropRender())
            {
               Utils.fit(target,this.border,Utils.NO_SCALE,false,null,AUTO_RENDER_PADDING);
               r = target.getBounds(target.parent);
               target.x -= r.x + r.width * 0.5;
               target.y -= r.y + r.height * 0.5;
            }
            else if(!Platform._get("anon"))
            {
               if(target is PropSet && PropSet(target).isBkgd())
               {
                  PropSet(target).setOnReady(function():void
                  {
                     autoFitBkgd(target as PropSet);
                  });
               }
               else if(target is PropSet)
               {
                  PropSet(target).setOnReady(function():void
                  {
                     autoFitProp(target as Prop);
                  });
               }
               else
               {
                  this.autoFitProp(target as Prop);
               }
            }
         }
         else if(target is Character)
         {
            numChars = this.getNumChars();
            xOffset = 0;
            yOffset = 0;
            if(this.scale <= DEFAULT_SCALE_2 * 1.1)
            {
               if(numChars == 1)
               {
                  xOffset = -75;
               }
               else if(numChars == 2)
               {
                  xOffset = 75;
               }
               yOffset = 140;
            }
            else
            {
               yOffset = 0;
            }
            Character(target).bodyParts.render();
            p = target.parent.globalToLocal(this.crosshairs.parent.localToGlobal(new Point(this.crosshairs.x + xOffset,this.crosshairs.y + yOffset)));
            target.x = p.x;
            target.y = p.y;
            if(yOffset == 0)
            {
               mcToCenter = Character(target).getHead();
               if(mcToCenter == null || this.scale <= DEFAULT_SCALE_1)
               {
                  mcToCenter = MovieClip(target);
               }
               if(mcToCenter != null)
               {
                  headBounds = mcToCenter.getBounds(target.parent);
                  headX = (headBounds.topLeft.x + headBounds.bottomRight.x) * 0.5;
                  headY = (headBounds.topLeft.y + headBounds.bottomRight.y) * 0.5;
                  target.x += p.x - headX;
                  target.y += p.y - headY;
               }
            }
         }
         else
         {
            p = target.parent.globalToLocal(this.crosshairs.parent.localToGlobal(new Point(this.crosshairs.x,this.crosshairs.y - 135)));
            target.x = p.x;
            target.y = p.y;
         }
         if(target is Dialog && !Dialog(target).isProp())
         {
            speechlessCharacter = this.getSoloCharacter() as Asset;
            if(speechlessCharacter != null)
            {
               Dialog(target).target = speechlessCharacter;
               p = target.parent.globalToLocal(speechlessCharacter.parent.localToGlobal(new Point(speechlessCharacter.x,speechlessCharacter.y)));
               target.x = p.x;
            }
         }
         else if(target is Character)
         {
            unattachedDialog = this.getSoloDialog();
            if(unattachedDialog != null)
            {
               unattachedDialog.target = target as Asset;
            }
         }
      }
      
      private function autoFitProp(param1:Prop) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc2_ = param1.getBounds(this.bkgd);
         _loc3_ = Math.max(_loc2_.height / this.getHeight(),_loc2_.width / this.getWidth()) * (!!Main.isPropPreview() ? 5 : 1);
         _loc4_ = 10;
         if(_loc3_ > AUTO_SCALE_THRESHOLD)
         {
            param1.size = 1 / _loc3_;
         }
         else if(_loc2_.width > 0 && _loc2_.width < _loc4_ && _loc2_.height > 0 && _loc2_.height < _loc4_)
         {
            if(_loc2_.width > _loc2_.height)
            {
               param1.size = _loc4_ / _loc2_.height;
            }
            else
            {
               param1.size = _loc4_ / _loc2_.width;
            }
         }
      }
      
      public function autoFitBkgd(param1:PropSet = null) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:DisplayObject = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         if(param1 == null)
         {
            _loc11_ = this.containerC.numChildren;
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               if((_loc9_ = this.containerC.getChildAt(_loc10_)) is PropSet && PropSet(_loc9_).isBkgd())
               {
                  param1 = PropSet(_loc9_);
                  break;
               }
               _loc10_++;
            }
         }
         if(param1 == null || param1.width == 0 || param1.parent == null)
         {
            return;
         }
         _loc2_ = PropSet(param1).getSelectableRect(param1.parent);
         _loc3_ = this.border.getBounds(param1.parent);
         _loc4_ = _loc2_.width / _loc2_.height;
         _loc5_ = _loc3_.width / _loc3_.height;
         if(_loc4_ > _loc5_)
         {
            PropSet(param1).size = _loc3_.height / _loc2_.height;
         }
         else
         {
            PropSet(param1).size = _loc3_.width / _loc2_.width;
         }
         _loc6_ = param1.parent.globalToLocal(this.crosshairs.parent.localToGlobal(new Point(this.crosshairs.x,this.crosshairs.y)));
         _loc7_ = _loc2_.x + _loc2_.width * 0.5;
         _loc8_ = _loc2_.y + _loc2_.height * 0.5;
         param1.x = _loc6_.x - (_loc7_ - _loc6_.x) * PropSet(param1).size;
         param1.y = _loc6_.y - (_loc8_ - _loc6_.y) * PropSet(param1).size;
      }
      
      public function autoFitScene() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = this.getWidth() / Comic.STANDARD_WIDTH;
         if(_loc1_ > 1)
         {
            this.changeScale(this.scale * _loc1_);
         }
      }
      
      function activateTarget(param1:MovieClip) : void
      {
         if(Main.isReadOnly())
         {
            return;
         }
         if(param1 is Moveable && Moveable(param1).activated)
         {
            return;
         }
         Utils.useHand(param1);
         Utils.addListener(param1,MouseEvent.MOUSE_DOWN,this.onPressTarget,true);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onReleaseTarget,true);
         Utils.addListener(param1,MouseEvent.ROLL_OVER,this.showHelp,true);
         Utils.addListener(param1,MouseEvent.ROLL_OUT,this.hideHelp,true);
         if(param1 is Moveable)
         {
            Moveable(param1).activated = true;
         }
      }
      
      private function deactivateTarget(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         if(param1 is Array)
         {
            _loc2_ = param1 as Array;
         }
         else
         {
            _loc2_ = [param1];
         }
         for each(_loc3_ in _loc2_)
         {
            if(!(_loc3_ is Moveable && !Moveable(_loc3_).activated))
            {
               _loc3_.buttonMode = false;
               _loc3_.useHandCursor = false;
               Utils.removeListener(_loc3_,MouseEvent.MOUSE_DOWN,this.onPressTarget);
               Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onReleaseTarget);
               Utils.removeListener(_loc3_,MouseEvent.ROLL_OVER,this.showHelp);
               Utils.removeListener(_loc3_,MouseEvent.ROLL_OUT,this.hideHelp);
               if(_loc3_ is Moveable)
               {
                  Moveable(_loc3_).activated = false;
               }
            }
         }
      }
      
      private function onPressTarget(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(param1.currentTarget != null && param1.currentTarget is Asset && Asset(param1.currentTarget).isLocked())
         {
            return;
         }
         if(this.activeMenu == MODE_MOVE && Main.shiftPressed)
         {
            if(this.currentTarget is Array && Utils.inArray(param1.currentTarget,this.currentTarget as Array) || param1.currentTarget == this.currentTarget)
            {
               this.removeSelection(param1.currentTarget);
            }
            else
            {
               this.addSelection(param1.currentTarget);
            }
         }
         else
         {
            if(this.currentTarget != null && !(this.currentTarget is Array && Utils.inArray(param1.currentTarget,this.currentTarget as Array)) && param1.currentTarget != this.currentTarget)
            {
               this.onClickAway();
               if(!Template.isActive())
               {
                  return;
               }
            }
            _loc2_ = getTimer();
            if(this.mode == MODE_MOVE && !isNaN(this.clickTime) && _loc2_ - this.clickTime < Pixton.CLICK_TIME)
            {
               if(param1.currentTarget is Character)
               {
                  if(this.mnuExpr.visible)
                  {
                     this.mode = MODE_EXPR;
                     Character(param1.currentTarget).drillUp(param1);
                  }
               }
               else if(param1.currentTarget is Dialog || param1.currentTarget is Prop && Prop(param1.currentTarget).hasMovables())
               {
                  this.mode = MODE_EXPR;
               }
            }
            else
            {
               if(this.mode == MODE_MAIN)
               {
                  this.clickTime = getTimer();
                  this.setSelection(param1.currentTarget);
               }
               if(this.mode == MODE_MAIN || this.mode == MODE_MOVE)
               {
                  this.selector.startMove(param1);
               }
            }
         }
         this.clickTime = _loc2_;
         this.mouseIsDown = true;
         this.hideHelp();
      }
      
      private function onReleaseTarget(param1:MouseEvent) : void
      {
         this.mouseIsDown = false;
      }
      
      private function onStageMouseDown(param1:MouseEvent) : void
      {
         if(!Utils.mcContains(param1.target,AppSettings.self) && AppSettings.isVisible())
         {
            AppSettings.toggleShown();
            return;
         }
         if(!visible || !param1.buttonDown || !Main.enableState)
         {
            return;
         }
         if(param1.target == stage || param1.target == this)
         {
            if(this.isLocked() && param1.target == stage && this.mode == MODE_MAIN && this.currentTarget == null && !Picker.isVisible() && !this.noImage)
            {
               this.closePanel();
            }
            else
            {
               this.onClickAway();
            }
         }
      }
      
      private function closePanel(param1:Boolean = true) : void
      {
         var action:Function = null;
         var isExplicit:Boolean = param1;
         action = function(param1:Boolean):*
         {
            endLock();
            if(param1)
            {
               Comic.self.resetPanelSizes();
               self.dispatchEvent(new PixtonEvent(PixtonEvent.CLOSE_SCENE,null));
            }
         };
         if(!TeamRole.approved || this.getSaved())
         {
            action(true);
         }
         else if(isExplicit)
         {
            startLock();
            Confirm.open("Pixton.comic.confirm",L.text("close-scene"),action);
         }
      }
      
      public function getFullRect() : Rectangle
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         _loc1_ = this.mnuBorder.getRect(this);
         _fullYMin = _loc1_.y;
         _loc2_ = new Point(_fullXMin,_fullYMin);
         _loc2_ = this.localToGlobal(_loc2_);
         _loc2_ = Main.self.globalToLocal(_loc2_);
         _loc3_ = _fullXMax;
         if(Picker.isVisible())
         {
            _loc1_ = Picker.getRect(this);
            _loc3_ = Math.max(_loc3_,_loc1_.x + _loc1_.width + PADDING * 2);
         }
         return new Rectangle(_loc2_.x - PADDING,_loc2_.y - PADDING,_loc3_ - _fullXMin + PADDING * 2,_fullYMax - _fullYMin + PADDING * 2);
      }
      
      private function onDownKey(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         if(Main.allowFullCapture() && Main.shiftPressed && Main.controlPressed && param1.keyCode == 83)
         {
            Main.self.resetSave();
            this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_SCENE,null,true));
            return;
         }
         if(Main.allowNotes() && Main.notesHidden() && Main.shiftPressed && Main.controlPressed && param1.keyCode == 79)
         {
            this.toggleNotes();
            return;
         }
         _loc2_ = String.fromCharCode(param1.charCode);
         if(Main.controlPressed)
         {
            if(_loc2_ == "z")
            {
               this.undo();
            }
            else if(_loc2_ == "Z")
            {
               this.redo();
            }
         }
         if(!stage.mouseChildren || Team.titleHasFocus() || this.panelTitle.hasFocus() || this.panelDesc.hasFocus() || this.panelNotes.hasFocus() || Picker.hasFocus() || this.namer.inputText.hasFocus() || Popup.hasFocus() || this.currentTarget is Dialog && Dialog(this.currentTarget).hasFocus())
         {
            return;
         }
         if(Main.controlPressed)
         {
            switch(param1.keyCode)
            {
               case Keyboard.LEFT:
                  this.nudgeRotation(-0.5);
                  break;
               case Keyboard.RIGHT:
                  this.nudgeRotation(0.5);
                  break;
               case Keyboard.UP:
                  this.nudgeZoom(-1);
                  break;
               case Keyboard.DOWN:
                  this.nudgeZoom(1);
                  break;
               default:
                  switch(_loc2_)
                  {
                     case "c":
                        if(this.mode == MODE_MAIN)
                        {
                           PixtonMenu.onCopyScene();
                        }
                        break;
                     case "x":
                        if(this.mode == MODE_MAIN)
                        {
                           PixtonMenu.onCopyScene();
                           this.clearAll();
                           this.onStateChange();
                        }
                        break;
                     case "v":
                        if(this.mode == MODE_MAIN)
                        {
                           PixtonMenu.onPasteScene();
                        }
                  }
            }
         }
         else
         {
            _loc3_ = !!Main.shiftPressed ? Number(MAJOR_SHIFT) : Number(MINOR_SHIFT);
            switch(param1.keyCode)
            {
               case Keyboard.UP:
                  if(this.mode == MODE_MOVE)
                  {
                     this.selector.nudge(0,-_loc3_,true);
                  }
                  else if(this.mode == MODE_MAIN)
                  {
                     this.nudge(0,-_loc3_);
                  }
                  break;
               case Keyboard.DOWN:
                  if(this.mode == MODE_MOVE)
                  {
                     this.selector.nudge(0,_loc3_,true);
                  }
                  else if(this.mode == MODE_MAIN)
                  {
                     this.nudge(0,_loc3_);
                  }
                  break;
               case Keyboard.LEFT:
                  if(this.mode == MODE_MOVE)
                  {
                     this.selector.nudge(-_loc3_,0,true);
                  }
                  else if(this.mode == MODE_MAIN)
                  {
                     this.nudge(-_loc3_,0);
                  }
                  break;
               case Keyboard.RIGHT:
                  if(this.mode == MODE_MOVE)
                  {
                     this.selector.nudge(_loc3_,0,true);
                  }
                  else if(this.mode == MODE_MAIN)
                  {
                     this.nudge(_loc3_,0);
                  }
                  break;
               case Keyboard.ESCAPE:
                  this.onClickAway();
                  break;
               case 8:
               case Keyboard.DELETE:
                  MenuItem.triggerShortcut("DEL");
                  break;
               case Keyboard.F1:
                  MenuItem.triggerShortcut("F1");
                  break;
               case Keyboard.F2:
                  MenuItem.triggerShortcut("F2");
                  break;
               case Keyboard.F3:
                  MenuItem.triggerShortcut("F3");
                  break;
               case Keyboard.F4:
                  MenuItem.triggerShortcut("F4");
                  break;
               case Keyboard.F5:
                  MenuItem.triggerShortcut("F5");
                  break;
               case Keyboard.HOME:
                  MenuItem.triggerShortcut("HOME");
                  break;
               case Keyboard.PAGE_UP:
                  MenuItem.triggerShortcut("PG -");
                  break;
               case Keyboard.PAGE_DOWN:
                  MenuItem.triggerShortcut("PG +");
                  break;
               case Keyboard.END:
                  MenuItem.triggerShortcut("END");
                  break;
               case Keyboard.SPACE:
                  this.startPanning();
                  break;
               case Keyboard.ENTER:
                  MenuItem.triggerShortcut("ENTER");
                  break;
               default:
                  if(AppSettings.getActive(AppSettings.SHORTCUTS))
                  {
                     MenuItem.triggerShortcut(String.fromCharCode(param1.keyCode));
                  }
            }
         }
      }
      
      private function onUpKey(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.SPACE:
               this.stopPanning();
         }
      }
      
      private function selectionIncludesProps() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.currentTarget is Array)
         {
            _loc2_ = this.currentTarget.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.currentTarget[_loc1_] is Prop)
               {
                  return true;
               }
               _loc1_++;
            }
            return false;
         }
         return this.currentTarget is Prop;
      }
      
      private function cleanseSelection() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.currentTarget is Array)
         {
            _loc2_ = this.currentTarget.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(!(this.currentTarget[_loc1_] is Prop))
               {
                  Utils.setColor(this.currentTarget[_loc1_]);
                  this.currentTarget.splice(_loc1_--,1);
                  _loc2_--;
               }
               _loc1_++;
            }
         }
         else
         {
            this.currentTarget = [this.currentTarget];
         }
         return this.currentTarget.length > 1;
      }
      
      private function removeSelection(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.currentTarget is Array)
         {
            _loc3_ = this.currentTarget.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.currentTarget[_loc2_] == param1)
               {
                  this.currentTarget.splice(_loc2_,1);
                  if(this.currentTarget.length == 1)
                  {
                     this.currentTarget = this.currentTarget[0];
                  }
                  break;
               }
               _loc2_++;
            }
         }
         else
         {
            this.onClickAway();
         }
         this.setSelection(this.currentTarget);
      }
      
      private function addSelection(param1:Object) : void
      {
         if(this.currentTarget == null)
         {
            this.currentTarget = [];
         }
         if(this.currentTarget is Array)
         {
            this.currentTarget.push(param1);
         }
         else
         {
            this.currentTarget = [this.currentTarget,param1];
         }
         this.setSelection(this.currentTarget);
      }
      
      public function setSelection(param1:Object = null, param2:int = -1, param3:Boolean = true) : void
      {
         if(param1 != this.currentTarget)
         {
            if(param1 && Guide.isBlockingSelection(param1))
            {
               return;
            }
            if(this.currentTarget is Dialog)
            {
               Dialog(this.currentTarget).onBlur();
               this.onStateChange(null,false,false);
            }
            else if(param1 == null && this.currentTarget is Character)
            {
               Character(this.currentTarget).setMode(MODE_MAIN,true);
               this.activateTarget(this.currentTarget as MovieClip);
               param2 = MODE_MAIN;
            }
            if(stage.focus is TextField)
            {
               stage.focus = null;
            }
         }
         this.currentTarget = param1;
         if(this.currentTarget == null)
         {
            this.selector.setTarget();
            if(param2 > -1)
            {
               this.mode = MODE_MAIN;
            }
            Guide.onDeselection();
         }
         else
         {
            this.selector.setTarget(param1);
            if(param2 > -1)
            {
               this.mode = param2;
            }
            else if(this.mode == MODE_MAIN || this.currentTarget is Array)
            {
               this.mode = MODE_MOVE;
            }
            Guide.onSelection();
         }
         if(this.currentTarget is Character)
         {
            this.namer.setTarget(this.mode,param1);
         }
         else
         {
            this.namer.setTarget(this.mode);
         }
         Animation.update(param1 == null ? this : param1,this.mode,param3);
      }
      
      public function updateSelector() : void
      {
         if(this.currentTarget == null || !this.selector.visible)
         {
            return;
         }
         this.namer.renamable = Utils.inArray(this.activeMenu,[MODE_LOOKS,MODE_COLORS,MODE_SCALE]) && !Platform._get("anon");
         this.selector.updateState(this.activeMenu,this.currentTarget);
         if(this.selector.playable)
         {
            Utils.addListener(this.selector,PixtonEvent.DETACH_SOUND,this.onSoundRemoved);
         }
         else
         {
            Utils.removeListener(this.selector,PixtonEvent.DETACH_SOUND,this.onSoundRemoved);
         }
         this.selector.updatePosition();
      }
      
      private function onSoundRemoved(param1:PixtonEvent) : void
      {
         Dialog(param1.value).setSound(null);
         this.updateSelector();
      }
      
      public function drawOnion(param1:Array = null, param2:Object = null) : void
      {
         var _loc3_:Graphics = null;
         var _loc4_:Array = null;
         var _loc5_:MovieClip = null;
         _loc3_ = this.containerC.graphics;
         _loc3_.clear();
         if(param1 == null)
         {
            return;
         }
         if((_loc4_ = param1[this.mode - 2]) == null)
         {
            return;
         }
         _loc3_.lineStyle(1,Palette.RGBtoHex(COLOR[this.mode]),0.5);
         if(this.currentTarget is Asset || this.currentTarget is Dialog && Dialog(this.currentTarget).isProp())
         {
            _loc5_ = this.containerC;
         }
         else
         {
            _loc5_ = this.containerD;
         }
         if(this.currentTarget is Character)
         {
            if(param2 == null)
            {
               param2 = _loc4_[1].p;
            }
            Utils.drawArrow(_loc5_,_loc4_[0].p.x,_loc4_[0].p.y,param2.x,param2.y);
            if(_loc4_[2].p.x != _loc4_[0].p.x && _loc4_[2].p.y != _loc4_[0].p.y)
            {
               Utils.drawArrow(_loc5_,param2.x,param2.y,_loc4_[2].p.x,_loc4_[2].p.y);
            }
         }
         else
         {
            if(param2 == null)
            {
               param2 = _loc4_[1];
            }
            Utils.drawArrow(_loc5_,_loc4_[0].x,_loc4_[0].y,param2.x,param2.y);
            if(_loc4_[2].x != _loc4_[0].x && _loc4_[2].y != _loc4_[0].y)
            {
               Utils.drawArrow(_loc5_,param2.x,param2.y,_loc4_[2].x,_loc4_[2].y);
            }
         }
      }
      
      public function get scale() : Number
      {
         return this.containerC.scaleX;
      }
      
      public function set scale(param1:Number) : void
      {
         this.containerC.scaleX = param1;
         this.containerC.scaleY = param1;
      }
      
      public function set borderHighlight(param1:Boolean) : void
      {
         if(param1)
         {
            Utils.setColor(this.border.top.fill,COLOR[HIGHLIGHT]);
            Utils.setColor(this.border.right.fill,COLOR[HIGHLIGHT]);
            Utils.setColor(this.border.bottom.fill,COLOR[HIGHLIGHT]);
            Utils.setColor(this.border.left.fill,COLOR[HIGHLIGHT]);
         }
         else
         {
            this.refreshMenu();
         }
      }
      
      private function onRotateStateChange(param1:PixtonEvent = null) : void
      {
         this.updateBMCache();
         this.onStateChange(param1);
      }
      
      private function onZoomerStateChange(param1:PixtonEvent = null) : void
      {
         this.updateBMCache();
         this.onStateChange(param1);
      }
      
      private function updateBMCache(param1:Boolean = true) : void
      {
      }
      
      private function onSelectorStateChange(param1:PixtonEvent = null) : void
      {
         this.onStateChange(param1);
      }
      
      private function onTargetStateChange(param1:PixtonEvent = null) : void
      {
         this.onStateChange(param1,false);
      }
      
      public function onStateChange(param1:PixtonEvent = null, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:Object = null;
         Utils.monitorMemory();
         if(this.redoing || this.undoing || this.undoStack == null || this.loading && this.currentState > -1)
         {
            return;
         }
         this.allSaved();
         if(param1 != null && param1.value == this.zoomer && this.zoomMode != ZOOM_NONE)
         {
            return;
         }
         if(this.currentState < this.undoStack.length - 1)
         {
            this.undoStack.splice(this.currentState + 1);
         }
         if(this.undoStack.length == undoLevels)
         {
            this.undoStack.shift();
            --this.currentState;
         }
         _loc4_ = self.getData(true);
         this.undoStack.push(_loc4_);
         ++this.currentState;
         if(!this.loading && param3 && (param1 == null || param1.value != this.animation))
         {
            Animation.autoSave(this.currentTarget == null ? this : this.currentTarget,this.mode);
         }
         if(param1 != null && Utils.inArray(param1.value,[this.cornerNE,this.cornerSE,this.cornerSW,this.cornerNW]))
         {
            this.adjustDimensions();
            this.onBorderChange();
         }
         AppState.save(_loc4_);
         this.onPreview();
         this.onChange(param2);
         Guide.onStateChange();
      }
      
      public function onChange(param1:Boolean = true) : void
      {
         if(this.loading)
         {
            return;
         }
         this.destroySnapshot();
         this.setSaved(false);
         if(param1)
         {
            this.refreshMenu();
         }
      }
      
      private function onTargetMoved(param1:PixtonEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:MovieClip = null;
         var _loc5_:Dialog = null;
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:DisplayObject = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Point = null;
         _loc2_ = param1.value2 == "attaching";
         _loc3_ = param1.value2 == "attached";
         if(param1.value is Dialog && !Dialog(param1.value).isProp())
         {
            _loc4_ = Dialog(param1.value).target;
            _loc5_ = param1.value as Dialog;
            if(!_loc2_ && !_loc3_)
            {
               _loc5_.redraw();
            }
            if(_loc3_)
            {
               _loc6_ = false;
               if(Dialog(param1.value).target == null)
               {
                  _loc6_ = true;
                  _loc8_ = this.containerC.numChildren;
                  _loc10_ = -1;
                  _loc11_ = int.MAX_VALUE;
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     if((_loc9_ = this.containerC.getChildAt(_loc7_)) is Asset)
                     {
                        _loc13_ = Asset(_loc9_).getAttachPos();
                        if((_loc12_ = Utils.distance(this.selector.attach,_loc13_)) < _loc11_)
                        {
                           _loc11_ = _loc12_;
                           _loc10_ = _loc7_;
                        }
                     }
                     _loc7_++;
                  }
                  if(_loc10_ != -1)
                  {
                     Dialog(param1.value).target = this.containerC.getChildAt(_loc10_) as Asset;
                  }
               }
               if(!_loc6_ || Dialog(param1.value).target is Photo)
               {
                  Dialog(param1.value).setOffset(param1.value3 as Point);
               }
               Dialog(param1.value).drawBubble();
               Guide.onAttach();
            }
            else if(!_loc2_)
            {
               _loc5_.drawBubble();
            }
            Dialog(param1.value).checkBounds(this.getWidth(),this.getHeight());
            if(param1.value2 === true || param1.value2 == "detached")
            {
               this.refreshMenu();
               if(param1.value2 == "detached")
               {
                  Guide.onDetach();
               }
            }
            this.selector.updatePosition();
            if(_loc3_)
            {
               this.onStateChange();
            }
         }
         else if(param1.value is Asset)
         {
            Asset(param1.value).drawTargets();
         }
         else if(param1.value is Array)
         {
         }
         this.redraw();
      }
      
      private function flipScene() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         this.setXY(-this.xPos,this.yPos);
         this.setRotation(-this.sceneRotation);
         _loc2_ = this.containerD.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerD.getChildAt(_loc1_);
            _loc3_.x = this.getWidth() - _loc3_.x;
            _loc3_.rotation = -_loc3_.rotation;
            _loc1_++;
         }
         _loc2_ = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_);
            _loc3_.x = -_loc3_.x;
            _loc3_.rotation = -_loc3_.rotation;
            if(!(_loc3_ is Dialog))
            {
               this.flip(_loc3_,Globals.FLIP_X,true);
               if(_loc3_ is Character)
               {
                  Character(_loc3_).onRender(null,true);
               }
            }
            _loc1_++;
         }
         this.redraw(true);
      }
      
      private function onTargetZMoved(param1:PixtonEvent) : void
      {
         Edit3D.update();
      }
      
      public function setZoom(param1:uint, param2:Boolean = true) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         this.destroySnapshot();
         if(param1 == this.zoomMode && param2)
         {
            this.zoomOut();
            this.refreshMenu();
            return;
         }
         if(this.zoomMode == ZOOM_NONE)
         {
            this.scaleData = {
               "x":this.xPos,
               "y":this.yPos,
               "scale":this.scale
            };
         }
         this.zoomMode = param1;
         this.selector.zoomed = this.zoomMode != ZOOM_NONE;
         if(this.currentTarget is Character)
         {
            if(this.zoomMode == ZOOM_BODY)
            {
               _loc5_ = 1;
               _loc3_ = this.currentTarget.getBounds(this);
            }
            else if(this.zoomMode == ZOOM_FACE)
            {
               _loc5_ = !!Main.isCharCreate() ? Number(0.65) : Number(0.8);
               _loc3_ = Utils.getUnionRect(Character(this.currentTarget).getHeadParts(),this);
            }
            _loc6_ = this.scale;
            _loc7_ = Math.min(this.getWidth() / _loc3_.width,this.getHeight() / _loc3_.height) * _loc5_;
            this.scale *= _loc7_;
            if(this.zoomMode == ZOOM_BODY)
            {
               _loc4_ = this.currentTarget.getBounds(this.crosshairs);
            }
            else
            {
               _loc4_ = Utils.getUnionRect(Character(this.currentTarget).getHeadParts(),this.crosshairs);
            }
            _loc8_ = -(_loc4_.x + _loc4_.width * 0.5);
            _loc9_ = -(_loc4_.y + _loc4_.height * 0.5);
            if(Main.isCharCreate() && Character.editingSkinType != Globals.HUMAN)
            {
               _loc9_ -= _loc4_.height * 0.5 - this.getHeight() * 0.5 + 30;
            }
            _loc10_ = Utils.d2r(this.contentsC.rotation);
            _loc11_ = Math.sin(_loc10_);
            _loc12_ = Math.cos(_loc10_);
            _loc13_ = this.xPos + _loc8_ * _loc12_ + _loc9_ * _loc11_;
            _loc14_ = this.yPos - _loc8_ * _loc11_ + _loc9_ * _loc12_;
            this.scale = _loc6_;
            if(ZOOM_ANIMATED || Main.isCharCreate())
            {
               this.cancelTween();
               this.tweens = [Utils.tween(this,"xPos",_loc13_,NaN,ZOOM_DURATION),Utils.tween(this,"yPos",_loc14_,NaN,ZOOM_DURATION),Utils.tween(this,"scale",this.scale * _loc7_,NaN,ZOOM_DURATION),Utils.tween(this.zoomer,"alpha",0,NaN,ZOOM_DURATION),Utils.tween(this.containerD,"alpha",0,NaN,ZOOM_DURATION)];
            }
            else
            {
               this.xPos = _loc13_;
               this.yPos = _loc14_;
               this.scale *= _loc7_;
               this.zoomer.alpha = 0;
               this.zoomer.mouseEnabled = false;
               this.zoomer.mouseChildren = false;
               this.resizerH.alpha = 0;
               this.resizerH.mouseEnabled = false;
               this.resizerH.mouseChildren = false;
               this.resizerV.alpha = 0;
               this.resizerV.mouseEnabled = false;
               this.resizerV.mouseChildren = false;
               this.containerD.alpha = 0;
               this.containerD.mouseEnabled = false;
               this.containerD.mouseChildren = false;
            }
            this.selector.visible = false;
         }
         if(!Main.isCharCreate())
         {
            this.refreshMenu();
         }
      }
      
      public function zoomOut() : void
      {
         if(Main.isCharCreate() && Character.editingSkinType != Globals.HUMAN)
         {
            return;
         }
         if(this.zoomMode == ZOOM_NONE)
         {
            return;
         }
         this.zoomMode = ZOOM_NONE;
         this.selector.zoomed = false;
         if(ZOOM_ANIMATED)
         {
            this.cancelTween();
            this.tweens = [Utils.tween(this,"xPos",this.scaleData.x,NaN,ZOOM_DURATION),Utils.tween(this,"yPos",this.scaleData.y,NaN,ZOOM_DURATION),Utils.tween(this,"scale",this.scaleData.scale,NaN,ZOOM_DURATION),Utils.tween(this.zoomer,"alpha",1,NaN,ZOOM_DURATION),Utils.tween(this.containerD,"alpha",1,this.containerD.alpha,ZOOM_DURATION,this.onZoomOut)];
         }
         else
         {
            this.xPos = this.scaleData.x;
            this.yPos = this.scaleData.y;
            this.scale = this.scaleData.scale;
            this.zoomer.alpha = 1;
            this.zoomer.mouseEnabled = true;
            this.zoomer.mouseChildren = true;
            this.resizerH.alpha = 1;
            this.resizerH.mouseEnabled = true;
            this.resizerH.mouseChildren = true;
            this.resizerV.alpha = 1;
            this.resizerV.mouseEnabled = true;
            this.resizerV.mouseChildren = true;
            this.containerD.alpha = 1;
            this.containerD.mouseEnabled = true;
            this.containerD.mouseChildren = true;
            this.onZoomOut();
         }
         if(this.startPoint != null)
         {
            this.stopMove();
         }
      }
      
      private function onZoomOut(param1:TweenEvent = null) : void
      {
         if(this.selector.target != null && !Main.isCharCreate())
         {
            this.selector.visible = true;
         }
         this.redraw();
         this.createSnapshot();
      }
      
      private function cancelTween() : void
      {
         var _loc1_:PixtonTween = null;
         if(this.tweens == null)
         {
            return;
         }
         for each(_loc1_ in this.tweens)
         {
            _loc1_.stop();
         }
      }
      
      public function allSaved() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.unsaved = [];
         _loc2_ = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_) as MovieClip;
            if(_loc3_ is Character)
            {
               if(!Character(_loc3_).getSaved())
               {
                  this.unsaved.push(_loc3_);
               }
            }
            else if(_loc3_ is PropSet)
            {
               if(!PropSet(_loc3_).saved)
               {
                  this.unsaved.push(_loc3_);
               }
            }
            _loc1_++;
         }
         if(this.unsaved.length == 0)
         {
            endLock();
            return true;
         }
         startLock();
         return false;
      }
      
      public function saveAll() : void
      {
         startLock(true,true);
         if(this.unsaved[0] is Character)
         {
            this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_CHARACTER,this.unsaved[0]));
         }
         else
         {
            this.dispatchEvent(new PixtonEvent(PixtonEvent.SAVE_PROPSET,this.unsaved[0]));
         }
      }
      
      private function loadCharacters(param1:Array, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:Array = null;
         var _loc8_:Character = null;
         var _loc9_:Object = null;
         _loc4_ = this.containerC.numChildren;
         _loc7_ = [];
         _loc5_ = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc6_ = this.containerC.getChildAt(_loc5_)) is Character)
            {
               _loc7_.push(_loc6_);
               this.containerC.removeChild(_loc6_);
            }
            else
            {
               _loc5_++;
            }
            _loc3_++;
         }
         for each(_loc9_ in param1)
         {
            if((_loc8_ = reuseCharacter(_loc7_,_loc9_)) != null)
            {
               _loc8_.showAll();
               this.onAddCharacter(_loc8_);
            }
            else
            {
               _loc8_ = this.addCharacter(_loc9_.id,_loc9_.skinType,false,false);
            }
            _loc8_.setData(_loc9_);
            _loc8_.redraw(true);
            if(this.getSaved() && _loc8_.newerThan(param2))
            {
               this.setSaved(false);
            }
            this.zOrder.push(_loc8_);
            if(_loc9_.zon != null && _loc9_.zon == 0)
            {
               this.zOrderLegacy[_loc9_.zo] = _loc8_;
               _loc8_.size = _loc9_.z;
            }
         }
      }
      
      function getObject(param1:Class, param2:int = -1, param3:int = -1, param4:Boolean = false) : Object
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:MovieClip = null;
         switch(param1)
         {
            case Character:
            case Prop:
               _loc5_ = _loc6_ = (_loc8_ = this.containerC).numChildren;
               while(_loc5_ > 0)
               {
                  if((_loc7_ = _loc8_.getChildAt(_loc5_ - 1)) is param1 && (param2 == -1 || param1 == Character && Character(_loc7_).skinType == param2))
                  {
                     if(param3 > 0)
                     {
                        return Character(_loc7_).bodyParts.getPartByID(param3);
                     }
                     return _loc7_;
                  }
                  _loc5_--;
               }
               break;
            case Dialog:
               _loc5_ = _loc6_ = (_loc8_ = this.containerD).numChildren;
               while(_loc5_ > 0)
               {
                  if((_loc7_ = _loc8_.getChildAt(_loc5_ - 1)) is param1)
                  {
                     return _loc7_;
                  }
                  _loc5_--;
               }
         }
         return null;
      }
      
      public function getTarget(param1:int) : Asset
      {
         var _loc2_:DisplayObject = null;
         if(param1 == -1 || param1 >= this.containerC.numChildren)
         {
            return null;
         }
         _loc2_ = this.containerC.getChildAt(param1);
         if(_loc2_ is Asset)
         {
            return _loc2_ as Asset;
         }
         return null;
      }
      
      function clearAll(param1:Boolean = false) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:DisplayObject = null;
         this.clearAssets(param1);
         _loc3_ = this.containerD.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.containerD.getChildAt(0);
            this.deactivateTarget(_loc4_ as MovieClip);
            Animation.onRemoveTarget(_loc4_);
            this.containerD.removeChild(_loc4_);
            _loc2_++;
         }
         if(Main.isPropRender())
         {
            this.scale = 1;
            this.zoomer.updateValue(this.zoomer.calculateValue(this.scale));
            this.xPos = 0;
            this.yPos = 0;
         }
         else if(param1 && this.containerC.numChildren == 0)
         {
            this.scale = DEFAULT_SCALE_1;
            this.zoomer.updateValue(this.zoomer.calculateValue(this.scale));
            this.xPos = -57;
            this.yPos = 445.75;
         }
         this.onStateChange();
      }
      
      private function isEmptyScene() : Boolean
      {
         return this.containerC.numChildren == 0 && this.containerD.numChildren == 0;
      }
      
      public function updateSpeaking(param1:Character, param2:Boolean) : void
      {
         if(!param1.isSpeaking(param2))
         {
            param1.speak(param2);
         }
      }
      
      private function getSoloCharacter() : Character
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         var _loc6_:Character = null;
         _loc2_ = this.containerC.numChildren;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if((_loc4_ = this.containerC.getChildAt(_loc1_)) is Character)
            {
               if((_loc5_ = this.getSpeechDialogs(_loc4_ as Character)).length == 0)
               {
                  if(_loc6_ != null)
                  {
                     return null;
                  }
                  _loc6_ = _loc4_ as Character;
               }
            }
            _loc1_++;
         }
         return _loc6_;
      }
      
      private function getSoloDialog() : Dialog
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         var _loc6_:Dialog = null;
         _loc2_ = this.containerD.numChildren;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.containerD.getChildAt(_loc1_);
            if(Dialog(_loc4_).target == null)
            {
               if(_loc6_ != null)
               {
                  return null;
               }
               _loc6_ = _loc4_ as Dialog;
            }
            _loc1_++;
         }
         return _loc6_;
      }
      
      private function addCharacter(param1:int = 0, param2:uint = 0, param3:Boolean = false, param4:Boolean = true) : Character
      {
         var _loc5_:Boolean = false;
         var _loc6_:Character = null;
         _loc5_ = param3 && (Platform.exists() || this.scale < DEFAULT_SCALE_1);
         _loc6_ = new Character(param1,param2,false,param3,_loc5_);
         return this.onAddCharacter(_loc6_,param3,param4);
      }
      
      private function onAddCharacter(param1:Character, param2:Boolean = false, param3:Boolean = false) : Character
      {
         this.containerC.addChild(param1);
         param1.promptedForOverwrite = false;
         if(param3)
         {
            this.positionNew(param1 as MovieClip);
         }
         this.activateTarget(param1 as MovieClip);
         this.onStateChange();
         if(!param2)
         {
         }
         return param1;
      }
      
      private function addDialog() : Dialog
      {
         var _loc1_:Dialog = null;
         _loc1_ = Dialog.add(this);
         this.onStateChange();
         return _loc1_;
      }
      
      public function addProp(param1:uint, param2:uint = 0, param3:Boolean = true, param4:Boolean = false) : Prop
      {
         var _loc5_:Prop = null;
         if((_loc5_ = Prop.add(this,param1,param2,param4)) == null)
         {
            return null;
         }
         _loc5_.updateInners();
         if(param2 == Prop.PROP_PRESET || !FeatureTrial.can(FeatureTrial.PROP_GROUPING))
         {
            this.onStateChange();
         }
         if(param3)
         {
            if(param2 == Prop.PROP_DRAWING)
            {
               this.setSelection(_loc5_,MODE_EXPR);
            }
            else
            {
               this.setSelection(_loc5_,MODE_MOVE);
            }
         }
         return _loc5_;
      }
      
      public function showImageCredit(param1:Photo = null) : void
      {
         this.imageCredit.visible = Main.isPhotoEssay() && param1 && param1.source;
         if(this.imageCredit.visible)
         {
            this.imageCredit.x = 3;
            this.imageCredit.y = this.getHeight() - 3 - this.imageCredit.bkgd.height;
            this.imageCredit.bkgd.width = this.getWidth() - 3 * 2;
            this.imageCredit.txtValue.width = this.imageCredit.bkgd.width - 26;
            this.imageCredit.btnReport.x = this.imageCredit.txtValue.width;
            this.imageCredit.txtValue.text = param1.source;
            this._imageCredit = param1.source;
            this._imageID = param1.id;
         }
      }
      
      private function onImageCredit(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(this._imageCredit),"_blank");
      }
      
      private function onImageReport(param1:MouseEvent) : void
      {
         Utils.javascript("Pixton.imageSearch.flagPhoto",this._imageID,this._imageCredit);
      }
      
      private function remove(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 is Array)
         {
            for each(_loc3_ in param1)
            {
               this.remove(_loc3_);
            }
         }
         else if(!param2 && Template.isActive() && param1 is Dialog)
         {
            this.setSelection();
            Dialog(param1).text = "";
            Dialog(param1).redraw();
         }
         else
         {
            if(Template.isActive() && param1 is Character)
            {
               _loc5_ = (_loc4_ = Asset(param1).getTargetDialogs()).length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  this.remove(_loc4_[_loc6_],true);
                  _loc6_++;
               }
            }
            if(param1 is Asset)
            {
               Asset(param1).unlinkAllTargets();
               if(Main.isPhotoEssay() && param1 is Photo)
               {
                  this.showImageCredit();
               }
            }
            else if(param1 is Dialog)
            {
               Dialog(param1).target = null;
            }
            this.deactivateTarget(param1 as MovieClip);
            Animation.onRemoveTarget(param1);
            param1.parent.removeChild(param1);
         }
         if(Template.isActive() && param1 is Character)
         {
            Template.addScene(this.getCharIDs());
         }
      }
      
      private function flip(param1:Object, param2:String, param3:Boolean = false) : void
      {
         if(param1 is Character && param2 == Globals.FLIP_Z)
         {
            Character(param1).bodyParts.flipPose(param2);
         }
         else if(param1 is Character && Character(param1).skinType == Globals.HUMAN && param2 == Globals.FLIP_X)
         {
            Character(param1).bodyParts.flipPose(param2,param3);
         }
         else
         {
            param1["flip" + param2] *= -1;
         }
      }
      
      public function updateUIColor() : void
      {
         this.btnPan.updateColor();
         Utils.setColor(this.bkgd.fill,Palette.colorBkgd);
         this.panelTitle.updateColor();
         this.panelDesc.updateColor();
         this.panelNotes.updateColor();
      }
      
      private function getMenuPosition(param1:MenuItem) : Point
      {
         var _loc2_:Point = null;
         _loc2_ = new Point(param1.x,param1.y);
         _loc2_ = this.localToGlobal(_loc2_);
         _loc2_.y -= Main.self.y;
         return _loc2_;
      }
      
      private function pickColor(param1:uint, param2:Object) : void
      {
         var _loc3_:Point = null;
         if(Picker.isVisible() && Picker.type == param1)
         {
            this.onClickAway();
            return;
         }
         _loc3_ = this.getMenuPosition(this.mnuColor);
         this.preShowPicker();
         Picker.load(param1,{
            "x":_loc3_.x + MenuItem.SIZE * this.scaleX - Picker.OFFSET_X,
            "y":_loc3_.y
         },param2,true);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
      }
      
      public function setGradient(param1:uint) : void
      {
         this._gradientID = param1;
         this.updateColor(Palette.getColor(this.getColor()));
      }
      
      public function setColor(param1:*, param2:Boolean = true) : void
      {
         if(param1 is Array)
         {
            if(param2)
            {
               this.updateColor(param1);
            }
         }
         else
         {
            this._colorID = param1;
            if(param2)
            {
               this.updateColor(Palette.getColor(this.getColor()));
            }
         }
         if(param2)
         {
            this.onChange();
         }
      }
      
      public function getColor() : uint
      {
         return this._colorID;
      }
      
      public function getGradient() : uint
      {
         return this._gradientID;
      }
      
      private function updateColor(param1:Array = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Matrix = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(isNaN(this._colorID))
         {
            return;
         }
         this.mnuMove.setColor(COLOR[MODE_MOVE],COLOR_OVER[MODE_MOVE]);
         this.mnuTEdit.setColor(COLOR[MODE_EXPR],COLOR_OVER[MODE_EXPR]);
         this.mnuPEdit.setColor(COLOR[MODE_EXPR],COLOR_OVER[MODE_EXPR]);
         this.mnuDEdit.setColor(COLOR[MODE_EXPR],COLOR_OVER[MODE_EXPR]);
         this.mnuExpr.setColor(COLOR[MODE_EXPR],COLOR_OVER[MODE_EXPR]);
         this.mnuLooks.setColor(COLOR[MODE_LOOKS],COLOR_OVER[MODE_LOOKS]);
         this.mnuScale.setColor(COLOR[MODE_SCALE],COLOR_OVER[MODE_SCALE]);
         this.mnuColors.setColor(COLOR[MODE_COLORS],COLOR_OVER[MODE_COLORS]);
         this.selector.updateColor();
         if(this.getColor() == Palette.TRANSPARENT_ID && this.getGradient() != Palette.GRADIENT_NONE)
         {
            this.setGradient(Palette.GRADIENT_NONE);
         }
         if(param1 == null)
         {
            param1 = this.currentColor;
         }
         else
         {
            this.currentColor = param1;
         }
         _loc2_ = this.getGradient();
         this.containerB.graphics.clear();
         if(_loc2_ > Palette.GRADIENT_NONE)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc7_ = Palette.RGBtoHex(param1);
            if(_loc2_ == Palette.GRADIENT_LINEAR_LIGHT || _loc2_ == Palette.GRADIENT_RADIAL_LIGHT)
            {
               _loc8_ = Palette.lighten(_loc7_);
            }
            else
            {
               _loc8_ = Palette.darken(_loc7_);
            }
            if(_loc2_ == Palette.GRADIENT_LINEAR_LIGHT || _loc2_ == Palette.GRADIENT_LINEAR_DARK)
            {
               _loc10_ = GradientType.LINEAR;
               _loc5_ = this.getWidth();
               _loc6_ = this.getHeight();
            }
            else
            {
               _loc12_ = this.getWidth();
               _loc13_ = this.getHeight();
               _loc14_ = Math.atan2(_loc13_,_loc12_);
               _loc10_ = GradientType.RADIAL;
               _loc5_ = _loc12_ / Math.cos(_loc14_);
               _loc6_ = _loc13_ / Math.sin(_loc14_);
               _loc3_ = (_loc12_ - _loc5_) * 0.5;
               _loc4_ = (_loc13_ - _loc6_) * 0.5;
            }
            if(_loc2_ == Palette.GRADIENT_LINEAR_DARK || _loc2_ == Palette.GRADIENT_RADIAL_LIGHT)
            {
               _loc9_ = [_loc8_,_loc7_];
            }
            else
            {
               _loc9_ = [_loc7_,_loc8_];
            }
            (_loc11_ = new Matrix()).createGradientBox(_loc5_,_loc6_,Utils.d2r(this.sceneRotation - 90),_loc3_,_loc4_);
            this.containerB.graphics.beginGradientFill(_loc10_,_loc9_,[1,1],[0,255],_loc11_,SpreadMethod.PAD,InterpolationMethod.RGB,0);
            this.containerB.graphics.moveTo(0,0);
            this.containerB.graphics.lineTo(this.getWidth(),0);
            this.containerB.graphics.lineTo(this.getWidth(),this.getHeight());
            this.containerB.graphics.lineTo(0,this.getHeight());
            this.containerB.graphics.lineTo(0,0);
            this.containerB.graphics.endFill();
         }
         else
         {
            if(this.getColor() == Palette.TRANSPARENT_ID)
            {
               this.containerB.graphics.beginFill(16777215,0);
            }
            else
            {
               this.containerB.graphics.beginFill(Palette.RGBtoHex(param1));
            }
            this.containerB.graphics.moveTo(0,0);
            this.containerB.graphics.lineTo(this.getWidth(),0);
            this.containerB.graphics.lineTo(this.getWidth(),this.getHeight());
            this.containerB.graphics.lineTo(0,this.getHeight());
            this.containerB.graphics.lineTo(0,0);
            this.containerB.graphics.endFill();
         }
      }
      
      private function pickPropSet(param1:uint) : void
      {
         if(Picker.isVisible() && Picker.type == Globals.PROPSETS)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(Globals.PROPSETS,{
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y),
            "type":param1
         },null,true,PropSet.lastPool);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickProp);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickSet);
      }
      
      public function getNumChars() : uint
      {
         var _loc1_:Array = null;
         _loc1_ = this.getCharIDs();
         return _loc1_.length;
      }
      
      private function containsNonHumanChars() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         _loc2_ = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_);
            if(_loc3_ is Character && Character(_loc3_).skinType != Globals.HUMAN)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function getCharIDs(param1:int = -1) : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         _loc3_ = this.containerC.numChildren;
         _loc5_ = [];
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_loc4_ = this.containerC.getChildAt(_loc2_)) is Character)
            {
               _loc5_.push(Character(_loc4_).getID());
            }
            if(param1 != -1 && _loc5_.length >= param1)
            {
               break;
            }
            _loc2_++;
         }
         _loc2_ = _loc6_ = _loc5_.length;
         while(_loc2_ < param1)
         {
            _loc5_.push(0);
            _loc2_++;
         }
         return _loc5_;
      }
      
      private function clearAssets(param1:Boolean = false, param2:Boolean = false, param3:Prop = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:DisplayObject = null;
         _loc6_ = 0;
         _loc5_ = this.containerC.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = this.containerC.getChildAt(_loc6_);
            if(param2 && _loc7_ is Character && !FeatureTrial.can(FeatureTrial.PROP_GROUPING))
            {
               break;
            }
            if(_loc7_ == param3 || param1 && _loc7_ is Asset && Asset(_loc7_).isLocked() || param2 && FeatureTrial.can(FeatureTrial.PROP_GROUPING) && !(_loc7_ is PropSet && PropSet(_loc7_).isBkgd()))
            {
               _loc6_++;
            }
            else
            {
               this.deactivateTarget(_loc7_ as MovieClip);
               Animation.onRemoveTarget(_loc7_);
               this.containerC.removeChild(_loc7_);
            }
            _loc4_++;
         }
         if(this.containerC.numChildren == _loc5_ && param1)
         {
            this.clearAssets();
         }
      }
      
      private function onClosePickSet(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickProp);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickSet);
      }
      
      private function pickProp(param1:uint, param2:uint = 0, param3:uint = 0) : void
      {
         if(Picker.isVisible() && Picker.type == param1)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(param1,{
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y)
         },null,true,param2,param3);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickProp);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickProp);
      }
      
      private function onPickProp(param1:PixtonEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Prop = null;
         if(param1.value3 != null)
         {
            if(param1.value2 == Prop.PROP_PHOTO)
            {
               this.newPropPhoto(param1.value,param1.value3);
            }
            else if(param1.value == Globals.PHOTOS)
            {
               PropPhoto.hide(param1.value3);
            }
            else if(param1.value == Globals.PROPS && param1.value2 == Pixton.POOL_MINE || param1.value == Globals.PROPSETS && param1.value2 == Pixton.POOL_MINE)
            {
               PropSet.hide(param1.value3);
            }
            return;
         }
         if(param1.value == null && param1.value2 == Prop.PROP_SET)
         {
            this.newPropSet();
         }
         else
         {
            _loc2_ = false;
            if(param1.value2 == Prop.PROP_SET && param1.value4 == PropSet.BACKGROUND)
            {
               _loc3_ = PropSet.getData(param1.value);
               if(_loc3_.setting != null)
               {
                  _loc4_ = _loc3_.setting.split(".");
                  if(Template.addScene(this.getCharIDs(),_loc4_[0],_loc4_[1]))
                  {
                     _loc2_ = true;
                  }
               }
            }
            if(!_loc2_)
            {
               if(Main.isPhotoEssay())
               {
                  this.clearAll();
               }
               _loc5_ = this.addProp(param1.value,param1.value2,true,true);
               updateZ(this.containerC);
               if(_loc5_ != null && _loc5_ is PropSet && PropSet(_loc5_).isBkgd())
               {
                  if(_loc5_.parent.getChildIndex(_loc5_) == 0)
                  {
                     this.clearAssets(false,true,_loc5_);
                  }
                  this.setColor(PropSet(_loc5_).bkgdColor,false);
                  this.setGradient(PropSet(_loc5_).bkgdGradient);
               }
            }
            if(_loc5_ is PropSet)
            {
               PropSet.sendTeamUpdate(PropSet(_loc5_).id,PropSet.getData(PropSet(_loc5_).id));
            }
         }
         if(Main.isPixton() && !Main.controlPressed)
         {
            Picker.hide();
            this.onClosePickProp();
         }
         this.onStateChange();
      }
      
      private function onClosePickProp(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickProp);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickProp);
      }
      
      public function pickCharacter(param1:uint = 0) : void
      {
         var _loc2_:Object = null;
         if(Picker.isVisible() && Picker.type == Globals.CHARACTERS)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         _loc2_ = {
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y)
         };
         if(this.currentTarget is Character)
         {
            _loc2_.excludeIDs = [Character(this.currentTarget).getID()];
            _loc2_.skinType = Character(this.currentTarget).skinType;
         }
         else if(Template.isActive())
         {
            _loc2_.excludeIDs = this.getCharIDs();
         }
         Picker.load(Globals.CHARACTERS,_loc2_,null,true,param1);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickCharacter);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickCharacter);
      }
      
      public function setCharacterByNum(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:DisplayObject = null;
         var _loc4_:uint = 0;
         _loc6_ = this.containerC.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if((_loc7_ = this.containerC.getChildAt(_loc5_)) is Character)
            {
               if(_loc4_++ == param1)
               {
                  this.swapCharacter(_loc7_ as Character,param2);
                  Character(_loc7_).setOutfit(Character.getData(param3));
                  return;
               }
            }
            _loc5_++;
         }
      }
      
      private function swapCharacter(param1:Character, param2:uint) : void
      {
         param1.setID(param2);
         param1.setGenome(Character.getData(param2));
         param1.redraw(true);
      }
      
      private function onPickCharacter(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Character = null;
         var _loc4_:Object = null;
         if(this.currentTarget != null)
         {
            this.swapCharacter(this.currentTarget as Character,param1.value);
            this.updateSelector();
         }
         else
         {
            _loc2_ = -1;
            if(param1.value != null)
            {
               _loc4_ = Character.getData(param1.value);
               _loc2_ = int(_loc4_.t);
            }
            else
            {
               _loc2_ = param1.value2;
            }
            _loc3_ = this.addCharacter(param1.value,param1.value2,true);
            updateZ(this.containerC);
            _loc3_.redraw(true);
            this.updateSelector();
            if(!_loc3_.hasID())
            {
               this.onClickAway();
            }
            Character.sendTeamUpdate(_loc3_.getID(),Character.getData(_loc3_.getID()));
            if(Template.isActive())
            {
               Template.addScene(this.getCharIDs());
            }
         }
         Picker.hide();
         this.onClosePickCharacter();
      }
      
      private function onClosePickCharacter(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickCharacter);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickCharacter);
      }
      
      private function pickPose() : void
      {
         if(Picker.isVisible() && Picker.type == Globals.POSES)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(Globals.POSES,{
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y),
            "type":Globals.POSES
         },this.currentTarget as Character,true,Pose.lastPoolPose);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickPose);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickPose);
      }
      
      private function onPickPose(param1:PixtonEvent) : void
      {
         var _loc2_:Pose = null;
         _loc2_ = Pose.getPose(param1.value);
         Character(this.currentTarget).setPose(_loc2_.getPoseData(),Globals.POSES,true);
         this.updateSelector();
         this.onStateChange();
         Picker.hide();
         this.onClosePickPose();
      }
      
      private function onClosePickPose(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickPose);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickPose);
      }
      
      private function pickFace() : void
      {
         if(Picker.isVisible() && Picker.type == Globals.FACES)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(Globals.FACES,{
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y),
            "type":Globals.FACES
         },this.currentTarget as Character,true,Pose.lastPoolFace);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickFace);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickFace);
      }
      
      private function onPickFace(param1:PixtonEvent) : void
      {
         var _loc2_:Pose = null;
         _loc2_ = Pose.getPose(param1.value);
         Character(this.currentTarget).setPose(_loc2_.getPoseData(),Globals.FACES);
         this.onStateChange();
         Picker.hide();
         this.onClosePickFace();
      }
      
      private function onClosePickFace(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickFace);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickFace);
      }
      
      public function pickOutfit() : void
      {
         if(Picker.isVisible() && Picker.type == Globals.OUTFITS)
         {
            this.onClickAway();
            return;
         }
         this.preShowPicker();
         Picker.load(Globals.OUTFITS,{
            "x":Main.displayManager.GET(this,DisplayManager.P_X) - Picker.OFFSET_X,
            "y":Main.displayManager.GET(this,DisplayManager.P_Y),
            "type":Globals.OUTFITS
         },this.currentTarget as Character,true,Outfit.lastPool);
         Utils.addListener(Picker.target,PixtonEvent.CHANGE,this.onPickOutfit);
         Utils.addListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickOutfit);
      }
      
      private function onPickOutfit(param1:PixtonEvent) : void
      {
         Character(this.currentTarget).setOutfit(Character.getData(param1.value));
         this.onStateChange();
         Picker.hide();
         this.onClosePickOutfit();
         if(Main.isCharCreate())
         {
            Designer.getInstance().gotoEnd();
         }
      }
      
      private function onClosePickOutfit(param1:PixtonEvent = null) : void
      {
         Utils.removeListener(Picker.target,PixtonEvent.CHANGE,this.onPickOutfit);
         Utils.removeListener(Picker.target,PixtonEvent.CLOSE,this.onClosePickOutfit);
      }
      
      public function onRenderStart(param1:Number, param2:Asset = null) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObject = null;
         this.renderHide = [];
         _loc5_ = numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = getChildAt(_loc4_) as DisplayObject;
            if(_loc3_.visible && _loc3_ != this.contents && _loc3_ != this.customBorder)
            {
               _loc3_.visible = false;
               this.renderHide.push(_loc3_);
            }
            _loc4_++;
         }
         Utils.scaleFactor = param1;
         if(param2 != null)
         {
            this.containerD.visible = false;
         }
         _loc5_ = this.containerC.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.containerC.getChildAt(_loc4_);
            if(param2 != null && _loc6_ != param2)
            {
               _loc6_.visible = false;
            }
            if(_loc6_ is Asset)
            {
               Asset(_loc6_).setBlurAmount(Asset(_loc6_).getBlurAmount());
            }
            _loc4_++;
         }
         if(Template.isActive())
         {
            _loc5_ = this.containerD.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if((_loc6_ = this.containerD.getChildAt(_loc4_)) is Dialog)
               {
                  Dialog(_loc6_).visible = !Dialog(_loc6_).isEmpty();
               }
               _loc4_++;
            }
         }
         if(Main.isPropRender())
         {
            this.containerB.visible = false;
         }
         if(param1 > 1)
         {
            this.offsetBorder(param1);
         }
         if(Comic.isFreestyle() && this.hasDefaultBorder())
         {
            this.customBorder.visible = false;
         }
         this.customBorder.scaleX = param1;
         this.customBorder.scaleY = param1;
         this.contentMask.scaleX = param1;
         this.contentMask.scaleY = param1;
         this.updateBMCache(false);
      }
      
      public function onRenderEnd(param1:Number, param2:Asset = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         Utils.scaleFactor = 1;
         if(param1 > Pixton.FULLSIZE)
         {
            this.contents.mask = this.contentMask;
         }
         _loc4_ = this.renderHide.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.renderHide[_loc3_].visible = true;
            _loc3_++;
         }
         if(param2 != null)
         {
            this.containerD.visible = true;
         }
         _loc4_ = this.containerC.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.containerC.getChildAt(_loc3_);
            if(param2 != null && _loc5_ != param2)
            {
               _loc5_.visible = true;
            }
            if(_loc5_ is Asset)
            {
               Asset(_loc5_).setBlurAmount(Asset(_loc5_).getBlurAmount());
            }
            _loc3_++;
         }
         if(Template.isActive())
         {
            _loc4_ = this.containerD.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if((_loc5_ = this.containerD.getChildAt(_loc3_)) is Dialog)
               {
                  Dialog(_loc5_).visible = true;
               }
               _loc3_++;
            }
         }
         if(Comic.isFreestyle() && this.hasDefaultBorder())
         {
            this.customBorder.visible = true;
         }
         this.customBorder.x = 0;
         this.customBorder.y = 0;
         this.customBorder.scaleX = 1;
         this.customBorder.scaleY = 1;
         this.contentMask.scaleX = 1;
         this.contentMask.scaleY = 1;
         this.containerB.visible = true;
         this.renderHide = null;
         this.updateBMCache();
      }
      
      public function onChangeDialog(param1:PixtonEvent) : void
      {
         this.onTargetMoved(param1);
      }
      
      public function onChangeCharacter(param1:PixtonEvent) : void
      {
         this.onEditCharacter(param1,false);
      }
      
      public function onDoubleClick(param1:PixtonEvent) : void
      {
         if(this.mode == MODE_EXPR && this.mnuLooks.visible)
         {
            this.mode = MODE_LOOKS;
         }
         else if(this.mode == MODE_LOOKS && this.mnuScale.visible)
         {
            this.mode = MODE_SCALE;
         }
         else if(this.mode == MODE_SCALE && this.mnuColors.visible)
         {
            this.mode = MODE_COLORS;
         }
         else if(this.mode == MODE_COLORS)
         {
            this.mode = MODE_EXPR;
         }
         Character(this.currentTarget).drillUp(param1.value2);
      }
      
      public function onEditCharacter(param1:PixtonEvent, param2:Boolean = true) : void
      {
         var _loc3_:Character = null;
         if(this.mode == MODE_LOOKS || this.mode == MODE_SCALE || this.mode == MODE_COLORS)
         {
            if(param1.value2)
            {
               _loc3_ = Character(param1.value);
               Character.sendTeamUpdate(_loc3_.getID(),_loc3_.getGenome());
            }
         }
         this.redraw();
         this.onChange(param2);
      }
      
      public function updateAllCharacters(param1:int, param2:Object, param3:Character = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:uint = 0;
         _loc6_ = this.containerC.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            if((_loc5_ = this.containerC.getChildAt(_loc4_)) is Character && _loc5_ != param3 && (Character(_loc5_).getID() == param1 || Character(_loc5_).pendingID == param1))
            {
               Character(_loc5_).setID(param1,true);
               Character(_loc5_).setGenome(param2);
               Character(_loc5_).redraw();
            }
            _loc4_++;
         }
      }
      
      public function resetMode() : void
      {
         this.mode = MODE_MAIN;
         this.setSelection();
         Main.shiftPressed = false;
         this.updateZoomerRange();
         Animation.reset();
      }
      
      private function updateZoomerRange() : void
      {
         if(AppSettings.isAdvanced || Template.isActive())
         {
            this.zoomer.setRangeLimit(Zoomer.DEF_MIN,Zoomer.DEF_MAX);
         }
         else
         {
            this.zoomer.setRangeLimit(Zoomer.DEF_MIN_BASIC,Zoomer.DEF_MAX_BASIC);
         }
         this.zoomer.setDefault(this.zoomer.calculateValue(DEFAULT_SCALE_2));
      }
      
      public function forceToMaxWidth() : void
      {
         this.setDimensions(this.maxWidth,this.getHeight());
      }
      
      private function setRotation(param1:Number) : void
      {
         this.sceneRotation = param1;
         this.contentsC.rotation = this.sceneRotation;
         this.redraw();
      }
      
      private function updateRotate(param1:PixtonEvent) : void
      {
         if(param1.value == null)
         {
            this.setRotation(Math.round(this.contentsC.rotation / Utils.SNAP_ANGLE) * Utils.SNAP_ANGLE);
         }
         else
         {
            this.setRotation(param1.value.r);
         }
         this.onChange(false);
         this.redraw();
      }
      
      private function changeCursor(param1:MouseEvent) : void
      {
         Cursor.show(Cursor.MOVE);
      }
      
      private function revertCursor(param1:MouseEvent) : void
      {
         Cursor.show();
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         _loc3_ = false;
         if(param1.currentTarget is Asset && Asset(param1.currentTarget).isLocked())
         {
            _loc2_ = L.text("object-locked");
         }
         else if(param1.currentTarget is Character)
         {
            if(!this.mouseIsDown)
            {
               if(this.mode == MODE_MAIN)
               {
                  _loc2_ = L.text("click-2");
               }
               else if(param1.currentTarget == this.currentTarget)
               {
                  _loc2_ = L.text("dbl-drag");
               }
            }
         }
         else if(param1.currentTarget is Dialog)
         {
            if(!this.mouseIsDown)
            {
               if(this.mode == MODE_MAIN)
               {
                  _loc2_ = L.text("click-2");
               }
               else if(param1.currentTarget == this.currentTarget)
               {
                  if(this.mode == MODE_MOVE)
                  {
                     _loc2_ = L.text("dbl-drag");
                  }
                  else
                  {
                     _loc2_ = L.text("type-text");
                  }
               }
            }
         }
         else if(param1.currentTarget is Prop)
         {
            if(!this.mouseIsDown && this.mode == MODE_MAIN)
            {
               _loc2_ = L.text("click-1");
            }
         }
         else if(param1.currentTarget.alpha == 1)
         {
            switch(param1.currentTarget)
            {
               case this.mnuAddC:
                  _loc2_ = L.text("add-c");
                  break;
               case this.mnuSwapC:
                  _loc2_ = L.text("swap-char");
                  break;
               case this.mnuAddD:
                  _loc2_ = L.text("add-d");
                  break;
               case this.mnuAddP:
                  _loc2_ = L.text("add-p");
                  break;
               case this.mnuAddPh:
                  _loc2_ = L.text("add-photo");
                  break;
               case this.mnuDraw:
                  _loc2_ = L.text("add-drawing");
                  break;
               case this.mnuAddB:
                  _loc2_ = L.text("add-b");
                  break;
               case this.mnuColor:
                  if(Template.isActive() && this.currentTarget is Character)
                  {
                     _loc2_ = L.text("skin-color");
                  }
                  else if(this.currentTarget is Prop)
                  {
                     _loc2_ = L.text("color");
                  }
                  else
                  {
                     _loc2_ = L.text("bkgd-color");
                  }
                  break;
               case this.mnuGradient:
                  _loc2_ = L.text("bkgd-gradient");
                  break;
               case this.mnuColorB:
                  _loc2_ = L.text("border-c");
                  break;
               case this.mnuSaturation:
                  _loc2_ = L.text("panel-sa");
                  break;
               case this.mnuBrightness:
                  _loc2_ = L.text("panel-br");
                  break;
               case this.mnuContrast:
                  _loc2_ = L.text("panel-co");
                  break;
               case this.mnuBorder:
                  _loc2_ = L.text("edit-b");
                  break;
               case this.mnuBShape:
                  _loc2_ = L.text("b-shape");
                  break;
               case this.mnuBSize:
                  _loc2_ = L.text("thickness");
                  break;
               case this.border.top:
                  _loc2_ = L.text("move-panel");
                  break;
               case this.mnuColor1:
                  _loc2_ = L.text("color");
                  break;
               case this.mnuColor2:
                  _loc2_ = L.text("asset-color-2");
                  break;
               case this.mnuColor3:
                  _loc2_ = L.text("asset-color-3");
                  break;
               case this.mnuColor4:
                  _loc2_ = L.text("asset-color-4");
                  break;
               case this.mnuColor5:
                  _loc2_ = L.text("asset-color-5");
                  break;
               case this.mnuColorD:
                  _loc2_ = L.text("bkgd-color");
                  break;
               case this.mnuColorDB:
                  _loc2_ = L.text("border-c");
                  break;
               case this.mnuSound:
                  _loc2_ = L.text("upload-sound");
                  break;
               case this.mnuRecord:
                  _loc2_ = L.text("record-sound");
                  break;
               case this.mnuLink:
                  _loc2_ = L.text("add-link");
                  break;
               case this.mnuVoice:
                  _loc2_ = L.text("speech-to-text");
                  break;
               case this.mnuSave:
                  _loc2_ = L.text("save-scene");
                  break;
               case this.mnuSaveB:
                  _loc2_ = L.text("new-bkgd-set");
                  break;
               case this.mnuHiRes:
                  _loc2_ = L.text("save-hi-res");
                  break;
               case this.mnuRevert:
                  _loc2_ = L.text("revert-scene");
                  break;
               case this.mnuUndo:
                  _loc2_ = L.text("undo");
                  break;
               case this.mnuRedo:
                  _loc2_ = L.text("redo");
                  break;
               case this.mnuAlpha:
                  _loc2_ = L.text("alpha");
                  break;
               case this.mnuSet:
                  _loc2_ = L.text("set");
                  break;
               case this.mnuUnset:
                  _loc2_ = L.text("unset");
                  break;
               case this.btnPan:
                  _loc2_ = L.text("toggle-pan");
                  break;
               case this.btnEditLarge:
                  _loc2_ = L.text("click-edit-zoom");
                  break;
               case this.mnuTrash:
                  _loc2_ = L.text("delete-scene");
                  break;
               case this.mnuClear:
                  _loc2_ = L.text("blank-scene");
                  break;
               case this.mnuClose:
                  _loc2_ = L.text("close-no-save");
                  break;
               case this.mnuLock:
                  _loc2_ = L.text("lock-objects");
                  break;
               case this.mnuLock2:
                  _loc2_ = L.text("lock-object");
                  break;
               case this.mnuUnlock:
                  _loc2_ = L.text("unlock-all");
                  break;
               case this.mnuSilOn:
                  _loc2_ = L.text("silhouette");
                  break;
               case this.mnuSilOff:
                  _loc2_ = L.text("no-silhouette");
                  break;
               case this.mnuIsProp:
                  _loc2_ = L.text("is-prop");
                  break;
               case this.mnuNotProp:
                  _loc2_ = L.text("not-prop");
                  break;
               case this.mnuBubble:
                  _loc2_ = L.text("bubble-shape");
                  break;
               case this.mnuSpike:
                  _loc2_ = L.text("spike-style");
                  break;
               case this.mnuAuto:
                  _loc2_ = L.text("auto-size");
                  break;
               case this.mnuManual:
                  _loc2_ = L.text("manual-size");
                  break;
               case this.mnuSize:
                  _loc2_ = L.text("change-text-size");
                  break;
               case this.mnuFont:
                  _loc2_ = L.text("change-font");
                  break;
               case this.mnuPadding:
                  _loc2_ = L.text("change-padding");
                  break;
               case this.mnuTColor:
                  _loc2_ = L.text("text-color");
                  break;
               case this.mnuMore:
                  _loc2_ = L.text("show-more-options");
                  break;
               case this.mnuFlipH:
                  _loc2_ = L.text("flip-h");
                  break;
               case this.mnuFlipV:
                  _loc2_ = L.text("flip-v");
                  break;
               case this.mnuFlipZ:
                  _loc2_ = L.text("flip-z");
                  break;
               case this.mnuToFront:
               case this.mnuToFront2:
                  _loc2_ = L.text("bring-forward");
                  break;
               case this.mnuToBack:
               case this.mnuToBack2:
                  _loc2_ = L.text("send-back");
                  break;
               case this.mnuDupl:
                  _loc2_ = L.text("duplicate").toLowerCase();
                  break;
               case this.mnuDelete:
                  _loc2_ = L.text("remove-from-scene");
                  break;
               case this.mnuRandFace:
                  _loc2_ = L.text("random-expr");
                  break;
               case this.mnuRandPose:
                  _loc2_ = L.text("random-pose");
                  break;
               case this.mnuPose:
                  _loc2_ = L.text("preset-poses");
                  break;
               case this.mnuFace:
                  _loc2_ = L.text("preset-expr");
                  break;
               case this.mnuRand:
                  _loc2_ = L.text(this.currentTarget is Dialog ? "random-phrase" : "random-char");
                  break;
               case this.mnuSave2:
                  _loc2_ = L.text("save-char");
                  break;
               case this.mnuOutfit:
                  _loc2_ = L.text("pick-outfit");
                  break;
               case this.mnuSavePose:
                  _loc2_ = L.text("save-pose");
                  break;
               case this.mnuSaveFace:
                  _loc2_ = L.text("save-face");
                  break;
               case this.mnuRevert2:
                  _loc2_ = L.text("revert-char");
                  break;
               case this.mnuMove:
                  _loc2_ = L.text("move-object");
                  break;
               case this.mnuTEdit:
                  _loc2_ = L.text("edit-text");
                  break;
               case this.mnuDEdit:
                  _loc2_ = L.text("edit-drawing");
                  break;
               case this.mnuPEdit:
                  _loc2_ = L.text("edit-prop");
                  break;
               case this.mnuExpr:
                  _loc2_ = L.text("edit-expr");
                  break;
               case this.mnuLooks:
                  _loc2_ = L.text("edit-char");
                  break;
               case this.mnuScale:
                  _loc2_ = L.text("edit-scale");
                  break;
               case this.mnuColors:
                  _loc2_ = L.text("edit-color");
                  break;
               case this.mnuZoomFace:
                  _loc2_ = L.text("zoom-in");
                  break;
               case this.mnuZoomBody:
                  _loc2_ = L.text("zoom-out");
                  break;
               case this.mnuGlowAmount:
                  _loc2_ = L.text("glow-amt");
                  break;
               case this.mnuBlurAmount:
                  _loc2_ = L.text("blur-amt");
                  break;
               case this.mnuBlurAngle:
                  _loc2_ = L.text("blur-angle");
                  break;
               case this.mnuFreestyle:
                  _loc2_ = L.text("make-freestyle");
                  break;
               case this.mnuNotes:
                  _loc2_ = L.text("toggle-notes");
                  break;
               case this.mnuDialogLine:
                  _loc2_ = L.text("border-thickness");
                  break;
               case this.mnuLeading:
                  _loc2_ = L.text("line-spacing");
                  break;
               case this.mnuAlignL:
               case this.mnuAlignR:
               case this.mnuAlignC:
                  _loc2_ = L.text("text-alignment");
                  break;
               case this.mnuDescLen:
                  _loc2_ = L.text("desc-len");
                  break;
               case this.imageCredit.btnReport:
                  _loc2_ = L.text("report-photo");
            }
         }
         if(_loc2_ != null)
         {
            Help.show(_loc2_.toLowerCase(),param1.currentTarget,_loc3_);
         }
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      private function revert() : void
      {
         this.unsetData();
         if(Team.isActive)
         {
            Main.self.loadScene(Comic.self.getPanelKey(),true);
         }
         else
         {
            this.setPositionData(this.originalPositionData);
            this.setData(this.originalAssetData);
            this.onChange();
         }
      }
      
      public function undo() : void
      {
         if(!(this.undoStack != null && this.currentState > 0))
         {
            return;
         }
         this.undoing = true;
         this.restoreState(this.undoStack[--this.currentState]);
         this.undoing = false;
      }
      
      public function redo() : void
      {
         if(!(this.undoStack != null && this.currentState < this.undoStack.length - 1))
         {
            return;
         }
         this.redoing = true;
         this.restoreState(this.undoStack[++this.currentState]);
         this.redoing = false;
      }
      
      public function assetSelected(param1:Boolean) : Boolean
      {
         if(param1 && this.currentTarget is Character && !Character(this.currentTarget).hasID())
         {
            return false;
         }
         return this.selector.visible;
      }
      
      public function isHidable() : Boolean
      {
         return this.currentTarget is Character && Character(this.currentTarget).partIsHidable();
      }
      
      public function isRenamableCharacter() : Boolean
      {
         return this.currentTarget is Character && Character(this.currentTarget).hasID();
      }
      
      public function hideAsset() : void
      {
         Character(this.currentTarget).hideActive();
         this.onStateChange();
      }
      
      public function hasHidden() : Boolean
      {
         return this.currentTarget is Character && Character(this.currentTarget).hasHiddenPart();
      }
      
      public function showAsset() : void
      {
         Character(this.currentTarget).showAll();
         this.onStateChange();
      }
      
      public function editAsset() : void
      {
         if(this.currentTarget is Character)
         {
            Character(this.currentTarget).promptForName();
         }
      }
      
      private function restoreState(param1:Object) : void
      {
         this.unsetData();
         this.setPositionData(this.originalPositionData);
         this.setData(param1,ACTION_RESTORING);
         this.mode = MODE_MAIN;
         this.onChange();
      }
      
      private function dialogsEmpty() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Dialog = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc1_ = true;
         _loc4_ = this.containerD.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.containerD.getChildAt(_loc3_) as Dialog;
            _loc1_ = _loc1_ && _loc2_.text == "";
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function editFirstDialog() : void
      {
         var _loc1_:Dialog = null;
         if(this.containerD.numChildren > 0)
         {
            _loc1_ = this.containerD.getChildAt(0) as Dialog;
            this.setSelection(_loc1_);
            this.mode = MODE_EXPR;
         }
      }
      
      public function somethingLocked() : Boolean
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.containerC.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.containerC.getChildAt(_loc2_);
            if(Moveable(_loc1_).isLocked())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function lockAll(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = this.containerC.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.containerC.getChildAt(_loc4_);
            if(!(param2 && (_loc3_ is Character || _loc3_ is Dialog || _loc3_ is Prop && !(_loc3_ is PropSet))))
            {
               Moveable(_loc3_).lock(param1);
            }
            _loc4_++;
         }
      }
      
      public function unlockAll(param1:Boolean = false) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = this.containerC.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.containerC.getChildAt(_loc3_);
            if(Moveable(_loc2_).isLocked(param1))
            {
               Moveable(_loc2_).unlock(param1);
            }
            _loc3_++;
         }
      }
      
      public function getContainer() : MovieClip
      {
         return this.containerC;
      }
      
      private function startPanning() : void
      {
         if(Cursor.has(Cursor.DRAG) || !TeamRole.can(TeamRole.PANELS))
         {
            return;
         }
         this.btnPan.makePriority();
         Cursor.show(Cursor.DRAG);
         this.lockAll(true);
         this.onClickAway();
      }
      
      private function stopPanning() : void
      {
         if(!Cursor.has(Cursor.DRAG))
         {
            return;
         }
         this.btnPan.makePriority(false);
         Cursor.show();
         this.unlockAll(true);
      }
      
      private function isPanning() : Boolean
      {
         return Cursor.has(Cursor.DRAG);
      }
      
      private function togglePanning(param1:MouseEvent = null) : void
      {
         if(this.isPanning())
         {
            this.stopPanning();
         }
         else
         {
            this.startPanning();
         }
      }
      
      public function getAnimationData() : Object
      {
         return {
            "x":this.xPos,
            "y":this.yPos,
            "z":this.scale,
            "r":this.sceneRotation,
            "k":this.getColor()
         };
      }
      
      public function getInterpolatedPositionData(param1:Array, param2:Number) : Object
      {
         return this.setAnimationData(param1,param2,true);
      }
      
      public function setAnimationData(param1:Array, param2:Number, param3:Boolean = false) : Object
      {
         var _loc4_:Object = null;
         (_loc4_ = {}).x = Animation.interpolate(param1[0].x,param1[1].x,param1[2].x,param1[3].x,param2,0,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
         _loc4_.y = Animation.interpolate(param1[0].y,param1[1].y,param1[2].y,param1[3].y,param2,0,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
         _loc4_.z = Animation.interpolate(param1[0].z,param1[1].z,param1[2].z,param1[3].z,param2,0,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
         _loc4_.r = Animation.interpolate(param1[0].r,param1[1].r,param1[2].r,param1[3].r,param2,Utils.WRAP_360,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
         _loc4_.k = Animation.interpolate(param1[0].k,param1[1].k,param1[2].k,param1[3].k,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
         if(param3)
         {
            return _loc4_;
         }
         this.setData(_loc4_,ACTION_PASTING,true,true);
         return null;
      }
      
      function updateData(param1:Object) : void
      {
         this.setSelection();
         this.unsetData();
         this.setPositionData(this.originalPositionData);
         this.setData(param1,0,false,false,true);
      }
      
      private function onBeginAction(param1:MouseEvent = null) : void
      {
         if(!Team.isActive || this.isLocked())
         {
            return;
         }
         startLock();
         if(param1 == null)
         {
            endLock();
         }
         else
         {
            Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onEndAction);
         }
      }
      
      private function onEndAction(param1:MouseEvent) : void
      {
         endLock();
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onEndAction);
      }
      
      private function clearTeamTimer() : void
      {
         if(Team.interval > 0)
         {
            clearInterval(Team.interval);
            Team.interval = 0;
         }
      }
      
      private function restartTeamTimer(param1:Boolean = false) : void
      {
         if(!Team.isActive)
         {
            return;
         }
         if(!Comic.self.isLocked(null,true))
         {
            Comic.lockPanel(param1);
         }
         this.clearTeamTimer();
         Team.countdown = Team.TIMER_TOTAL;
         Team.interval = setInterval(this.onTeamTimer,Team.TIMER_INTERVAL);
      }
      
      private function onTeamTimer() : void
      {
         if(this.mode == MODE_EXPR && this.currentTarget is Dialog)
         {
            return;
         }
         if(Team.keepLocked)
         {
            return;
         }
         if(Main.self.popup.visible)
         {
            return;
         }
         if(this.zoomMode != ZOOM_NONE)
         {
            return;
         }
         Team.countdown -= Team.TIMER_INTERVAL;
         if(Team.countdown <= 0)
         {
            this.teamUnlock();
            this.sendTeamUpdate();
         }
      }
      
      function teamUnlock() : void
      {
         if(!Team.isActive)
         {
            return;
         }
         this.clearTeamTimer();
         this._locked = false;
         Panel.showLocked(this,null);
         Comic.unlockPanel();
         this.createSnapshot();
      }
      
      function sendTeamUpdate(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(!Team.isActive)
         {
            return;
         }
         if(param1 == null)
         {
            _loc2_ = this.getData();
         }
         else
         {
            _loc2_ = Utils.clone(param1);
         }
         _loc3_ = Comic.self.getPanelKey();
         if(_loc3_ != null)
         {
            if(Comic.isFreestyle())
            {
               Team.onChange(Comic.key,_loc3_,Team.P_PANEL_XY,null,{
                  "x":_loc2_.xp,
                  "y":_loc2_.yp
               });
            }
            delete _loc2_.xp;
            delete _loc2_.yp;
            if(!this._disableTeamStateUpdate)
            {
               Team.onChange(Comic.key,_loc3_,Team.P_PANEL_STATE,null,_loc2_);
            }
         }
      }
      
      public function isLocked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc2_ = 0;
         if(param1 != null)
         {
            _loc2_ = param1.u;
            _loc3_ = param1.s;
         }
         if(_loc2_ == 0 || _loc3_ == Main.sessionID)
         {
            this._locked = false;
            if(Comic.isLocked() && !Comic.isLocked(null,true))
            {
               this.setSelection();
               this.mode = MODE_MAIN;
            }
         }
         else
         {
            this._locked = true;
            if(_loc3_ != Main.sessionID)
            {
               this.onClickAway();
            }
         }
         Panel.showLocked(this,param1);
      }
      
      private function createSnapshot() : void
      {
      }
      
      private function destroySnapshot() : void
      {
         if(this.snapshotBM != null)
         {
            removeChild(this.snapshotBM);
            this.snapshotBM = null;
         }
      }
      
      public function rotateTarget(param1:Number) : void
      {
      }
      
      public function panTarget(param1:Number, param2:Number) : void
      {
      }
      
      public function zoomTarget(param1:Number, param2:Number) : void
      {
      }
      
      function setPropDefaults() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         if(!visible)
         {
            return;
         }
         this.updateAssetData();
         _loc2_ = this.propData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!(Prop.previewID > 0 && this.propData[_loc1_]["id"] != Prop.previewID))
            {
               _loc3_ = Prop.getData(this.propData[_loc1_]["id"]);
               this.propData[_loc1_]["class"] = _loc3_.l;
            }
            _loc1_++;
         }
         Utils.remote("setPropDefaults",{"propData":this.propData},this.onSetPropDefaults,true);
      }
      
      private function onSetPropDefaults(param1:Object) : void
      {
         Utils.javascript("onSetPropDefaults");
      }
      
      function captureCharacters() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Character = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:MovieClip = null;
         Debug.trace("captureCharacters: " + Main.controlPressed);
         if(Main.controlPressed)
         {
            _loc2_ = this.containerC.numChildren;
            _loc3_ = {};
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if((_loc4_ = this.containerC.getChildAt(_loc1_)) is Character)
               {
                  _loc5_ = _loc4_ as Character;
                  _loc8_ = SkinManager.getInfo(_loc5_.skinType);
                  _loc6_ = 0;
                  while(_loc6_ < _loc8_.numTurns)
                  {
                     _loc7_ = 0;
                     while(_loc7_ < _loc8_.numTurns)
                     {
                        _loc5_.bodyParts.setTurn(_loc8_.rootBodyPart,_loc6_);
                        _loc5_.bodyParts.setTurn(_loc8_.rootHeadPart,_loc7_);
                        _loc5_.redraw(true);
                        Utils.remote("captureZOrder",{"data":_loc5_.bodyParts.captureZOrder()});
                        _loc7_++;
                     }
                     _loc6_++;
                  }
                  break;
               }
               _loc1_++;
            }
         }
         else
         {
            _loc2_ = Character.skinMCs.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = {};
               _loc3_["a"] = [];
               _loc3_["a"].push(Character.captureMC(Character.skinMCs[_loc1_].getChildAt(0) as MovieClip));
               Utils.remote("captureCharacters",{
                  "file":Character.getFile(_loc1_),
                  "data":_loc3_
               });
               _loc1_++;
            }
         }
      }
      
      function getLineAlpha() : Number
      {
         return Asset.lineAlpha;
      }
      
      function setLineAlpha(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:uint = 0;
         Asset.lineAlpha = param1;
         _loc4_ = this.containerC.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.containerC.getChildAt(_loc2_);
            if(_loc3_ is Character)
            {
               Character(_loc3_).setLineAlpha(param1);
            }
            else if(_loc3_ is Prop)
            {
               Prop(_loc3_).setLineAlpha(param1);
            }
            _loc2_++;
         }
      }
      
      public function getCharacter(param1:int = -1) : DisplayObject
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         if(param1 == -1)
         {
            return this.containerC.getChildAt(0);
         }
         _loc2_ = 0;
         _loc4_ = this.containerC.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = this.containerC.getChildAt(_loc3_)) is Character)
            {
               if(_loc2_++ == param1)
               {
                  return _loc5_;
               }
            }
            _loc3_++;
         }
         return null;
      }
      
      private function setLink(param1:String, param2:Function) : void
      {
         var _loc3_:Boolean = false;
         if(param1 != null && (param1 == "" || Utils.isValidURL(param1)))
         {
            Dialog(this.currentTarget).setLink(param1);
            _loc3_ = true;
         }
         else
         {
            _loc3_ = false;
         }
         param2(_loc3_);
      }
      
      private function onSetLink(param1:Boolean) : void
      {
         if(param1)
         {
            this.updateSelector();
         }
      }
      
      public function randomizeExpression(param1:uint) : void
      {
         this.hidePicker();
         Character(this.currentTarget).randomPose(param1);
         this.updateSelector();
         this.onStateChange();
         this.onBeginAction();
      }
      
      public function resetScale() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Asset = null;
         var _loc4_:Character = null;
         var _loc5_:Number = NaN;
         _loc2_ = this.containerC.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.containerC.getChildAt(_loc1_) as Asset;
            if(_loc3_ is Character)
            {
               _loc4_ = _loc3_ as Character;
            }
            _loc1_++;
         }
         if(_loc4_)
         {
            _loc5_ = 1 / _loc4_.size;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.containerC.getChildAt(_loc1_) as Asset;
               _loc3_.x *= _loc5_;
               _loc3_.y *= _loc5_;
               _loc3_.size *= _loc5_;
               _loc1_++;
            }
            this.xPos /= _loc5_;
            this.yPos /= _loc5_;
            this.scale /= _loc5_;
            this.zoomer.value = this.zoomer.calculateValue(this.scale);
         }
      }
   }
}
