package controller 
{
	
	import flash.events.MouseEvent;
	import model.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public class MSController 
	{
		private var _model:MSModel;
		
		public function MSController(model:MSModel) 
		{
			_model = model;
			trace("controller created");
		}
		
		//game starting funtion
		public function start_game(mode:Number):void {
			var size:Number;
			if (mode == 1) {
				size = 5;
			}
			else if (mode == 2) {
				size = 10;
			}
			else if (mode == 3) {
				size = 15;
			}
			_model.init(size);
		}
		
		
		//reveal the elements
		public function reveal(x:Number, y:Number):void 
		{
			//if its already revealed or marked: do nothing
			if (_model._grid[x + y * _model._size][1] == 1) {
				return;
			}
			else if (_model._grid[x + y * _model._size][1] == 2) {
				return;
			}
			//if its a mine, you lost
			else if (_model._grid[x + y * _model._size][0] == 9) {
				loose_game();
			}
			//else reveal the place and all adjacent places
			else {
				_model._grid[x + y * _model._size][1] = 1;
				if (_model._grid[x + y * _model._size][0] == 0) {
					for (var i:Number = -1; i < 2; i++) {
						for (var j:Number = -1; j < 2; j++) {
							if(x+i<_model._size && x+i > 0 && y+j<_model._size && y+j>0) {
								reveal(x + i, y + j);
							}
						}
					}
				}
			}
		}
		
		//mark a mine
		public function mark(x:Number, y:Number):void 
		{
			//if its already revealed, do nothing
			if (_model._grid[x + y * _model._size][1] == 1) {
				return;
			}
			//if its already marked, unmark it
			else if (_model._grid[x + y * _model._size][1] == 2) {
				_model._grid[x + y * _model._size][1] = 0;
			}
			//if its not markes, mark it
			else if (_model._grid[x + y * _model._size][1] == 0) {
				_model._grid[x + y * _model._size][1] = 2;
			}
		}
		//loose the game function
		private function loose_game():void 
		{
			trace("you lost");
		}
	}

}