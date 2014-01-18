package view 
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.TextEvent;
	import model.*;
	import controller.*;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	
	
	
	public class MSView extends Sprite
	{
		private var _model:MSModel;
		private var _controller:MSController;
		private var _gameInstance:MovieClip;
		private var _rect:Shape;
		private var _screen:Array;
		private var _container:Sprite;
		private var in_game:Boolean;
		
		//color variables
		private var not_revealed_grey:uint = 0x888888;
		private var revealed_grey:uint = 0xCCCCCC;
		private var blue:uint = 0x0000FF;
		private var red:uint = 0xFF0000;
		private var green:uint = 0x00FF00;
		private var purple:uint = 0xFF00FF;
		private var orange:uint = 0xF4661B;
		
		//game launch variable
		private var EASYGAME:Number = 1;
		private var MEDIUMGAME:Number = 2;
		private var HARDGAME:Number = 3;
		
		//window size related variables
		private var game_button_width:Number = 25;
		private var game_button_height:Number = 25;
		private var container_pos_withgrid_x:Number = 20;
		private var container_pos_withgrid_y:Number = 20;
		private var container_pos_withoutgrid_x:Number = 280;
		private var container_pos_withoutgrid_y:Number = 200;
		
		
		public function MSView(model:MSModel) 
		{
			_model = model;
			trace("view created");
			
			_container = new Sprite();
			in_game = false;
		}
		
		
		///////////////////////////
		//Game Screen
		public function game_screen():void 
		{
			//this in_game boolean allows us to know if the game is over or not
			if (!in_game) {
				return;
			}
			var x:Number; //columns variable
			var y:Number; //rows variable
			var to_print:String; //buffer about what should be printed in the tile
			var size:Number = _model._size;
			var color:uint; //the color of the tile
			
			clear_screen();
			_container.x = container_pos_withgrid_x;
			_container.y = container_pos_withgrid_y;
			_screen = new Array();
			
			//for each element
			for (x = 0; x < size; x++) {
				for (y = 0; y < size; y++) {
					to_print = "";
					//set the default color
					color = not_revealed_grey;
					//if its revealed, change the color and print the number of adjacent mines
					if (_model._grid[x][y].is_revealed) {
						color = revealed_grey;
						if (_model._grid[x][y].adjacent_mines != 0) {
							to_print = String(_model._grid[x][y].adjacent_mines);
						}
					}
					//if its marked, print "?"
					else if (_model._grid[x][y].is_marked) {
						to_print = "?";
						color = orange;
					}
					//create the button
					_screen.push(rect_with_text(x * game_button_width, y * game_button_height, 
												game_button_width, game_button_height, color, to_print));
					//add the handler to the button
					_screen[y + x * size].addEventListener(MouseEvent.CLICK, click_handler);
				}
			}
			//add the main container to the screen
			addChild(_container);
		}
		
		//click handler for game screen
		public function click_handler(e:MouseEvent):void {
			//handle clicks
			var position_x:Number;
			var position_y:Number;
			
			position_x = Math.floor(e.localX / game_button_width);
			position_y = Math.floor(e.localY / game_button_height);
			
			if (e.ctrlKey) {
				_controller.mark(position_x, position_y);
			}
			else {
				_controller.reveal(position_x, position_y);
			}
			game_screen();
		}
		
		
		///////////////////////////
		//Starting screen
		public function starting_screen(controller:MSController):void 
		{
			in_game = false;
			//get the controller
			_controller = controller;
			//clear the screen (for multiple games)
			clear_screen();
			//center the starting screen
			_container.x = container_pos_withoutgrid_x;
			_container.y = container_pos_withoutgrid_y;
			//print the rules
			var rules:TextField = new TextField;
			rules.x = 10;
			rules.y = 20;
			rules.text = "The rules:\n"
				+ "click to discover a mine\n"
				+ "Ctrl click to mark a mine\n\n"
				+ "Choose your level";
			rules.autoSize = TextFieldAutoSize.LEFT;
			rules.width = rules.textWidth;
			rules.height = rules.textHeight;
			_container.addChild(rules);
			
			//easy button
			var b_easy:Sprite = rect_with_text(0, 120, 75, 25, green, "easy");
			b_easy.addEventListener(MouseEvent.CLICK, bClick);
			
			//medium button
			var b_medium:Sprite = rect_with_text(75, 120, 75, 25, blue, "medium");
			b_medium.addEventListener(MouseEvent.CLICK, bClick);
			
			//hard button
			var b_hard:Sprite = rect_with_text(150, 120, 75, 25, red, "hard");
			b_hard.addEventListener(MouseEvent.CLICK, bClick);	
			
			addChild(_container);
			
			//click event on buttons for choosing difficulty
			function bClick(e:MouseEvent):void {
				if (e.currentTarget == b_easy) {
					trace("starting game in easy mode");
					//launch game easy
					in_game = true;
					_controller.launch_game(EASYGAME);
				}
				else if (e.currentTarget == b_medium) {
					trace("starting game in medium mode");
					//launch game medium
					in_game = true;
					_controller.launch_game(MEDIUMGAME);
				}
				else if (e.currentTarget == b_hard) {
					trace("starting game in hard mode");
					//launch game hard
					in_game = true;
					_controller.launch_game(HARDGAME);
				}
				game_screen();
			}
		}
		
		///////////////////////////
		//Play again screen
		public function play_again(result:Number):void 
		{
			in_game = false;
			//clear screen
			clear_screen();
			_container.x = container_pos_withgrid_x;
			_container.y = container_pos_withgrid_y;
			
			//show where are the mines
			var x:Number; //columns variable
			var y:Number; //rows variable
			var to_print:String; //text on the middle of the button
			var size:Number = _model._size;
			var color:uint;
			_screen = new Array();
			
			for (x = 0; x < size; x++) {
				for (y = 0; y < size; y++) {
					to_print = "";
					//set the default color
					color = not_revealed_grey;
					//if its revealed, change the color and print the number of adjacent mines
					if (_model._grid[x][y].is_revealed) {
						color = revealed_grey;
						if (_model._grid[x][y].adjacent_mines != 0) {
							to_print = String(_model._grid[x][y].adjacent_mines);
						}
					}
					//if its marked, print "?"
					else if (_model._grid[x][y].is_marked) {
						to_print = "?";
						color = orange;
					}
					if (_model._grid[x][y].is_mine) {
						to_print = "X";
						if (result == 1) {
							color = green;
						}
						else {
							color = red;
						}
					}
					//create the button
					_screen.push(rect_with_text(x * game_button_width, y * game_button_height, 
												game_button_width, game_button_height, color, to_print));
					//add the handler to the button (filling by columns)
					_screen[y + x * size].addEventListener(MouseEvent.CLICK, click_handler);
				}
			}
			
			
			//play again?
			var pa:TextField = new TextField;
			pa.x = _model._size*25+40;
			pa.y = 50;
			if (result == 1) {
				pa.text = "Congratulations!!! You won.\n\nWould you like to play again?";
			}
			else {
				pa.text = "Boom!!!!\nYou lost!\n\nWould you like to play again?";
			}
			
			pa.autoSize = TextFieldAutoSize.LEFT;
			pa.width = pa.textWidth;
			pa.height = pa.textHeight;
			_container.addChild(pa);
			
			//yes button
			var b_yes:Sprite = rect_with_text(_model._size*25+20, 130, 75, 25, green, "Play again");
			b_yes.addEventListener(MouseEvent.CLICK, start_game);
			
			//no button
			var b_no:Sprite = rect_with_text(_model._size*25+20+75, 130, 75, 25, purple, "Quit");
			b_no.addEventListener(MouseEvent.CLICK, quit);
			addChild(_container);
			
			
			//function to handle answer
			function start_game(e:MouseEvent):void 
			{
				_controller.start_game();
			}
			function quit(e:MouseEvent):void 
			{
				_controller.quit();
			}
		}
		
		
		//create rectangle with text inside at given position, with given size with given color.
		public function rect_with_text(x:Number, y:Number, width:Number, height:Number, color:uint, text:String):Sprite {
			//create the rectangle
			var b_sprite:Sprite = new Sprite;
			b_sprite.graphics.beginFill(color, 1);
			b_sprite.graphics.drawRoundRect(x, y, width, height, 5);
			b_sprite.graphics.endFill();
			//add it to our main container
			_container.addChild(b_sprite);
			//be a button
			b_sprite.buttonMode = true;
			b_sprite.mouseChildren = false;
			//add the events for shade to our button
			b_sprite.addEventListener(MouseEvent.ROLL_OVER, bOver);
			b_sprite.addEventListener(MouseEvent.ROLL_OUT, bOut);
			//create, fill and size the text
			var b_sprite_txt:TextField = new TextField;
			b_sprite_txt.text = text;
			b_sprite_txt.autoSize = TextFieldAutoSize.LEFT;
			b_sprite_txt.width = b_sprite_txt.textWidth;
			b_sprite_txt.height = b_sprite_txt.textHeight;
			b_sprite_txt.x = x+width/2-b_sprite_txt.textWidth/2;
			b_sprite_txt.y = y + height / 2 - b_sprite_txt.textHeight / 2;
			//add the text to the button
			b_sprite.addChild(b_sprite_txt);
			//return the rect
			return b_sprite;
		}
	
		//shade events on buttons
		public function bOver(e:MouseEvent):void {
			e.target.alpha = .8;
		}
		
		public function bOut(e:MouseEvent):void {
			e.target.alpha = 1;
		}
		
		//cleaning the screen  before the game starts
		//TODO must be a way cleaner way to do this
		public function clear_screen():void {
			while(_container.numChildren)
			{
					_container.removeChildAt(0);
			}
		}
	}

}