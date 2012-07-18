package
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    
    import mochi.as3.*;
    import ui.*;
    
    public class Ads
    {
        private static const MARGINS:int = 4;
        private static var _container:DisplayObjectContainer;
        private static var _ad:MovieClip;
        
        public static function init( container:* ):void
        {
            _container = container;
        }
        
        public static function get menu():Menu
        {            
            var items:Array = [
                new MenuItem( showClickAway, 'Show click-away ad' ),
                new MenuItem( hideAd, 'Hide click-away ad' ),
                new MenuItem( showInterLevel, 'Show inter-level ad' ),
                new MenuItem( returnToMain, 'Return to Main Menu' )
            ];

            return new Menu( 'MochiAds API Demonstration', items );
        }
        
        private static function showClickAway( e:* = null ):void
        {
            if( _ad )
                return ;
            
            _ad = new MovieClip();
            _ad.x = _container.stage.stageWidth - 300 - MARGINS;
            _ad.y = MARGINS;
            _container.addChild( _ad );
            
            MochiAd.showClickAwayAd( {
                id: Init.AD_ID,             // This is the game ID for displaying ads!
                clip: _ad                   // We are displaying in a container (which is dynamic)
            } );
        }
        
        private static function hideAd( e:* = null ):void
        {
            if( !_ad )
                return ;

            MochiAd.unload(_ad);

            _container.removeChild(_ad);
            _ad = null;
        }
        
        private static function showInterLevel( e:* = null ):void
        {
            if( _ad )
                hideAd();

            Core.hideMenu();
                
            _ad = new MovieClip();
            _container.addChild( _ad );
            
            MochiAd.showInterLevelAd( {
                id: Init.AD_ID,             // This is the game ID for displaying ads!
                clip: _ad,                  // We are displaying in a container (which is dynamic)
                ad_finished: returnToMain   // Ad has completed
            } );
        }
        
        private static function returnToMain( e:* = null ):void
        {
            hideAd();

            Core.returnToMain();
        }
    }
}