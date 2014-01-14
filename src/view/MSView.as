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
		
		public function MSView(model:MSModel, controller:MSController) 
		{
			_model = model;
			_controller = controller;
			trace("view created");
			
			_container = new Sprite();	
		}
		
		public function game_screen():void 
		{
			var x:Number; //loop variable
			var y:Number; //loop variable
			var to_print:String; //text on the middle of the button
			var size:Number = _model._size; //the size of the model (shorter than _model._size)
			
			clear_screen();
			_screen = new Array();
			
			for (x = 0; x < size; x++) {
				for (y = 0; y < size; y++) {
					to_print = "";
					if (_model._grid[y + x * size][1] == 1) {
						to_print = String(_model._grid[y + x * size][0]);
					}
					if (_model._grid[y + x * size][1] == 2) {
						to_print = "?";
					}
					_screen.push(rect_with_text(y * 25, x * 25, 25, 25, 0xAAAAAA, to_print));
					_screen[y + x * size].addEventListener(MouseEvent.CLICK, click_handler);
				}
			}
			addChild(_container);
		}
		
		
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
		
		
		public function starting_screen():void 
		{
			_container.x = 280;
			_container.y = 200;
			var rules:TextField = new TextField;
			rules.x = 10;
			rules.y = 20;
			rules.width = 200;
			rules.height = 200;
			rules.text = "The rules:\n"
				+ "click to discover a mine\n"
				+ "Ctrl click to mark a mine\n\n"
				+ "Choose your level";
			_container.addChild(rules);
			
			//easy button
			var b_easy:Sprite = rect_with_text(0, 120, 75, 25, 0x00FF00, "easy");
			b_easy.addEventListener(MouseEvent.CLICK, bClick);
			
			//medium button
			var b_medium:Sprite = rect_with_text(75, 120, 75, 25, 0x0000FF, "medium");
			b_medium.addEventListener(MouseEvent.CLICK, bClick);
			
			//hard button
			var b_hard:Sprite = rect_with_text(150, 120, 75, 25, 0xFF0000, "hard");
			b_hard.addEventListener(MouseEvent.CLICK, bClick);	
			
			addChild(_container);
			
			//click event on buttons for choosing difficulty
			function bClick(e:MouseEvent):void {
				if (e.currentTarget == b_easy) {
					trace("starting game in easy mode");
					//launch game easy
					_controller.start_game(1);
				}
				else if (e.currentTarget == b_medium) {
					trace("starting game in medium mode");
					//launch game medium
					_controller.start_game(2);
				}
				else if (e.currentTarget == b_hard) {
					trace("starting game in hard mode");
					//launch game hard
					_controller.start_game(3);
				}
				game_screen();
			}
		}
		
		//create rectangle with text inside
		public function rect_with_text(x:Number, y:Number, width:Number, height:Number, color:uint, text:String):Sprite {
			var b_sprite:Sprite = new Sprite;
			b_sprite.graphics.beginFill(color, 1);
			b_sprite.graphics.drawRoundRect(x, y, width, height, 5);
			b_sprite.graphics.endFill();
			_container.addChild(b_sprite);
			b_sprite.buttonMode = true;
			b_sprite.mouseChildren = false;
			// first we add the events to our button
			b_sprite.addEventListener(MouseEvent.ROLL_OVER, bOver);
			b_sprite.addEventListener(MouseEvent.ROLL_OUT, bOut);
			var b_sprite_txt:TextField = new TextField;
			b_sprite_txt.text = text;
			b_sprite_txt.autoSize = TextFieldAutoSize.LEFT;
			b_sprite_txt.width = b_sprite_txt.textWidth;
			b_sprite_txt.height = b_sprite_txt.textHeight;
			b_sprite_txt.x = x+width/2-b_sprite_txt.textWidth/2;
			b_sprite_txt.y = y+height/2-b_sprite_txt.textHeight/2;
			b_sprite.addChild(b_sprite_txt);
			
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