.PHONY: all build start login stop remove create_keys print_key clean fclean

SELF_SIGNED_CRT	=	./influxdb-selfsigned.crt

all: start

build: $(SELF_SIGNED_CRT)
	sudo docker-compose build

start: build
	sudo docker-compose up -d

login:
	sudo docker exec -it influxdb bash

login_grafana:
	sudo docker exec -it grafana bash

stop:
	sudo docker kill chronograf
	sudo docker kill grafana
	sudo docker kill influxdb

remove: stop
	sudo docker rm chronograf
	sudo docker rm grafana
	sudo docker rm influxdb

$(SELF_SIGNED_CRT):
	echo "FI\nUusimaa\n" | \
	openssl req -x509 -nodes -newkey rsa:2048 \
	-keyout ./influxdb-selfsigned.key \
	-out ./influxdb-selfsigned.crt \
	-days 365 \
	-subj "/C=FI/ST=Uusimaa/L=Espoo/O=/OU=/CN="
	chmod 644 ./influxdb-selfsigned.crt
	chmod 600 ./influxdb-selfsigned.key

print_key:
	openssl x509 -in influxdb-selfsigned.crt -text -noout

clean: remove

fclean: clean
