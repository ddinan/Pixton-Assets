package com.pixton.editor
{
   public final class ComicLayout
   {
      
      private static var _widthSnaps:Array;
      
      private static var _maxWidthInRow:Number;
       
      
      public function ComicLayout()
      {
         super();
      }
      
      public static function updateLayout() : void
      {
         var activePanel:Panel = null;
         var _panelsByRow:Array = null;
         var currentX:uint = 0;
         var totalY:uint = 0;
         var maxPanelHeightPerRow:uint = 0;
         var spaceLeftByRow:Array = null;
         var currentRow:uint = 0;
         var i:uint = 0;
         var ni:uint = 0;
         var j:uint = 0;
         var nj:uint = 0;
         var commonHeight:uint = 0;
         var panelHeights:Object = null;
         var rowIncludesActivePanel:Boolean = false;
         var arrPanelHeights:Array = null;
         var panelHeight:String = null;
         var panels:Array = Comic.self.panels;
         if(!panels || !panels.length)
         {
            return;
         }
         if(Editor.self.visible)
         {
            activePanel = Comic.self.getActivePanel();
         }
         else if(Main.sceneToMove)
         {
            activePanel = Comic.self.getPanel(Main.sceneToMove);
         }
         _panelsByRow = [];
         currentX = 0;
         totalY = 0;
         maxPanelHeightPerRow = 0;
         spaceLeftByRow = [];
         currentRow = 0;
         var positionPanel:Function = function(param1:Panel):void
         {
            if(Main.sceneToMove)
            {
               param1.resetTempWidth();
               param1.resetTempHeight();
            }
            if(!_widthSnaps && currentX + param1.getWidth() > Comic.maxWidth)
            {
               spaceLeftByRow[currentRow] = Math.max(0,Comic.maxWidth - currentX + Comic.PADDING_H);
            }
            var _loc2_:Number = currentX + param1.getWidth();
            if(Editor.self.visible && activePanel && param1.index == activePanel.index)
            {
               param1.setTempWidth(Editor.self.getWidth());
            }
            else if(_loc2_ > Comic.maxWidth && _loc2_ <= Comic.maxWidth + 1)
            {
               param1.setTempWidth(param1.getWidth() - (_loc2_ - Comic.maxWidth));
            }
            if(currentX + param1.getWidth() > Comic.maxWidth)
            {
               totalY += maxPanelHeightPerRow + Comic.PADDING_V;
               ++currentRow;
               currentX = 0;
               maxPanelHeightPerRow = 0;
            }
            if(!_panelsByRow[currentRow])
            {
               _panelsByRow[currentRow] = [];
            }
            _panelsByRow[currentRow].push(param1);
            param1.row = currentRow;
            maxPanelHeightPerRow = Math.max(maxPanelHeightPerRow,param1.getHeight());
            currentX += param1.getWidth() * param1.scaleX + Comic.PADDING_H;
         };
         ni = panels.length;
         i = 0;
         while(i < ni)
         {
            positionPanel(panels[i]);
            i++;
         }
         var currentY:uint = 0;
         ni = _panelsByRow.length;
         i = 0;
         while(i < ni)
         {
            commonHeight = 0;
            nj = _panelsByRow[i].length;
            panelHeights = {};
            rowIncludesActivePanel = false;
            j = 0;
            while(j < nj)
            {
               if(activePanel && Panel(_panelsByRow[i][j]).index == activePanel.index)
               {
                  rowIncludesActivePanel = true;
               }
               if(panelHeights[Panel(_panelsByRow[i][j]).getHeight()] == null)
               {
                  panelHeights[Panel(_panelsByRow[i][j]).getHeight()] = 0;
               }
               ++panelHeights[Panel(_panelsByRow[i][j]).getHeight()];
               j++;
            }
            if(!Main.sceneToMove && activePanel && rowIncludesActivePanel)
            {
               commonHeight = !!Editor.self.visible ? uint(Editor.self.getHeight()) : uint(activePanel.getHeight());
            }
            else
            {
               arrPanelHeights = [];
               for(panelHeight in panelHeights)
               {
                  arrPanelHeights.push({
                     "height":parseInt(panelHeight),
                     "count":panelHeights[panelHeight]
                  });
               }
               arrPanelHeights.sortOn("count",Array.DESCENDING | Array.NUMERIC);
               commonHeight = arrPanelHeights[0].height;
            }
            currentX = 0;
            j = 0;
            while(j < nj)
            {
               if(!_widthSnaps)
               {
                  Panel(_panelsByRow[i][j]).setSpaceLeftInRow(spaceLeftByRow[i]);
               }
               Panel(_panelsByRow[i][j]).setTempHeight(commonHeight);
               Panel(_panelsByRow[i][j]).updateExtraPos();
               Comic.self.setPanelX(_panelsByRow[i][j] as Panel,currentX);
               Comic.self.setPanelY(_panelsByRow[i][j] as Panel,currentY);
               currentX += Panel(_panelsByRow[i][j]).getWidth() + Comic.PADDING_H;
               j++;
            }
            currentY += Panel(_panelsByRow[i][0]).getHeight() + Comic.PADDING_V;
            i++;
         }
         Main.resizeStage();
      }
      
      private static function requireWidthSnaps() : void
      {
         var _loc1_:Panel = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         if(!_widthSnaps)
         {
            _loc1_ = Comic.self.getActivePanel();
            _maxWidthInRow = _loc1_.getWidth() + _loc1_.getSpaceLeftInRow();
            _widthSnaps = [];
            _loc6_ = [];
            _loc2_ = 1;
            while(_loc2_ <= 5)
            {
               _loc4_ = _loc2_ == 1 ? uint(_loc2_ + 1) : uint(_loc2_);
               _loc3_ = 1;
               while(_loc3_ < _loc4_)
               {
                  if(_loc2_ / _loc3_ == 2)
                  {
                     _loc7_ = "1/2";
                  }
                  else if(_loc2_ / _loc3_ == 1)
                  {
                     _loc7_ = "100%";
                  }
                  else
                  {
                     _loc7_ = _loc3_ + "/" + _loc2_;
                  }
                  _loc5_ = Math.round((Comic.maxWidth + Comic.PADDING_H) / _loc2_ * _loc3_ - Comic.PADDING_H);
                  _widthSnaps.push({
                     "width":_loc5_,
                     "label":_loc7_
                  });
                  _loc6_.push(_loc5_);
                  _loc3_++;
               }
               _loc2_++;
            }
            if(_maxWidthInRow >= Comic.minWidth && !Utils.inArray(_maxWidthInRow,_loc6_))
            {
               _widthSnaps.push({
                  "width":_maxWidthInRow,
                  "label":"-/-"
               });
            }
            Utils.unique(_widthSnaps,"width");
         }
      }
   }
}
