package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mochi.as3.*
	import flash.net.*
	
	public dynamic class Game extends MovieClip{
		static var kongregate:*
		
		static var ship:MovieClip;
		static var enemyShipTimer:Timer;
		static var weaponTimer:Timer;
		static var scoreText:TextField;
		static var score:Number = 0;
		static var healthMeter:HealthMeter;
		static var enemyHealthMeter:EnemyHealthMeter;
		static var gameOverMenu:GameOverMenu;
		static var creditsMenu:CreditsMenu;
		static var startMenu:StartMenu;
		static var powerUpTimer:Timer;
		static var moreWingmenTimer:Timer;
		static var miniBossTimer:Timer;
		//static var towerBossTimer:Timer;
		static var towerBossCountdown:Number;
		static var bossCountdown:Number;
		static var music = new BackgroundMusic();
		static var musicChannel;
		static var shieldSound2 = new ShieldSound2;
		static var shieldChannel;
		
		static var kills = 0;
		static var misses = 0;
		static var gameComplete = 0;
		static var gameInitialized:Boolean = true;
				
		public function loadAPI(){
		  var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
		  var api_url:String = paramObj.api_path ||  "http://www.kongregate.com/flash/API_AS3_Local.swf";
		  var request:URLRequest = new URLRequest ( api_url );
		  var loader:Loader = new Loader();
		  loader.contentLoaderInfo.addEventListener ( Event.COMPLETE, apiLoadComplete );
		  loader.load ( request );
		  this.addChild ( loader );
		}
		public function apiLoadComplete( event:Event ):void {
			kongregate = event.target.content;
			kongregate.services.connect();
			
			kongregate.stats.submit("score", score);
			kongregate.stats.submit("kills", kills);
			kongregate.stats.submit("misses", misses);
			kongregate.stats.submit("gameComplete", gameComplete);
		}
				
		public function onConnectError(status:String):void {
		// handle error here...
			if(!gameInitialized) {initializeGame();}
		}
		
		function Game() {
			//var _mochiads_game_id:String = "dcbe9b807ff7322e";
			//mochi.as3.MochiServices.connect("dcbe9b807ff7322e", root, onConnectError);  // use mochi.as2.MochiServices.connect for AS2 API
			//MochiAd.showPreGameAd({clip:root, id:"dcbe9b807ff7322e", res:"600x300", ad_finished: initializeGame});
			//loadAPI();  // for Kongregate
			
			//uncomment updatescore and above lines and remove the one below to turn on kong and mochi
			initializeGame();
					
		}
				
		function initializeGame(){
			Key.initialize(stage);
			
			ship = new Ship();
			ship.x = 300;
			ship.y = 150;
			ship.visible = false;
			ship.shield.visible = false;
			addChild(ship);
			
			enemyShipTimer = new Timer(1500);
			enemyShipTimer.addEventListener("timer", sendEnemy);
			//enemyShipTimer.start();
			
			miniBossTimer = new Timer(10000);
			miniBossTimer.addEventListener("timer", sendMiniBoss);
			
			//towerBossCountdown = 3;
			//bossCountdown = 8;
			
			powerUpTimer = new Timer(6000);
			powerUpTimer.addEventListener("timer", sendPowerUp);
			//powerUpTimer.start();
			
			weaponTimer = new Timer(9000);
			weaponTimer.addEventListener("timer", sendWeapon);
			
			moreWingmenTimer = new Timer(25000);
			moreWingmenTimer.addEventListener("timer", sendMoreWingmen);
			
			scoreText = new TextField();
			scoreText.x = 290;
			scoreText.text = String(0);
			scoreText.visible = false;
			addChild(scoreText);
			
			var scoreFormat = new TextFormat("Comic Sans MS", 20, 0x000000);
			scoreText.defaultTextFormat = scoreFormat;
			
			healthMeter = new HealthMeter();
			healthMeter.x = 10;
			healthMeter.y = 10;
			addChild(healthMeter);
			healthMeter.visible = false;
			
			enemyHealthMeter = new EnemyHealthMeter();
			enemyHealthMeter.x = 530;
			enemyHealthMeter.y = 10;
			addChild(enemyHealthMeter);
			enemyHealthMeter.visible = false;
			
			startMenu = new StartMenu();
			startMenu.x = 52;
			startMenu.y = 45;
			addChild(startMenu);
			startMenu.visible = true;
			
			creditsMenu = new CreditsMenu();
			creditsMenu.x = 52;
			creditsMenu.y = 45;
			addChild(creditsMenu);
			creditsMenu.visible = false;
			
			
			creditsMenu.closeCreditsButton.addEventListener("mouseDown", hideCredits);
			startMenu.playButton.addEventListener("mouseDown", newGame);
			startMenu.creditsButton.addEventListener("mouseDown", showCredits);
			
			gameOverMenu = new GameOverMenu();
			gameOverMenu.x = 80;
			gameOverMenu.y = 35;
			addChild(gameOverMenu);
			gameOverMenu.visible = false;
			gameOverMenu.playAgainButton.addEventListener("mouseDown", newGame); 
			resetScore();
			gameInitialized = true;
		}
					
		static function updateScore(points){
			score += points;
			scoreText.text = String(score);
			//kongregate.stats.submit("score", score);
			//kongregate.stats.submit("kills", kills);
			//kongregate.stats.submit("misses", misses);
			//kongregate.stats.submit("gameComplete", gameComplete);
		}
		
		static function resetScore(){
			score = 0;
			kills = 0;
			misses = 0;
			gameComplete = 0;
			scoreText.text = String(score);
			scoreText.visible = true;
		}
				
		static function newGame(e:Event){
			mochi.as3.MochiEvents.startPlay();
			
			resetScore();
			gameOverMenu.visible = false;
			startMenu.visible = false;
			healthMeter.visible = true;
			ship.health = ship.maxHealth;
			ship.shaking = false;
			ship.rotation = 0;
			healthMeter.bar.scaleX = 1;
			ship.visible = true;
			ship.x = 300;
			ship.y = 150;
			
			ship.addEventListener("enterFrame", ship.move);
			enemyShipTimer.start();
			miniBossTimer.start();
			//towerBossTimer.start();
			towerBossCountdown = 3;
			bossCountdown = 8;
			powerUpTimer.start();
			weaponTimer.start();
			moreWingmenTimer.start();
			Wingman.maxWingmen = 2;
			musicChannel = music.play(0,1000);
		}
		
		static function gameOver(){
			var efficiency;
			var effBonus;
			Game.ship.visible = false;
			Game.enemyHealthMeter.visible = false;
			gameOverMenu.visible = true;
			gameOverMenu.baseScore.text = score.toString();
			gameOverMenu.kills.text = kills.toString();
			gameOverMenu.killBonus.text = (kills*20).toString();
			efficiency = Math.floor(100*kills/(misses + kills));
			effBonus = Math.round(10000 / (100-efficiency)) / 100;
			if (effBonus == Infinity) { effBonus = 10; }
			gameOverMenu.efficiency.text = efficiency.toString();
			gameOverMenu.multiplier.text = effBonus.toString();
			score += (kills * 50);
			score = Math.floor(score*effBonus);
			gameOverMenu.finalScore.text = score.toString();
			

			for(var i in EnemyShip.list){
				EnemyShip.list[i].destroy();
			}
			while (Wingman.list.length > 0) {
				for(var j in Wingman.list){
					Wingman.list[j].kill();
					//Wingman.list = [];
				}
			}
			enemyShipTimer.stop();
			miniBossTimer.stop();
			//towerBossTimer.stop();
			powerUpTimer.stop();
			weaponTimer.stop();
			musicChannel.stop();
			updateScore(0); // reports to Kong
		}
		
		function showCredits(e:Event) {
			creditsMenu.visible = true;
		}
		function hideCredits(e:Event) {
			creditsMenu.visible = false;
		}
		
		function sendEnemy(e:Event){
			var enemy = new EnemyShip();
			stage.addChild(enemy);
		}
		function sendMiniBoss(e:Event){ //Also handles other bosses
			
			miniBossTimer.stop();  //restart it when it's dead
			if(bossCountdown == 0) {
				
				var boss = new Boss();
				stage.addChild(boss);
				bossCountdown = 8;
			}else{
				bossCountdown -= 1;
				if(towerBossCountdown == 0){
					sendTowerBoss();
					if(bossCountdown <= 3) {
						var miniBossToo = new MiniBoss(); // Yes, both at once!
						stage.addChild(miniBossToo);
					}
					towerBossCountdown = 3;
				} else{
					towerBossCountdown -= 1;
					var miniBoss = new MiniBoss();
					stage.addChild(miniBoss);
				}
			}
		}
		function sendTowerBoss(){
			var towerBoss = new TowerBoss;
			stage.addChild(towerBoss);
		}
		function sendPowerUp(e:Event){
			var powerUp = new PowerUp();
			stage.addChild(powerUp);
		}
		
		function sendWeapon(e:Event){
			var weapon = new Weapon();
			stage.addChild(weapon);
		}
		
		function sendMoreWingmen(e:Event){
			var moreWingmen = new MoreWingmen();
			stage.addChild(moreWingmen);
		}

	}
	
}
