import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;

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
    const LogoFont = Application.loadResource(Rez.Fonts.LogoFont);
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

        var info = ActivityMonitor.getInfo();
        var valueSteps = info.steps * 100 / info.stepGoal;
        var valueCal = info.calories * 100 / 3000; 

        var bbIterator = getIterator();
        var sampleBb = bbIterator.next();
        var valueBodyBattery = 0;
        if (sampleBb != null) {
            valueBodyBattery = sampleBb.data;
        }

        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        simpleModel(dc, timeStringh, timeStringm, dateString, [[valueSteps, "1"],[valueBodyBattery, "3"],[valueCal, "2"],]);
    }

    function simpleModel(dc as Dc, hour as Text, min as Text, date as Text, rings as Array) as Void {
        var sizeFont = Graphics.getFontHeight(BoldFontLarge);
        var sizeLogoFont = Graphics.getFontHeight(LogoFont);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), BoldFontLarge, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), RegularFontLarge, min, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, TinyFont, date, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setPenWidth(5);
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        addRing(dc, dc.getWidth()/2, dc.getHeight()*7/8, rings[0][0], rings[0][1]);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        addRing(dc, dc.getWidth()/4, dc.getHeight()*3/4, rings[1][0], rings[1][1]);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        addRing(dc, dc.getWidth()*3/4, dc.getHeight()*3/4, rings[2][0], rings[2][1]);
    }

    function addRing(dc as Dc, x as Number, y as Number, value as Float, label as Text ) as Void{
        if (value == 0){
            value = 1;
        }
        var sizeLogoFont = Graphics.getFontHeight(LogoFont);
        var end = 90 + 360*value/100;
        if (end > 360){
            end = end -360;
        }
        dc.drawArc(x, y, 20, Graphics.ARC_COUNTER_CLOCKWISE, 90, end);
        dc.drawText(x, y - sizeLogoFont/2, LogoFont, label, Graphics.TEXT_JUSTIFY_CENTER);
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
