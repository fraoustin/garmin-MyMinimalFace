import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;

function getIterator() {
    // Check device for SensorHistory compatibility
    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
        // Set up the method with parameters
        return Toybox.SensorHistory.getBodyBatteryHistory({});
    }
    return null;
}

class MyMinimalFaceView extends WatchUi.WatchFace {

    const BoldFontLarge = Application.loadResource(Rez.Fonts.BoldFontLarge);
    const RegularFontLarge = Application.loadResource(Rez.Fonts.RegularFontLarge);
    const TinyFont = Graphics.FONT_TINY;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var timeStringh = Lang.format("$1$", [clockTime.hour, ]);
        var timeStringm = Lang.format("$1$", [clockTime.min.format("%02d"), ]);
        var dateString = Lang.format("$1$ $2$", [clockTime.day_of_week, clockTime.day]);
        var value = System.getSystemStats().battery;
        var color = Graphics.COLOR_WHITE;
        if (value < 10) {
            color = Graphics.COLOR_ORANGE;
        }
        if (value < 5) {
            color = Graphics.COLOR_RED;
        }

        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        simpleModel(dc, timeStringh, timeStringm, dateString, color);
    }

    function simpleModel(dc as Dc, hour as Text, min as Text, date as Text, color as Graphics.ColorValue) as Void {
        var sizeFont = Graphics.getFontHeight(BoldFontLarge);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, TinyFont, date, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), BoldFontLarge, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), RegularFontLarge, min, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function onPartialUpdate(dc as Dc) as Void {
    }


    function onShow() as Void {
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }
    
    function onEnterSleep() as Void {
    }

}
