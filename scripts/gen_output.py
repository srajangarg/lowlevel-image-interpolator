import sys
# install using `sudo apt-get install python-numpy`
import numpy as np
# install using `sudo apt-get install python-opencv`
import cv2
N = 100

if(len(sys.argv) != 3):
	print "Usage : python gen_input.py <in-data> <out-image>"
	print "<in-data> \t filename w appropriate filepath"
	print "<out-image> \t output image filename"
	sys.exit()

PIXELS = np.empty((N, N, 3))

try:
	f = open(sys.argv[1])
except:
	print "Could not in-file!"
	sys.exit()

lines = f.read().split('\n')[:-1]
f.close()

row = 0
col = 0
increasing = True

for i in range(N*N):

	PIXELS[row, col, 2] = int(lines[i][0:16], 2)
	PIXELS[row, col, 1] = int(lines[i][16:32], 2)
	PIXELS[row, col, 0] = int(lines[i][32:48], 2)
	
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

cv2.imwrite(sys.argv[2], PIXELS)
