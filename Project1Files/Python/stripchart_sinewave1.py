import numpy as np
import pylab
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, time, math

xsize=100
ysize=100

# Bounds for Profile
b1 = 50
b2 = 100
b3 = 150
b4 = 200
b5 = 250

m1 = 1
m2 = 2
m3 = 2

   
def data_gen():
    t = data_gen.t
    while True:
       t+=1
       val=100.0*math.sin(t*2.0*3.1415/100.0)
       val1=100.0*math.sin(t*2.0*3.1415/100.0)
       yield t, val

def run(data):
    # update the data
    t,y = data
    if t>-1:
        xdata.append(t)
        ydata.append(y)
        
        if t>xsize: # Scroll to the left.
            ax.set_xlim(t-xsize, t)
        
        
        if (0 < t < b1):
            bdata.append(m1*t)         # Add a second Graph
        elif (b1 <= t < b2):
            bdata.append(b1)
        elif (b2 <= t < b3):
            bdata.append(m2*t + b1 - m2*b2)
        elif (b3 <= t < b4):
            bdata.append(-m3*t + m2*b3+b1-m2*b2+m3*b3)
        else:
            bdata.append(0)
          
        line.set_data(xdata, ydata)          
        line1.set_data(xdata, bdata)
        
    if t==10:
        fig.savefig('foo.png')
        
    return line, line1
    
def on_close_figure(event):
    sys.exit(0)

data_gen.t = -1
fig = plt.figure()
fig.canvas.mpl_connect('close_event', on_close_figure)
ax = fig.add_subplot(111)
line, = ax.plot([], [], lw=2)
line1, = ax.plot([], [], 'go-',  lw=2)
ax.set_ylim(-100, 200)
ax.set_xlim(0, xsize)
ax.grid()
xdata, ydata = [], []
bdata = []

# Important: Although blit=True makes graphing faster, we need blit=False to prevent
# spurious lines to appear when resizing the stripchart.
ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=100, repeat=False)
plt.show()
