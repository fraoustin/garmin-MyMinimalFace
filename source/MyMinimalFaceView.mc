import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;


class MyMinimalFaceView extends WatchUi.WatchFace {

    const IconsFont = Application.loadResource(Rez.Fonts.IconsFont);
    const BoldFont = Application.loadResource(Rez.Fonts.BoldFont);
    const RegularFont = Application.loadResource(Rez.Fonts.RegularFont);

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        // hour
        var timeStringh = Lang.format("$1$", [clockTime.hour, ]);
        var viewh = View.findDrawableById("TimeLabelHour") as Text;
        viewh.setFont(BoldFont);
        viewh.setText(timeStringh);
        viewh.setLocation(dc.getWidth()/2, WatchUi.LAYOUT_VALIGN_CENTER);
        // minute
        var timeStringm = Lang.format("$1$", [clockTime.min.format("%02d"), ]);
        var viewm = View.findDrawableById("TimeLabelMinute") as Text;
        viewm.setFont(RegularFont);
        viewm.setText(timeStringm);
        viewm.setLocation(dc.getWidth()/2, WatchUi.LAYOUT_VALIGN_CENTER);
        // date
        var dateString = Lang.format("$1$ $2$", [clockTime.day_of_week, clockTime.day]);
        var viewd = View.findDrawableById("TimeLabelDate") as Text;
        viewd.setText(dateString);
        viewd.setLocation(dc.getWidth()/2, dc.getHeight()/4);
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (System.getSystemStats().battery < 10) {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            if (System.getSystemStats().battery < 5) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(dc.getWidth()*3/8, dc.getHeight()*11/16, IconsFont, "9", Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (System.getDeviceSettings().connectionInfo[:bluetooth].state == 2) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()*4/8, dc.getHeight()*11/16, IconsFont, "7", Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (System.getDeviceSettings().connectionInfo[:bluetooth].state == 1) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()*4/8, dc.getHeight()*11/16, IconsFont, "6", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
