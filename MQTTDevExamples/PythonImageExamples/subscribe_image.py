#!/usr/bin/env python3

import paho.mqtt.client as mqtt #import the client1
import time, json, random
from datetime import datetime, timezone
from random import randrange, uniform



broker_address="127.0.0.1"
port = 1883
# generate client ID with pub prefix randomly
client_id = f'python-mqtt-{random.randint(0, 1000)}'
topic = "house/sensor/image1"

def on_connect(client, userdata, flags, rc):
    if rc == 0:
       print("Connected to MQTT Broker!")
       print("Connected with result code "+str(rc))
    else:
       print("Failed to connect, return code %d\n", rc)

    print("Subscribing to topic ", topic)
    client.subscribe(topic)


def on_log(client, userdata, level, buffer):
     print("Log ", buffer)


def on_subscribe(client, obj, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))



############
def on_message(client, userdata, msg):
    print(f"Received  from `{msg.topic}` topic")
    print("message qos=",msg.qos)
    print("message retain flag=",msg.retain)

    if msg.retain==1:
        print("This is a retained message")

    timestr = time.strftime("%Y%m%d%H%M%S")
    fileName = 'output_{0}.png'.format(timestr)
    f = open('output_'+timestr+'.png', "wb")
    f.write(msg.payload)
    print("Image Received", fileName)
    f.close()

########################################


def run():
    print("creating new instance")
    client = mqtt.Client(client_id)
    client.on_connect = on_connect


    client.on_message = on_message  #attach function to callback
    #client.on_log = on_log
    #client.on_subscribe = on_subscribe

    print("connecting to broker")
    client.connect(broker_address, port)
    client.loop_forever()


    time.sleep(4)



if __name__ == '__main__':
    run()

