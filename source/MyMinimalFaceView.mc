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

    const IconsFont = Application.loadResource(Rez.Fonts.IconsFont);
    const LogoFont = Application.loadResource(Rez.Fonts.LogoFont);
    const BoldFontLarge = Application.loadResource(Rez.Fonts.BoldFontLarge);
    const RegularFontLarge = Application.loadResource(Rez.Fonts.RegularFontLarge);
    const BoldFont = Application.loadResource(Rez.Fonts.BoldFont);
    const RegularFont = Application.loadResource(Rez.Fonts.RegularFont);
    const TinyFont = Graphics.FONT_TINY;
    const XTinyFont = Graphics.FONT_XTINY;

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
        var valueActiveMinute = info.activeMinutesWeek.total * 100 / info.activeMinutesWeekGoal;
        var valueSteps = info.steps * 100 / info.stepGoal;
        var valueStepsKm = info.distance / (100*1000.0);    
        var infoh = Activity.getActivityInfo();
        var valueHeart = infoh.currentHeartRate;
        if (valueHeart == null){
            valueHeart = 0;
        } else {
            valueHeart = valueHeart /2; //max heart 200 bpm        
        }
        var bbIterator = getIterator();
        var sampleBb = bbIterator.next();
        var valueBodyBattery = 0;
        if (sampleBb != null) {
            valueBodyBattery = sampleBb.data;
        }
        var valueCal = info.calories * 100 / 3000; 
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        advanceModel(dc, timeStringh, timeStringm, dateString, [[valueBodyBattery, Graphics.COLOR_BLUE, Lang.format("$1$%", [valueBodyBattery.format("%d"), ]), "5"], [valueSteps, Graphics.COLOR_GREEN, Lang.format("$1$ Km", [valueStepsKm.format("%.1f"), ]), "2"], [valueHeart, Graphics.COLOR_RED, Lang.format("$1$ bpm", [(2 * valueHeart).format("%d"), ]), "4"], [valueActiveMinute, Graphics.COLOR_ORANGE, Lang.format("$1$ min", [info.activeMinutesWeek.total.format("%d"), ]), "1"], [valueCal, Graphics.COLOR_PINK, Lang.format("$1$ kCal", [valueCal.format("%d"), ]), "3"]]);
    }

    function simpleModel(dc as Dc, hour as Text, min as Text, date as Text) as Void {
        var sizeFont = 128;
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), BoldFontLarge, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), RegularFontLarge, min, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, Graphics.FONT_TINY, date, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function advanceModel(dc as Dc, hour as Text, min as Text, date as Text, values as Array) as Void {
        var penWidth = 8;
        var initLevel = 10;
        var sizeFont = Graphics.getFontHeight(BoldFont);
        var sizeFontDate = Graphics.getFontHeight(TinyFont);
        dc.drawText(dc.getWidth() -sizeFont, dc.getHeight()/2 - (sizeFont/2), BoldFont, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() -sizeFont, dc.getHeight()/2 - (sizeFont/2), RegularFont, min, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2 -20 + Math.sqrt((Math.pow(dc.getWidth()/2, 2) - Math.pow((sizeFont/2), 2))), dc.getHeight()/2 - (sizeFont/2), TinyFont, date, Graphics.TEXT_JUSTIFY_RIGHT);
        for (var i = 0; i < values.size(); i++) {
            lineColor(dc, values[i][1], values[i][0], 270, Math.toDegrees(Math.asin((sizeFont/2 + sizeFontDate/2) *1.0/ (dc.getHeight()/2 -initLevel))), dc.getHeight()/2 -initLevel, penWidth, values[i][2], values[i][3]);
            initLevel = initLevel + 12;
        }
    }

    function lineColor(dc as Dc, color as Graphics.ColorValue, value as Float, start as Decimal, end as Decimal, level as Number, penWidth as Number, valueString as Text, valueLogo as Text) as Void {
        var delta = (start - end)/100.0;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(penWidth);
        var val = value;
        if (value < 0) {
            val = 0;
        }
        if (value > 100){
            val = 100;
        }
        end = start - delta * val;
        if (start > end) {
            dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, level, Graphics.ARC_CLOCKWISE, start, end);
            dc.fillCircle(Math.cos(Math.toRadians(start))*level + dc.getWidth()/2, Math.sin(Math.toRadians(start))*level*-1 + dc.getHeight()/2, penWidth/2 -1);
            dc.fillCircle(Math.cos(Math.toRadians(end))*level + dc.getWidth()/2, Math.sin(Math.toRadians(end))*level*-1 + dc.getHeight()/2, penWidth/2 -1);
        }
        dc.drawText(dc.getWidth()/2 +5, dc.getHeight()/2 + level - Graphics.getFontHeight(XTinyFont)/2 +2, LogoFont, valueLogo, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2 + Graphics.getFontHeight(XTinyFont), dc.getHeight()/2 + level - Graphics.getFontHeight(XTinyFont)/2, XTinyFont, valueString, Graphics.TEXT_JUSTIFY_LEFT);
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
