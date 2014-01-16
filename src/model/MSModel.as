package model 
{
	import model.Tile;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class MSModel  extends EventDispatcher
	{
		public var _grid:Array;
		public var _size:Number;
		
		public function MSModel() 
		{
			trace("model created");
		}
		
		//initialise the grid before the game
		public function init(size:Number):void 
		{
			trace("creating the game grid of size " + String(size));
			
			//creating the game grid
			//data model:
			//array of array of Tile
			_size = size;
			_grid = new Array();
			for (var i:Number = 0; i < _size; i++) {
				_grid.push(new Array());
				for (var j:Number = 0; j < _size; j++) {
					_grid[i].push(new Tile());
				}
			}
			
			fill_array();
		}
		
		//filling the array
		private function fill_array():void {			
			//add the mines
			add_random_mines();
			//print_grid();
			//fill the correct values for the adjacent mine
			adjacent_mines();
			//print_grid()
			//filling the array
		}
		
		//add the mines to the grid
		private function add_random_mines():void 
		{
			//number of mines depend on the size
			//TODO Find a better number of mines
			var n_mines:Number = _size * _size / 8 - 1;
			var x:Number;
			var y:Number;
			
			var i:Number = 0; //number of added mines
			while (i<n_mines) {
				x = Math.floor(Math.random()*_size)
				y = Math.floor(Math.random()*_size)
				if (!_grid[x][y].is_mine) {
					//if it's not already a mine set it as a mine
					_grid[x][y].is_mine = true;
					i++;
				}
			}			
		}
		
		//compute the number of adjacent mines
		private function adjacent_mines():void 
		{
			//for each mine, put +1 to the number of adjacent mines for adjacent positions.
			for (var i:Number = 0; i < _size; i++) {
				for (var j:Number = 0; j < _size; j++) {
					//if its a mine
					if (_grid[i][j].is_mine) {
						//for all adjacent elements
						for (var k:Number = -1; k <= 1; k++) {
							for (var l:Number = -1; l <= 1; l++) {
								//if it's within the grid range
								if (is_inside(i + k, j + l)) {
									//if it's not a mine
									if (!_grid[i + k][j + l].is_mine) {
										//add one to its value of adjacent
										_grid[i + k][j + l].adjacent_mines += 1;
									}
								}
							}
						}
					}
				}
			}
		}
		
		//check if coordonates are in the grid
		public function is_inside(x:Number, y:Number):Boolean 
		{
			if(x<_size && x >= 0 && y<_size && y>=0) {
				return true;
			}
			return false;
		}
		
		//debug function
		//print the grid in the trace
		public function print_grid():void {
			var to_print:String;
			for (var i:Number = 0; i < _size; i++) {
				to_print = "";
				for (var j:Number = 0; j < _size; j++) {
					to_print += _grid[i][j].adjacent_mines + " ";					
				}
				trace(to_print);
			}
			trace("\n\n");
		}
	}
	

}