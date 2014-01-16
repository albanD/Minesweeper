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
		private var _is_displayed:String; //flag saying who is using the screen (the game do not refresh the screen again if you lost or win)
		
		//color variables
		private var not_revealed_grey:uint = 0x888888;
		private var revealed_grey:uint = 0xCCCCCC;
		private var blue:uint = 0x0000FF;
		private var red:uint = 0xFF0000;
		private var green:uint = 0x00FF00;
		private var purple:uint = 0xFF00FF;
		private var orange:uint = 0xF4661B;
		
		public function MSView(model:MSModel) 
		{
			_model = model;
			trace("view created");
			
			_container = new Sprite();
			_is_displayed = "game";
		}
		
		
		///////////////////////////
		//Game Screen
		public function game_screen():void 
		{
			if (_is_displayed != "game") {
				return;
			}
			var x:Number; //loop variable
			var y:Number; //loop variable
			var to_print:String; //text on the middle of the button
			var size:Number = _model._size; //the size of the model (shorter than _model._size)
			var color:uint; //color to print
			
			clear_screen();
			_container.x = 20;
			_container.y = 20;
			_screen = new Array();
			
			//for each element
			for (x = 0; x < size; x++) {
				for (y = 0; y < size; y++) {
					to_print = "";
					//set the default color
					color = not_revealed_grey;
					//if its revealed, change the color and print the number of adjacent mines
					if (_model._grid[y + x * size][1] == 1) {
						color = revealed_grey;
						if (_model._grid[y + x * size][0] !=0) {
							to_print = String(_model._grid[y + x * size][0]);
						}
					}
					//if its marked, print "?"
					else if (_model._grid[y + x * size][1] == 2) {
						to_print = "?";
						color = orange;
					}
					//create the button
					_screen.push(rect_with_text(y * 25, x * 25, 25, 25, color, to_print));
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
			
			position_x = Math.floor(e.localX / 25);
			position_y = Math.floor(e.localY / 25);
			
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
			_is_displayed = "starting";
			//get the controller
			_controller = controller;
			//clear the screen (for multiple games)
			clear_screen();
			//center the starting screen
			_container.x = 280;
			_container.y = 200;
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
					_is_displayed = "game";
					_controller.launch_game(1);
				}
				else if (e.currentTarget == b_medium) {
					trace("starting game in medium mode");
					//launch game medium
					_is_displayed = "game";
					_controller.launch_game(2);
				}
				else if (e.currentTarget == b_hard) {
					trace("starting game in hard mode");
					//launch game hard
					_is_displayed = "game";
					_controller.launch_game(3);
				}
				game_screen();
			}
		}
		
		///////////////////////////
		//Play again screen
		public function play_again(result:Number):void 
		{
			_is_displayed = "replay";
			//clear screen
			clear_screen();
			_container.x = 20;
			_container.y = 20;
			
			//show where are the mines
			var x:Number; //loop variable
			var y:Number; //loop variable
			var to_print:String; //text on the middle of the button
			var size:Number = _model._size; //the size of the model (shorter than _model._size)
			var color:uint;
			_screen = new Array();
			for (x = 0; x < size; x++) {
				for (y = 0; y < size; y++) {
					to_print = "";
					//set the default color
					color = not_revealed_grey;
					if (_model._grid[y + x * size][1] == 1) {
						color = revealed_grey;
						if (_model._grid[y + x * size][0] !=0) {
							to_print = String(_model._grid[y + x * size][0]);
						}
					}
					else if (_model._grid[y + x * size][1] == 2) {
						to_print = "?";
						color = orange;
					}
					if (_model._grid[y + x * size][0] == 9) {
						to_print = "X";
						if (result == 1) {
							color = green;
						}
						else {
							color = red;
						}
					}
					_screen.push(rect_with_text(y * 25, x * 25, 25, 25, color, to_print));
					_screen[y + x * size].addEventListener(MouseEvent.CLICK, click_handler);
				}
			}
			
			//play again?
			var pa:TextField = new TextField;
			pa.x = _model._size*25+40;
			pa.y = 50;
			pa.autoSize = TextFieldAutoSize.LEFT;
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
			
			
			//function to handle answer because there is an argument
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
			//add the events to our button
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