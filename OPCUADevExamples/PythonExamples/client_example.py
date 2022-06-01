from opcua import Client, ua
import opcua

import datetime
import time


url = "opc.tcp://localhost:62548"

client = Client(url)

try:

    client.connect()
    print("Client Started at {}".format(url))
    print("Client Online at " + str(datetime.datetime.now()))


    client.load_type_definitions()
    root = client.get_root_node()
    print("Root node is: ", root)
    objects = client.get_objects_node()
    print("Objects node is: ", objects)

    print("Object Node browse name is ", objects.get_browse_name().Name)

    print("Namespace : " + str(client.get_namespace_array()))

    print("Object Node children : {}".format(client.get_objects_node().get_children()))


    total_nodes = []
    children = objects.get_children()
    for child in children:
        total_nodes.append(( child))

    count=1
    while count < len(total_nodes):
        print(objects.get_children()[count].get_children())
        sub_nodes = objects.get_children()[count]
        for sub_node in sub_nodes.get_children():
            print(sub_node.get_browse_name().Name, sub_node.get_value())
            if ua.AccessLevel.CurrentWrite in sub_node.get_user_access_level():
               print(sub_node.get_user_access_level())
               #sub_node.set_value(True)
        count+= 1

# Continuously get the data CTRL C to stop

    while True:
        count=1
        while count < len(total_nodes):
            #print(objects.get_children()[count].get_children())
            sub_nodes = objects.get_children()[count]
            for sub_node in sub_nodes.get_children():
                print(sub_node.get_browse_name().Name, sub_node.get_value())
            count+= 1
        time.sleep(2)
        
finally:
    client.close_session()
    client.disconnect()
    print("client offline")

