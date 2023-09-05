import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;


class MyMinimalFaceView extends WatchUi.WatchFace {

    const IconsFont = Application.loadResource(Rez.Fonts.IconsFont);
    const BoldFontLarge = Application.loadResource(Rez.Fonts.BoldFontLarge);
    const RegularFontLarge = Application.loadResource(Rez.Fonts.RegularFontLarge);
    const BoldFont = Application.loadResource(Rez.Fonts.BoldFont);
    const RegularFont = Application.loadResource(Rez.Fonts.RegularFont);

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

        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        advanceModel(dc, timeStringh, timeStringm, dateString);
        
        // Call the parent onUpdate function to redraw the layout
        if (System.getSystemStats().battery < 10) {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            if (System.getSystemStats().battery < 5) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(dc.getWidth()*4/8, dc.getHeight()*11/16, IconsFont, "9", Graphics.TEXT_JUSTIFY_CENTER);
        }        
    }

    function simpleModel(dc as Dc, hour as Text, min as Text, date as Text) as Void {
        var sizeFont = 128;
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), BoldFontLarge, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - (sizeFont/2), RegularFontLarge, min, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, Graphics.FONT_TINY, date, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function advanceModel(dc as Dc, hour as Text, min as Text, date as Text) as Void {
        var sizeFont = 96;
        dc.drawText(dc.getWidth() -sizeFont, dc.getHeight()/2 - (sizeFont/2), BoldFont, hour, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() -sizeFont, dc.getHeight()/2 - (sizeFont/2), RegularFont, min, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2 -20 + Math.sqrt((Math.pow(dc.getWidth()/2, 2) - Math.pow((sizeFont/2), 2))), dc.getHeight()/2 - (sizeFont/2), Graphics.FONT_TINY, date, Graphics.TEXT_JUSTIFY_RIGHT);
        lineColor(dc, Graphics.COLOR_ORANGE, 100, 270, 35, dc.getHeight()/2 -15, 10);
        lineColor(dc, Graphics.COLOR_GREEN, 100, 270, 50, dc.getHeight()/2 -30, 10);
        lineColor(dc, Graphics.COLOR_BLUE, 100, 270, 50, dc.getHeight()/2 -45, 10);
        lineColor(dc, Graphics.COLOR_PURPLE, 100, 270, 50, dc.getHeight()/2 -60, 10);
        System.println(Math.toDegrees(Math.acos(Math.sqrt((Math.pow(dc.getWidth()/2, 2) - Math.pow((sizeFont/2 + 20), 2)))/(dc.getWidth()/2))));
    }

    function lineColor(dc as Dc, color as Graphics.ColorValue, value as Float, start as Decimal, end as Decimal, level as Number, penWidth as Number) as Void {
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
        dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, level, Graphics.ARC_CLOCKWISE, start, start - delta * val);
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
