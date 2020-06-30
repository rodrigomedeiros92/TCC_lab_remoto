
from app import app
from flask import render_template, request, Response, jsonify,send_file,redirect, url_for,flash,stream_with_context

import os
import serial
import cv2
import sys
import numpy
import config
import time
import threading


UPLOAD_FOLDER = ''
ALLOWED_EXTENSIONS = set(['bit'])
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


value0=0;value1=0;value2=0;value3=0;value4=0;value5=0;value6=0;value7=0;value8=0;value9=0;value10=0;value11=0
value12=0;value13=0;value14=0;value15=0;b=0;btnu=0;btnl=0;btnc=0;btnr=0;btnd=0;
t=0
time_busy=0
time_busy_end=0
busy=0

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



def read():
    global t
    t2=0
    fim=0
    aux=0
    b=0
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    arq = open('data.txt', 'a')
    while b!=86:
        b=ord(ser.read())
    inicio = time.time()
    while t2<=10:
        c=ord(ser.read())
        if c==86:
            pass
        elif c == 87:
            pass
        elif c==88:
            pass
        elif c==89:
            pass
        else:
            fim=time.time()
            t2=fim-inicio
            t=str((t2))
            a=bin(c)[2:]
            arq.write('{:0>8}'.format(a))
            arq.write("\t")
            arq.write(t)
            arq.write("\n")
    arq.close()
    ser.close()



def server_busy():
    global time_busy
    global busy
    global time_busy
    time_busy_end=0
    while time_busy_end<600:
        time1=time.time()
        time_busy_end=time1-time_busy
    busy=0



def gen():
    i=1
    while i<10:
        yield (b'--frame\r\n'
            b'Content-Type: text/plain\r\n\r\n'+str(i)+b'\r\n')
        i+=1

def get_frame():

    camera_port=0

    ramp_frames=100

    camera=cv2.VideoCapture(1) #this makes a web cam object


    i=1
    while True:
        retval, im = camera.read()
        imgencode=cv2.imencode('.jpg',im)[1]
        stringData=imgencode.tostring()
        yield (b'--frame\r\n'
            b'Content-Type: text/plain\r\n\r\n'+stringData+b'\r\n')
        i+=1

    del(camera)


@app.route('/return-files/',methods=['GET'])
def return_files_tut():
        path = "/home/rodrigo/Laboratorio_remoto_oficial/data.txt"
        return send_file(path, as_attachment=True)

@app.route('/manual/',methods=['GET'])
def manual():
        path = "/home/rodrigo/Laboratorio_remoto_oficial/manual.pdf"
        return send_file(path, as_attachment=True)



