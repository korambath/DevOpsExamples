
all:
	@echo " "
	@echo "Compiling pub and sub"
	@echo " "
	gcc -o mqtt_pub mqtt_pub.c -lmosquitto
	gcc -o mqtt_sub mqtt_sub.c -lmosquitto
	@echo " end "



pub:
	@echo "Compiling pub "
	gcc -o mqtt_pub mqtt_pub.c -lmosquitto
sub:
	@echo "Compiling sub "
	gcc -o mqtt_sub mqtt_sub.c -lmosquitto
clean:
	rm mqtt_sub mqtt_pub
