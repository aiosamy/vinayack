from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice
from subprocess import Popen, PIPE 
import re
import sys

if sys.argv is None or len(sys.argv) < 2:
    print "Usage: " + sys.argv[0] + " text"
    sys.exit(-1)

text = sys.argv[1]
TestDevice = sys.argv[2]
device = MonkeyRunner.waitForConnection(20000, TestDevice)
width = int(device.getProperty('display.width'))
height = int(device.getProperty('display.height'))
MonkeyRunner.sleep(2)
device.drag((width/2, 0), (width/2, height))
MonkeyRunner.sleep(2)
result = device.takeSnapshot()
result.writeToFile("imageforocr.png","png")
process = Popen(["python", "Notification_ocr.py", text], stdout=PIPE)
output = process.communicate()[0]
#print output
match = re.search("(\d+)\|(\d+)", output, re.DOTALL)
if not match is None:
    x = int(match.group(1))
    y = int(match.group(2))
    device.touch(x, y, "DOWN_AND_UP")
    MonkeyRunner.sleep(2)
    result = device.takeSnapshot()
    result.writeToFile("imageforocraftertouch.png","png")
