package controller 
{
	
	import flash.events.MouseEvent;
	import model.*;
	import view.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.system.System;
	import flash.external.ExternalInterface;

	
	
	public class MSController 
	{
		private var _model:MSModel;
		private var _view:MSView;
		
		//win screen variable
		private var WIN:Number = 1;
		private var LOST:Number = 0;
		//game launch variable
		private var EASYGAME:Number = 1;
		private var MEDIUMGAME:Number = 2;
		private var HARDGAME:Number = 3;
		
		public function MSController(model:MSModel, view:MSView) 
		{
			_model = model;
			_view = view;
			trace("controller created");
		}
		
		//starting point
		public function start_game():void 
		{
			_view.starting_screen(this);
		}
		//game starting funtion
		public function launch_game(mode:Number):void {
			var size:Number;
			if (mode == EASYGAME) {
				size = 5;
			}
			else if (mode == MEDIUMGAME) {
				size = 10;
			}
			else if (mode == HARDGAME) {
				size = 15;
			}
			_model.init(size);
		}
		
		
		//reveal the elements
		public function reveal(x:Number, y:Number):void 
		{
			//if its already revealed or marked: do nothing
			if (_model._grid[x][y].is_revealed || _model._grid[x][y].is_marked) {
				return;
			}
			//if its a mine, you lost
			else if (_model._grid[x][y].is_mine) {
				loose_game();
			}
			//else reveal the place and all adjacent places if there are no adjacent mines
			else {
				_model._grid[x][y].is_revealed = true;
				
				if (_model._grid[x][y].adjacent_mines == 0) {
					for (var i:Number = -1; i < 2; i++) {
						for (var j:Number = -1; j < 2; j++) {
							if(_model.is_inside(x+i, y+j)) {
								reveal(x + i, y + j);
							}
						}
					}
				}
				is_win();
			}
		}
		
		//mark a mine
		public function mark(x:Number, y:Number):void 
		{
			var element:Tile = _model._grid[x][y]
			
			if (!element.is_revealed) {
				element.is_marked = !element.is_marked;
			}
		}
		
		//test if the player win the game by leaving only mines
		private function is_win():void 
		{
			var size:Number = _model._size;
			for (var x:Number = 0; x < size; x++) {
				for (var y:Number = 0; y < size; y++) {
					if (!_model._grid[x][y].is_revealed && !_model._grid[x][y].is_mine) {
						return;
					}
				}
			}
			_view.play_again(WIN);
		}
		
		//loose the game function
		private function loose_game():void 
		{
			trace("you lost");
			_view.play_again(LOST);
		}
		
		//close the program if in a window, do nothing if its in the browser.
		public function quit():void 
		{
			//if we are in a browser(works with firefox), we cannot quit so restart the game
			try {
				var userAgent:String;
				userAgent = ExternalInterface.call("window.navigator");
				this.start_game();
			}
			catch (e:Error) {
				//if we are in a flash window, quit it
				System.exit(0);
			}
		}
	}

}