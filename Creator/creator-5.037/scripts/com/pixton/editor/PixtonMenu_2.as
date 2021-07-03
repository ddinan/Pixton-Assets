package com.pixton.editor
{
   import com.pixton.team.TeamRole;
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public final class PixtonMenu
   {
      
      public static var available:Boolean = true;
      
      public static var mnuSwapChar:ContextMenuItem;
      
      public static var mnuDuplicate:ContextMenuItem;
      
      public static var mnuCopyScene:ContextMenuItem;
      
      public static var mnuPasteScene:ContextMenuItem;
      
      public static var mnuCopyAsset:ContextMenuItem;
      
      public static var mnuPasteAsset:ContextMenuItem;
      
      public static var mnuHideAsset:ContextMenuItem;
      
      public static var mnuShowAsset:ContextMenuItem;
      
      public static var mnuEditAsset:ContextMenuItem;
      
      public static var mnuMakeNewChar:ContextMenuItem;
      
      public static var mnuInfo:ContextMenuItem;
      
      private static const NUM_PRESET_ITEMS:uint = 10;
      
      private static var menu:ContextMenu;
      
      private static var activeSuggestions:Array = [];
       
      
      public function PixtonMenu()
      {
         super();
      }
      
      public static function setMenu(param1:Sprite) : void
      {
         if(!available)
         {
            return;
         }
         menu = new ContextMenu();
         menu.hideBuiltInItems();
         Utils.addListener(menu,ContextMenuEvent.MENU_SELECT,onMenu);
         if(Main.isPropsAdmin())
         {
            mnuInfo = addItem("Info");
         }
         mnuSwapChar = addItem(L.text("swap-char"),onSwapChar);
         mnuMakeNewChar = addItem(L.text("edit-new-char"),onMakeNewChar);
         mnuDuplicate = addItem(L.text("duplicate"),onDuplicate);
         mnuCopyScene = addItem(L.text("copy",L.text("scene")),onCopyScene);
         mnuPasteScene = addItem(L.text("paste",L.text("scene")),onPasteScene);
         mnuCopyAsset = addItem(L.text("copy",L.text("object")),onCopyAsset);
         mnuPasteAsset = addItem(L.text("paste",L.text("object")),onPasteAsset);
         mnuHideAsset = addItem(L.text("hide-part"),onHideAsset);
         mnuShowAsset = addItem(L.text("show-parts"),onShowAsset);
         mnuEditAsset = addItem(L.text("edit-char-name"),onEditAsset);
         param1.contextMenu = menu;
      }
      
      public static function suggest(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ContextMenuItem = null;
         _loc2_ = 0;
         while(_loc2_ < activeSuggestions.length)
         {
            Utils.removeListener(activeSuggestions[_loc2_],ContextMenuEvent.MENU_ITEM_SELECT,onSuggest);
            menu.customItems.shift();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < menu.customItems.length)
         {
            menu.customItems[_loc2_].visible = false;
            _loc2_++;
         }
         activeSuggestions = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ContextMenuItem(param1[_loc2_]);
            menu.customItems.unshift(_loc3_);
            Utils.addListener(_loc3_,ContextMenuEvent.MENU_ITEM_SELECT,onSuggest);
            activeSuggestions.push(_loc3_);
            _loc2_++;
         }
      }
      
      private static function onMenu(param1:ContextMenuEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc3_:Boolean = Dialog.isSpellChecking();
         var _loc4_:uint = menu.customItems.length;
         _loc2_ = NUM_PRESET_ITEMS;
         while(_loc2_ < _loc4_)
         {
            removeItem(menu.customItems[NUM_PRESET_ITEMS],onSuggest);
            _loc2_++;
         }
         if(_loc3_)
         {
            _loc5_ = Dialog.getCurrentWord();
            if((_loc6_ = Dialog.getSpellingSuggestions()) == null)
            {
               addItem(L.text("spelling-correct"),onSuggest,false);
            }
            else
            {
               addItem(L.text("spelling-add",_loc5_),onSpellingAdd);
               if(_loc6_.length == 0)
               {
                  addItem(L.text("spelling-unknown"),onSuggest,false);
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < _loc6_.length)
                  {
                     addItem(_loc6_[_loc2_],onSuggest);
                     _loc2_++;
                  }
               }
            }
         }
         else if(Main.displayManager.GET(Editor.self,DisplayManager.P_VIS))
         {
            mnuCopyAsset.caption = L.text("copy",L.text(Editor.getCopyLabel()));
            mnuPasteAsset.caption = L.text("paste",L.text(Editor.getPasteLabel()));
            mnuCopyScene.enabled = TeamRole.can(TeamRole.PROPS) && TeamRole.can(TeamRole.CHARACTERS) && TeamRole.can(TeamRole.DIALOG);
            mnuPasteScene.enabled = TeamRole.can(TeamRole.PROPS) && TeamRole.can(TeamRole.CHARACTERS) && TeamRole.can(TeamRole.DIALOG);
            mnuHideAsset.enabled = AppSettings.isAdvanced;
            mnuShowAsset.enabled = AppSettings.isAdvanced;
            mnuMakeNewChar.enabled = AppSettings.isAdvanced;
            mnuDuplicate.visible = Editor.assetSelected() && !Template.isActive();
            mnuCopyScene.visible = !Editor.assetSelected();
            mnuPasteScene.visible = !Editor.assetSelected();
            mnuCopyAsset.visible = Editor.assetSelected() && !Template.isActive();
            mnuPasteAsset.visible = Editor.assetInClipboard() && !Template.isActive();
            mnuHideAsset.visible = Editor.isHidable() && !Template.isActive();
            mnuShowAsset.visible = Editor.hasHidden() && !Template.isActive();
            mnuEditAsset.visible = Editor.isRenamableCharacter();
            mnuSwapChar.visible = Editor.charSelected(false);
            mnuMakeNewChar.visible = Editor.charSelected() && !Template.isActive();
            if(mnuInfo)
            {
               mnuInfo.visible = Editor.self.currentTarget && Editor.self.currentTarget is Asset;
               if(mnuInfo.visible)
               {
                  mnuInfo.caption = "Scale: " + Math.round(Asset(Editor.self.currentTarget).size * 100) + "%";
               }
            }
         }
      }
      
      private static function onSuggest(param1:ContextMenuEvent) : void
      {
         Dialog.correctSpelling(param1.target.caption);
      }
      
      private static function onSpellingIgnore(param1:ContextMenuEvent) : void
      {
         Dialog.ignoreSpelling();
      }
      
      private static function onSpellingAdd(param1:ContextMenuEvent) : void
      {
         Dialog.addSpelling();
      }
      
      private static function addItem(param1:String, param2:Function = null, param3:Boolean = true) : ContextMenuItem
      {
         var _loc4_:ContextMenuItem;
         (_loc4_ = new ContextMenuItem(param1)).enabled = param3;
         menu.customItems.push(_loc4_);
         if(param2 != null)
         {
            Utils.addListener(_loc4_,ContextMenuEvent.MENU_ITEM_SELECT,param2);
         }
         return _loc4_;
      }
      
      private static function removeItem(param1:ContextMenuItem, param2:Function) : void
      {
         Utils.removeListener(param1,ContextMenuEvent.MENU_ITEM_SELECT,param2);
         menu.customItems.pop();
      }
      
      public static function onCopyScene(param1:ContextMenuEvent = null) : void
      {
         Editor.copyData();
         Main.copyData();
      }
      
      public static function onDuplicate(param1:ContextMenuEvent = null) : void
      {
         Editor.duplicate();
      }
      
      public static function onPasteScene(param1:ContextMenuEvent = null) : void
      {
         Editor.pasteData();
      }
      
      public static function onCopyAsset(param1:ContextMenuEvent = null) : void
      {
         Editor.copyAsset();
      }
      
      public static function onPasteAsset(param1:ContextMenuEvent = null) : void
      {
         Editor.pasteAsset();
      }
      
      public static function onHideAsset(param1:ContextMenuEvent = null) : void
      {
         Editor.hideAsset();
      }
      
      public static function onShowAsset(param1:ContextMenuEvent = null) : void
      {
         Editor.showAsset();
      }
      
      public static function onEditAsset(param1:ContextMenuEvent = null) : void
      {
         Editor.editAsset();
      }
      
      public static function onSwapChar(param1:ContextMenuEvent = null) : void
      {
         Editor.swapCharacter();
      }
      
      public static function onMakeNewChar(param1:ContextMenuEvent = null) : void
      {
         Editor.makeNewCharacter();
      }
   }
}
