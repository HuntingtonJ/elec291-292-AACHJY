import matplotlib.pyplot as plt
import numpy as np

# Some Constants
preheat_time, preheat_temp = 150, 160
soak_time, soak_temp       = 70, 160 
ramp2pk_time, ramp2pk_temp = 100, 245
reflow_time, reflow_temp   = 60, 245
time = np.linspace(0,800, 800)

t1 = preheat_time
t2 = t1 + soak_time
t3 = t2 + ramp2pk_time
t4 = t3 + reflow_time


def f(x):
 if   (0<=x<t1):                   return 0 + preheat_temp/preheat_time * x
 elif (t1<=x<t2):  return soak_temp
 elif (t2<=x<t3):   return soak_temp + (x-t2)*(reflow_temp-soak_temp)/ramp2pk_time
 elif (t3<=x<t4): return reflow_temp
 elif (t4<=x<800): return np.exp(-(1/10)*(x-t4))*reflow_temp
 else: return 0

x = np.arange(0., 800, 0.2)

y = []
for i in range(len(x)):
    
   y.append(f(x[i]))

plt.plot(x,y,c='red', ls='-', ms=5)
ax = plt.gca()
ax.set_ylim([-10, 300])
ax.set_xlim([0,900])

plt.show()

                                      






