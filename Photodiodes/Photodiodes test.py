import RPi.GPIO as GPIO
from time import sleep

optoDX = 26
optoCX = 19
optoSX = 13

GPIO.setmode(GPIO.BCM)
GPIO.setup(optoDX, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(optoCX, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(optoSX, GPIO.IN, pull_up_down = GPIO.PUD_UP)

try:
    while True:
        letture = [GPIO.input(optoSX), GPIO.input(optoCX), GPIO.input(optoDX)]
        print(letture)
        sleep(1)
except KeyboardInterrupt:
    print("Programma terminato")