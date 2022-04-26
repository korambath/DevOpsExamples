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
    else:
        print("Failed to connect, return code %d\n", rc)


def on_log(client, userdata, level, buffer):
     print("Log ", buffer)


def on_publish(client,userdata,result):             #create function for callback
    print(f"data published  {result} \n")
    #client.disconnect()
    pass

def publish(client):
    machine_id=1111
    msg_count = 0
    #sensor_data = {'temperature6': 0, 'temperature7': 0}
    sensor_data = {}
    sensor_data['machine_id'] = machine_id

    for i in range(1,3):
       fileName = 'image_{0}.png'.format(i)
       print("filename = ", fileName)
       with open('image_{0}.png'.format(i),'rb') as f:

          #f=open("all_parts.png", "rb") 
          fileContent = f.read()
          byteArr = bytearray(fileContent)

          result = client.publish(topic, byteArr, 0) 
          status = result[0]
          if status == 0:
            print(f"Send message `{fileName}`  to topic `{topic}`")
          else:
            print(f"Failed to send message to topic {topic}")

          time.sleep(4)

def run():
    print("creating new instance")
    client = mqtt.Client(client_id)

    #client.on_log = on_log # Debug

    
    client.on_connect = on_connect
    print("connecting to broker")
    client.connect(broker_address, port)

    client.loop_start()
    client.on_publish = on_publish      
    print("Publishing to topic ", topic)
    publish(client)

#client.loop_forever()

if __name__ == '__main__':
    run()