@app.route('/calc')
def calc():
     return Response(get_frame(),mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route("/")
def index():
    return render_template("index.html")

@app.route('/contato',methods=['GET'])
def contato():
    return render_template("contato.html")


@app.route("/upload", methods=['GET', 'POST'])
def upload():
    if busy==1:
        return render_template("busy.html")
    else:
        if request.method == 'POST':
        # check if the post request has the file part
            if 'file' not in request.files:
                flash('No file part')
                return redirect(request.url)
            file = request.files['file']
        # if user does not select file, browser also
        # submit a empty part without filename
            if file.filename == '':
                flash('No selected file')
                return redirect(request.url)
            if file and allowed_file(file.filename):
                filename = file.filename
                if filename == 'top_wrapper.bit':
                    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                    return redirect(url_for('complete'))
                else:
                    return render_template("upload.html")
        return render_template("upload.html")



@app.route('/complete/', methods=['POST', 'GET'])
def complete():
    global busy,time_busy
    global value0,value1,value2,value3,value4,value5,value6,value7,value8,value9
    global value10,value11,value12,value13,value14,value15,btnu,btnl,btnc,btnr,btnd
    global t
    if busy==1:
        return render_template("busy.html")
    else:
        os.system("djtgcfg prog -d Nexys4 -i 0 -f /home/rodrigo/Laboratorio_remoto_oficial/top_wrapper.bit")
        os.system("rm /home/rodrigo/Laboratorio_remoto_oficial/top_wrapper.bit")
        os.system("rm /home/rodrigo/Laboratorio_remoto_oficial/data.txt")
        t=0
        threading.Thread(target=read).start()
        busy=1
        time_busy=time.time()
        threading.Thread(target=server_busy).start()
        btnu=0;btnl=0;btnc=0;btnr=0;btnd=0;

        return render_template("complete.html",value0=value0,value1=value1,value2=value2,value3=value3,
        value4=value4,value5=value5,value6=value6,value7=value7,value8=value8,value9=value9,value10=value10,
        value11=value11,value12=value12,value13=value13,value14=value14,value15=value15,btnu=btnu,btnl=btnl,btnc=btnc,btnr=btnr,btnd=btnd)


@app.route('/sw0/', methods=['POST'])
def sw0():
    global value0
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value0==0:
        value0=1
        ser.write(b'A')
    else:
        value0=0
        ser.write(b'a')
    ser.close()
    return jsonify({'data': value0})


@app.route('/sw1/', methods=['POST'])
def sw1():
    global value1
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value1==0:
        value1=1
        ser.write(b'B')
    else:
        value1=0
        ser.write(b'b')
    ser.close()
    return jsonify({'data': value1})

@app.route('/sw2/', methods=['POST'])
def sw2():
    global value2
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value2==0:
        value2=1
        ser.write(b'C')
    else:
        value2=0
        ser.write(b'c')
    ser.close()
    return jsonify({'data': value2})

@app.route('/sw3/', methods=['POST'])
def sw3():
    global value3
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value3==0:
        value3=1
        ser.write(b'D')
    else:
        value3=0
        ser.write(b'd')
    ser.close()
    return jsonify({'data': value3})

@app.route('/sw4/', methods=['POST'])
def sw4():
    global value4
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value4==0:
        value4=1
        ser.write(b'E')
    else:
        value4=0
        ser.write(b'e')
    ser.close()
    return jsonify({'data': value4})

@app.route('/sw5/', methods=['POST'])
def sw5():
    global value5
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value5==0:
        value5=1
        ser.write(b'F')
    else:
        value5=0
        ser.write(b'f')
    ser.close()
    return jsonify({'data': value5})

@app.route('/sw6/', methods=['POST'])
def sw6():
    global value6
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value6==0:
        value6=1
        ser.write(b'G')
    else:
        value6=0
        ser.write(b'g')
    ser.close()
    return jsonify({'data': value6})

@app.route('/sw7/', methods=['POST'])
def sw7():
    global value7
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value7==0:
        value7=1
        ser.write(b'H')
    else:
        value7=0
        ser.write(b'h')
    ser.close()
    return jsonify({'data': value7})


@app.route('/sw8/', methods=['POST'])
def sw8():
    global value8
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value8==0:
        value8=1
        ser.write(b'I')
    else:
        value8=0
        ser.write(b'i')
    ser.close()
    return jsonify({'data': value8})

@app.route('/sw9/', methods=['POST'])
def sw9():
    global value9
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value9==0:
        value9=1
        ser.write(b'J')
    else:
        value9=0
        ser.write(b'j')
    ser.close()
    return jsonify({'data': value9})

@app.route('/sw10/', methods=['POST'])
def sw10():
    global value10
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value10==0:
        value10=1
        ser.write(b'K')
    else:
        value10=0
        ser.write(b'k')
    ser.close()
    return jsonify({'data': value10})

@app.route('/sw11/', methods=['POST'])
def sw11():
    global value11
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value11==0:
        value11=1
        ser.write(b'L')
    else:
        value11=0
        ser.write(b'l')
    ser.close()
    return jsonify({'data': value11})

@app.route('/sw12/', methods=['POST'])
def sw12():
    global value12
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value12==0:
        value12=1
        ser.write(b'M')
    else:
        value12=0
        ser.write(b'm')
    ser.close()
    return jsonify({'data': value12})

@app.route('/sw13/', methods=['POST'])
def sw13():
    global value13
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value13==0:
        value13=1
        ser.write(b'N')
    else:
        value13=0
        ser.write(b'n')
    ser.close()
    return jsonify({'data': value13})

@app.route('/sw14/', methods=['POST'])
def sw14():
    global value14
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value14==0:
        value14=1
        ser.write(b'O')
    else:
        value14=0
        ser.write(b'o')
    ser.close()
    return jsonify({'data': value14})

@app.route('/sw15/', methods=['POST'])
def sw15():
    global value15
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if value15==0:
        value15=1
        ser.write(b'P')
    else:
        value15=0
        ser.write(b'p')
    ser.close()
    return jsonify({'data': value15})

@app.route('/btnu/', methods=['POST'])
def btnu():
    global btnu
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if btnu==0:
        btnu=1
        ser.write(b'Q')
    else:
        btnu=0
        ser.write(b'q')
    ser.close()
    return jsonify({'data': btnu})

@app.route('/btnl/', methods=['POST'])
def btnl():
    global btnl
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if btnl==0:
        btnl=1
        ser.write(b'R')
    else:
        btnl=0
        ser.write(b'r')
    ser.close()
    return jsonify({'data': btnl})

@app.route('/btnc/', methods=['POST'])
def btnc():
    global btnc
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if btnc==0:
        btnc=1
        ser.write(b'S')
    else:
        btnc=0
        ser.write(b's')
    ser.close()
    return jsonify({'data': btnc})

@app.route('/btnr/', methods=['POST'])
def btnr():
    global btnr
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if btnr==0:
        btnr=1
        ser.write(b'T')
    else:
        btnr=0
        ser.write(b't')
    ser.close()
    return jsonify({'data': btnr})

@app.route('/btnd/', methods=['POST'])
def btnd():
    global btnd
    ser = serial.Serial('/dev/ttyUSB1', 9600)
    if btnd==0:
        btnd=1
        ser.write(b'U')
    else:
        btnd=0
        ser.write(b'u')
    ser.close()
    return jsonify({'data': btnd})
