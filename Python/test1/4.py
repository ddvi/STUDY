# coding:utf-8
from evdev import InputDevice, ecodes, list_devices, categorize
import signal, sys
import evdev
import redis


global dev
devices = map(InputDevice, list_devices())
for device in devices:
        print(device.name)