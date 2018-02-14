import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, math
import tweepy,datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import serial
import serial.tools.list_ports
PORT = 'COM3'

Graph_Flag=2
endtime=850
xsize=850

ysize=300
filename='foo.png'
subject = 'Hello!'
email_send='elhosaryabdelrahman@gmail.com'#Email




file = open('reflowdata.txt','w')
        
def data_gen():
    t = data_gen.t
    while True:
       t+=1
       #val=100.0*math.sin(t*2.0*3.1415/100.0)
       strin = ser.readline();
       y= float (strin);
       file.write(str(y)+'\n');
       #file.close()
       yield t, y

def run(data):


    # update the data
    t,y = data
    if t>-1:
        xdata.append(t)
        ydata.append(y)
        b = ydata[0]            # Find a y-intercept
        
    if t>xsize: # Scroll to the left.
        ax.set_xlim(t-xsize, t)
    
    line.set_data(xdata, ydata)          
   
    print(t,int(y))
        
    if t==endtime:
        fig.savefig('foo.png')
    if t==endtime+1:
        email_helper('foo.png','Reflow_Email',email_send)   
        twitter_helper()
        
    return line,
    
def on_close_figure(event):
    sys.exit(0)
    
def twitter_helper():
    try:
        CONSUMER_KEY = 'Voy7bttxw8rKpC18wALNaKvup'#keep the quotes, replace this with your consumer key
        CONSUMER_SECRET = 'wmg6HtRGs5Bnpohmp4ys6GoEAfsVRvc5N9mP2prm9w7MSsXj3G'#keep the quotes, replace this with your consumer secret key
        ACCESS_KEY = '962464172695941120-STGTA2nI6DFz26yVAv61oDdGk5pr5ZM'#keep the quotes, replace this with your access token
        ACCESS_SECRET = 'PaakHuSWYmFaA35jKmOdUDBecvYayOGzqV0vt3L9bFlSp'#keep the quotes, replace this with your access token secret
        auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
        auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
        api = tweepy.API(auth)
         
        filename=open('TwitterBot.txt','r')
        f=filename.readlines()
        filename.close()
        for line in f:
            
            api.update_status(status=line)  
    except:
        print('Tweet Failed to send')
        
        
def email_helper(filename,subject,email_send):
    try:   
        email_user = 'elhosaryabdelrahman@gmail.com'#Your Email
        email_password = 'iownall123'#Your Password
        
        
        msg = MIMEMultipart()
        msg['From'] = email_user
        msg['To'] = email_send
        msg['Subject'] = subject
           
        currentDT = str(datetime.datetime.now()) 
        ShortDate = currentDT[:-7]
        body = 'Sending this email from Python! Your Reflow was completed at '
        msg.attach(MIMEText(body+ShortDate,'plain'))
        
        
        attachment  =open('foo.png','rb')
        
        part = MIMEBase('application','octet-stream')
        part.set_payload((attachment).read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition',"attachment; filename= "+filename)
        
        msg.attach(part)
        text = msg.as_string()
        server = smtplib.SMTP('smtp.gmail.com',587)
        server.starttls()
        server.login(email_user,email_password)
        
        
        server.sendmail(email_user,email_send,text)
        server.quit()
        print('Email Sent!')
    
    except:
        print('Email Failed to send')
        
def SPI_init():

    try:
        ser.close();
    except:
        print();
    try:
        ser = serial.Serial(PORT, 115200, timeout=100)
    except:
        print ('Serial port %s is not available' % PORT); portlist=list(serial.tools.list_ports.comports())
        print('Trying with port %s' % portlist[0][0]);
        ser = serial.Serial(portlist[0][0], 115200, timeout=100)
        ser.isOpen()
        return ser    
#==============================================================================
#                               Top Level    
#==============================================================================
#ser=SPI_init()
count=0  
paramters_array=[] 

    
try:
    ser.close();
except:
    print();
try:
    ser = serial.Serial(PORT, 115200, timeout=100)
except:
    print ('Serial port %s is not available' % PORT); portlist=list(serial.tools.list_ports.comports())
    print('Trying with port %s' % portlist[0][0]);
    ser = serial.Serial(portlist[0][0], 115200, timeout=100)
    ser.isOpen()
    
handshake=ser.readline()
handshake.decode('ascii')
while Graph_Flag==2:
    handshake= (ser.readline())
    #handshake.decode('ascii')
    print(handshake.decode('ascii'));
    #print(type(handshake.decode('ascii')));
    fat= int (handshake)
    if fat==1:
        Graph_Flag=0
        
while (Graph_Flag==0): #Gets parameters for the 2nd graph
    
    paramters_array.append(ser.readline()) ;             
    print(paramters_array[count].decode('ascii')); #Testing to see if right paramters are beng sent    
    print('nice')
    fat= int(paramters_array[count])
    if fat==0:
        Graph_Flag=1

        
    count+=1
    
print  (paramters_array)
soak_time = int(paramters_array[1])
soak_temp = int(paramters_array[2])
reflow_time = int(paramters_array[3])
reflow_temp = int(paramters_array[4])

# Some Constants
preheat_time, preheat_temp = 160, 160
soak_time, soak_temp       = 80, 160 
ramp2pk_time, ramp2pk_temp = 145, 230
reflow_time, reflow_temp   = 30, 230
time = np.linspace(0,800, 800)

t1 = preheat_time
t2 = t1 + soak_time
t3 = t2 + ramp2pk_time
t4 = t3 + reflow_time


def f(x):
 if   (0<=x<t1): return 22 + (preheat_temp-22)/preheat_time * x
 elif (t1<=x<t2):  return soak_temp
 elif (t2<=x<t3):   return soak_temp + (x-t2)*(reflow_temp-soak_temp)/ramp2pk_time
 elif (t3<=x<t4): return reflow_temp
 elif (t4<=x<800): return np.exp(-(1/20)*(x-t4))*reflow_temp
 else: return 0

x = np.arange(0., 800, 0.2)

y = []
for i in range(len(x)):
    
   y.append(f(x[i]))

 
    
while (Graph_Flag==1) :#BELOW HERE, IMPLEMENT THE GRAPH
    data_array=[]
    counter=0
    strin =  (ser.readline());
    #file.write(str(strlin));
    #print(strin.decode('ascii'));

    
    if (soak_time==80 and soak_temp==150 and reflow_time==30 and reflow_temp==230 ):
        graph_title='Reflow Oven Temp for SAC305 Paste' 
        
    elif (soak_time==80 and soak_temp==150 and reflow_time==20 and reflow_temp==230 ):
        graph_title='Reflow Oven Temp for lead solder Paste' 
        
    else:
        graph_title= 'Reflow Oven Temp for Custom Paste' 
         
    data_gen.t = -1
    fig = plt.figure()
    fig.suptitle(graph_title)
    plt.ylabel('Temperature (°C)')
    plt.xlabel('Time (seconds)')
    fig.canvas.mpl_connect('close_event', on_close_figure)
    ax = fig.add_subplot(111)
    line, = ax.plot([], [], lw=2)
    line1, = ax.plot(x, y
                     , 'g--', lw=2)
    ax.set_ylim (-5, 300)
    ax.set_xlim(0, xsize)
    ax.grid()
    xdata, ydata = [], []


    # Important: Although blit=True makes graphing faster, we need blit=False to prevent
    # spurious lines to appear when resizing the stripchart.
    ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=100, repeat=False)
    plt.show()
