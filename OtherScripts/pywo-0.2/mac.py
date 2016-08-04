# -*- coding: iso-8859-1 -*-
from Quartz import CGPostMouseEvent, CGWarpMouseCursorPosition, CGDisplayPixelsHigh, CGDisplayPixelsWide
from AppKit import NSEvent
from pymouse import PyMouseMeta

class PyMouse(PyMouseMeta):
    def press(self, x, y, button = 1):
        button_list = [0, 0, 0]
        button_list[button - 1] = 1
        CGPostMouseEvent((x, y), 1, 3, *button_list)

    def release(self, x, y, button = 1):
        CGPostMouseEvent((x, y), 1, 3, 0, 0, 0)

    def move(self, x, y):
        CGWarpMouseCursorPosition((float(x), float(y)))

    def position(self):
        loc = NSEvent.mouseLocation()
        return loc.x, CGDisplayPixelsHigh(0) - loc.y

    def screen_size(self):
        return CGDisplayPixelsWide(0), CGDisplayPixelsHigh(0)
