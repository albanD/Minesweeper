package model 
{
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
			//array of array, the values show what is inside:
			//first value:
			//9: mine
			//0..8: nor mine, number of adjacent mines
			//second value:
			//0: not revealed
			//1: revealed
			//2: mrked as mine
			_size = size;
			_grid = new Array();
			for (var i:Number = 0; i < _size * _size; i++) {
				_grid.push(new Array(0,0));
			}
			
			fill_array();
		}
		
		//filling the array
		private function fill_array():void {			
			//add the mines
			add_random_mines();
			print_grid();
			//fill the correct values for the adjacent mine
			adjacent_mines();
			print_grid()
			//filling the array
		}
		
		//add the mines to the grid
		private function add_random_mines():void 
		{
			//number of mines depend on the size
			//TODO can be asked to the user
			var n_mines:Number = _size * _size / 8 - 1;
			var x:Number;
			var y:Number;
			
			var i:Number = 0; //number of added mines
			while (i<n_mines) {
				x = Math.floor(Math.random()*_size)
				y = Math.floor(Math.random()*_size)
				if (_grid[x * _size + y][0] != 9) {
					//if its ot already a mine set it as a mine
					_grid[x * _size + y][0] = 9
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
					if (_grid[i * _size + j][0] == 9) {
						//for all adjacent elements
						for (var k:Number = -1; k <= 1; k++) {
							for (var l:Number = -1; l <= 1; l++) {
								//if its not a mine and within the grid range
								if ((i + k)>-1 && (i + k)<_size && (j+l)>-1 && (j+l)<_size && _grid[(i + k) * _size + (j + l)][0] != 9) {
									//add one to its value of adjacent
									_grid[(i + k) * _size + (j + l)][0] += 1;
								}
							}
						}
					}
				}
			}
		}
		
		//debug function
		//print the grid in the trace
		public function print_grid():void {
			var to_print:String;
			for (var i:Number = 0; i < _size; i++) {
				to_print = "";
				for (var j:Number = 0; j < _size; j++) {
					to_print += String(_grid[i * _size + j]) + " ";					
				}
				trace(to_print);
			}
			trace("\n\n");
		}
	}
	

}