package view 
{
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
		
		public function MSView(model:MSModel, controller:MSController) 
		{
			_model = model;
			_controller = controller;
			trace("view created");
			starting_screen();
			
			/*
			_gameInstance = new MovieClip();
			addChild(_gameInstance);
			
			_rect = new Shape;
			_rect.graphics.beginFill(0x777777);
			_rect.graphics.drawRoundRect(60, 60, 100, 100, 10);
			_rect.graphics.endFill();
			addChild(_rect);	
			*/			
		}
		
		
		private function starting_screen():void 
		{
			var rules:TextField = new TextField;
			rules.x = 10;
			rules.y = 20;
			rules.width = 200;
			rules.height = 200;
			rules.text = "The rules:\n"
				+ "click to discover a mine\n"
				+ "Ctrl click to mark a mine\n\n"
				+ "Choose your level";
			addChild(rules);
			
			//easy button
			var b_easy:Sprite = rect_with_text(0, 120, 0x00FF00, "easy");
			b_easy.addEventListener(MouseEvent.CLICK, bClick_easy);
			
			//medium button
			var b_medium:Sprite = rect_with_text(75, 120, 0x0000FF, "medium");
			b_medium.addEventListener(MouseEvent.CLICK, bClick_medium);
			
			//hard button
			var b_hard:Sprite = rect_with_text(150, 120, 0xFF0000, "hard");
			b_hard.addEventListener(MouseEvent.CLICK, bClick_hard);
			
			
			//create rectangle
			function rect_with_text(x:Number, y:Number, color:uint, text:String):Sprite {
				var b_sprite:Sprite = new Sprite;
				b_sprite.graphics.beginFill(color, 1);
				b_sprite.graphics.drawRoundRect(x, y, 75, 30, 10);
				b_sprite.graphics.endFill();
				addChild(b_sprite);
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
				b_sprite_txt.x = x+75/2-b_sprite_txt.textWidth/2;
				b_sprite_txt.y = y+5;
				b_sprite.addChild(b_sprite_txt);
				
				return b_sprite;
			}
						
			//click event on buttons
			function bClick_easy(e:MouseEvent):void {
				trace("starting game in easy mode");
				//launch game easy
			}
			function bClick_medium(e:MouseEvent):void {
				trace("starting game in medium mode");
				//launch game medium
			}
			function bClick_hard(e:MouseEvent):void {
				trace("starting game in hard mode");
				//launch game hard
			}
			
						
		}
		
		//shade events on buttons
		public function bOver(e:MouseEvent):void {
			e.target.alpha = .5;
		}
		
		public function bOut(e:MouseEvent):void {
			e.target.alpha = 1;
		}
	}

}