import PIL.Image
import serial
import time
img = PIL.Image.new('RGB', (100,100), "red") # create a new black image
pixels = img.load() # create the pixel map
ser = serial.Serial('COM1',9600)
for i in range(100):
    for j in range(100):
        msg = ser.readline()
        value = int(msg)
        print value
        time.sleep(.2)
        pixels[i,j] = (value, 0, 100)
img.show()