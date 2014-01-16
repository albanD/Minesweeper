package model 
{
	
	public class Tile 
	{
		
		public var is_mine:Boolean;
		public var is_marked:Boolean;
		public var is_revealed:Boolean;
		public var adjacent_mines:Number;
		
		public function Tile() 
		{
			is_mine = false;
			is_marked = false;
			is_revealed = false;
			adjacent_mines = 0;
		}
		
		//could use getter and setters all the way but seems a bit too complicated
	}

}