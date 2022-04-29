#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mosquitto.h>
#include <time.h>
#include <unistd.h>

#define MSG_MAX_SIZE  512

void on_publish_callback(struct mosquitto *mosq, void *obj, int rc)
{
	printf("From publish callback set ID: %d and rc = %d \n", * (int *) obj, rc);
	/*
        mosquitto_disconnect(mosq);
	*/
}

static int state = 1;

void on_connect_callback(struct mosquitto *mosq, void *obj, int rc)
{
        printf("Call the function: my_connect_callback set ID: %d and rc = %d \n", * (int *) obj, rc );
}

void on_disconnect_callback(struct mosquitto *mosq, void *obj, int rc)
{
        printf("Call the function: my_disconnect_callback\n");
        state = 0;
}

int main(int argc, const char *argv[]){
	int rc;
	struct mosquitto * mosq;
        char *host = "localhost";
        int port = 1883;

	char *id = "publisher-test";
        int keepalive = 60;
	const char *topic = "test/t1";
	//const char *msg = "Hello";
        char msg_buff[MSG_MAX_SIZE];

	rc = mosquitto_lib_init();
        if (rc) {
           printf("\nlib_init error! \n");
        }

	//mosq = mosquitto_new("publisher-test", true, NULL);
	mosq = mosquitto_new(id, true, NULL);

	if(!mosq){
            printf("mosquitto_new failed");
            return 1;
        }

	//mosquitto_username_pw_set(mosq,"ppk","changeme");
        //set the callback function
        mosquitto_connect_callback_set(mosq, on_connect_callback);
        mosquitto_disconnect_callback_set(mosq, on_disconnect_callback);


	mosquitto_publish_callback_set(mosq, on_publish_callback);

	//rc = mosquitto_connect(mosq, "localhost", 1883, 60);
	rc = mosquitto_connect(mosq, host, port, keepalive);
	if(rc != 0){
		printf("Client could not connect to broker! Error Code: %d\n", rc);
		mosquitto_destroy(mosq);
		return -1;
	}
	printf("We are now connected to the broker!\n");

        printf("This function runs in a while loop,  type a message to publish at the prompt or Enter (blank message) to quit\n");

	//rc = mosquitto_publish(mosq, NULL, "test/t1", 6, "Hello", 0, false);
	//
	
	mosquitto_loop_start(mosq);

	/* get the current time */
	time_t now;
        time(&now);
        struct tm* tm_info = localtime(&now);

        char outstr[200];
        char time_msg[1024];

        int count = 0;
        while(fgets(msg_buff, MSG_MAX_SIZE, stdin) != NULL && msg_buff[0] != '\n') {

           msg_buff[strcspn(msg_buff, "\n")] = 0;
           time(&now);
           tm_info = localtime(&now);

           if (strftime(outstr, sizeof(outstr), "%m-%d-%Y %H:%M:%S", tm_info) == 0 ) {
               fprintf(stderr, "strftime returned 0");
               return -1;
           }

           /* print a message */
           snprintf(time_msg, sizeof(time_msg), "Hello, at time %s your message %s ", outstr, msg_buff);
           printf("published message %d will be : \"%s\" \n", count, time_msg);


	   rc = mosquitto_publish(mosq, NULL, topic, strlen(time_msg)+1, time_msg, 0, false);

	   if(rc != 0){
	        printf("Error number: %d",rc);
                printf("\nerr description=%s\n", mosquitto_strerror(rc));
	   } else {
	   	printf("\nMQTT Message: \"%s\" is published on topic %s \n", time_msg, topic);
	   }
           count++;
           // sleep a millisecond
           usleep(1000);
           printf("This function runs in a while loop,  type a message to publish at the prompt or Enter (blank message) to quit\n");
        }

	//mosquitto_loop_forever(mosq, -1, 1);

	rc = mosquitto_disconnect(mosq);
	if (rc != MOSQ_ERR_SUCCESS) {
            printf("\nCannot disconnect mosquitto: %s\n", mosquitto_strerror(rc));
        } else {
            printf("\nDisconnecting Mosquitto \n");
        }
	mosquitto_destroy(mosq);

	rc = mosquitto_lib_cleanup();
	if (rc != MOSQ_ERR_SUCCESS) {
            printf("\nCannot cleanup library: '%s'", mosquitto_strerror(rc));
        }
        printf("End!\n");
	return 0;
}
