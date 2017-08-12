package utils;

import flixel.FlxG;
import flixel.ui.FlxButton;

class ControlsHandler
{

    public static function keyPressedLeft():Bool
    {
        #if mobile
            if (Reg.PS.virtualPad.buttonLeft.pressed)
                return true;
        #else
            if (FlxG.keys.pressed.LEFT) 
                return true;
        #end

        return false;
    }

    public static function keyPressedRight():Bool
    {
        #if mobile
            if (Reg.PS.virtualPad.buttonRight.pressed) 
                return true;
        #else
            if (FlxG.keys.pressed.RIGHT) 
                return true;
        #end
        

        return false;
    }

    public static function keyJustPressedJump():Bool
    {
        #if mobile
            if(Reg.PS.virtualPad.buttonA.justPressed)
                return true;
            
        #else
            if(FlxG.keys.justPressed.C)
                return true;
            
        #end

        return false;
    }

    public static function keyPressedJump():Bool
    {
        #if mobile
            if(Reg.PS.virtualPad.buttonA.pressed)
                return true;
            
        #else
            if(FlxG.keys.pressed.C)
                return true;
        
        #end
        

        return false;
    }

    public static function keyReleasedJump():Bool
    {
        #if mobile
            if(Reg.PS.virtualPad.buttonA.justReleased)
                return true;
            
        #else
            if(FlxG.keys.justReleased.C)
                return true;
            
        #end

        return false;
    }

    public static function keyPressedRun():Bool
    {
        #if mobile
            if(Reg.PS.virtualPad.buttonB.pressed)
                return true;
            
        #else
            if(FlxG.keys.pressed.X)
                return true;
            
        #end

        return false;
    }

}