from opcua import Server, ua, uamethod
from opcua.ua import NodeId, NodeIdType
from random import randint
import datetime
import psutil
import time


server = Server()

server.set_security_policy([ua.SecurityPolicyType.NoSecurity])

url = "opc.tcp://localhost:62548"

server.set_endpoint(url)

print ("Server {}".format( server.get_endpoints()))

name = "OPCUA_SIMULATION"
#name="http://opcfoundation.org/UA/"

address_space = server.register_namespace(name)
print("Address space :{}".format(address_space))


print("server root browse_name :{}".format(server.get_root_node().get_browse_name().Name))
print("server get_children :{}".format(server.get_root_node().get_children()))
print("server Name space array :{}".format(server.get_namespace_array()         ))

#print("Server Object Node children : {}".format(server.get_objects_node().get_children()))

object_id=str(server.get_objects_node()).strip("Node(TwoByteNodeId(i=").strip('))')
object_id=int(object_id)
print("object_id = {}".format(object_id))

print("Object get_parent :{}".format(server.get_node(object_id).get_parent()     ))
print("Object browse_name :{}".format(server.get_node(object_id).get_browse_name().Name))
print("Object display_name :{}".format(server.get_node(object_id).get_display_name()))


objects_node = server.get_objects_node()

print("Objects_Node : ", objects_node)

Param = objects_node.add_object(address_space, "Parameters")

print("Parmaeters browse_name : {}".format(Param.get_browse_name().Name))
print("Parmaeters NodeId : {}".format(Param))

Temp = Param.add_variable(address_space, "Temperature",10,ua.VariantType.Int32 )
Temp.set_attribute(ua.AttributeIds.Description, ua.DataValue(ua.LocalizedText("Temperature Value")))
Press = Param.add_variable(address_space, "Pressure",10.0, ua.VariantType.Float)
Press.set_attribute(ua.AttributeIds.Description, ua.DataValue(ua.LocalizedText("Pressure Value")))
Time = Param.add_variable(address_space, "Time",datetime.datetime.now(), ua.VariantType.DateTime)
Time.set_attribute(ua.AttributeIds.Description, ua.DataValue(ua.LocalizedText("TIME")))


print("Temp NodeId :  {} \nPress NodeId : {} \nTime  NodeId : {}".format( Temp, Press, Time))

print("Temp initial value: {}".format(Temp.get_value()))


furnace = objects_node.add_object('ns=3;s="C_CF1"', "Cesmii Furnace")
print("Furnace Nodeid {}".format(furnace))

furnace.add_variable('ns=3;s="C_CF1_ManfctrName"', "C_CF1_Manufacturer_Name", "CESMII_Furnace_Inc.", ua.VariantType.String)
furnace.add_variable('ns=3;s="C_CF1_SerialNumber"', "C_CF1_Serial_Number", 98765432, ua.VariantType.UInt32)

state = furnace.add_variable('ns=3;s="C_CF1_DoorState"', "State of Furnace Door", False, ua.VariantType.Boolean)
print("Furnace Door state Nodeid {}".format(state))

state.set_writable()
print("Door state Nodeid is {}".format(state.nodeid))

print("Door State initial value: {}".format(state.get_value()))


print("Server Object Node children : {}".format(server.get_objects_node().get_children()))

#Temp.set_writable()
#Press.set_writable()

try:

     server.start()

     print("Server Started at {}".format(url))
     print("Server Online at " + str(datetime.datetime.now()))

     while True:
           Temperature = randint(10,50)
           Pressure = randint(200,999)
           TIME = datetime.datetime.now()

           print(Temperature, Pressure, TIME, state.get_value())

           Temp.set_value(Temperature)
           Press.set_value(Pressure)
           Time.set_value(TIME)

           time.sleep(2)
finally:
    server.stop()
    print("Server offline")





