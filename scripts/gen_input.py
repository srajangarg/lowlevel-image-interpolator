import sys
# install using `sudo apt-get install python-numpy`
import numpy as np
# install using `sudo apt-get install python-opencv`
import cv2
N = 100

if(len(sys.argv) != 6):
	print "Usage : python gen_input.py <in-image> <R> <G> <B> <out-file>"
	print "<in-image> \t filename w appropriate filepath"
	print "<R> <G> <B> \t integers (max 2**16 -1)"
	print "<out-file> \t output filename"
	sys.exit()

try:
	PIXELS = cv2.imread(sys.argv[1], -1)
except:
	print "Could not load image!"
	sys.exit()

if PIXELS.shape != (N, N, 3):
	print "Incorrect dimensions!"

R = int(sys.argv[2])
G = int(sys.argv[3])
B = int(sys.argv[4])

def to_bin(x):
	return str(bin(x))[2:].zfill(16)

lines = [to_bin(R), to_bin(G), to_bin(B)]

row = 0
col = 0
increasing = True

for i in range(N*N):

	lines.append(to_bin(PIXELS[row, col, 2]) + to_bin(PIXELS[row, col, 1]) + to_bin(PIXELS[row, col, 0]))
	
	if col == N-1 and increasing :
		increasing = not increasing
		row += 1

	elif col == 0 and not increasing :
		increasing = not increasing
		row += 1

	else :
		if increasing:
			col += 1
		else:
			col -= 1

try:
	f = open(sys.argv[5], "w")
except:
	print "Could not open outfile!"
	sys.exit()

for line in lines:
  f.write("%s\n" % line)
f.close()
