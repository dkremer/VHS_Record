.PHONY: build run terminal

tag = latest
user = camerondevine
image = vhs_record

container = $(user)/$(image):$(tag)

build:
	sudo docker build -t $(container) .

video = video2

run:
	sudo docker run --device=/dev/$(video):/dev/video --device=/dev/snd -v "$$(pwd)/data":/data -v "$$(pwd)/config:/config" -p 5000:5000 -it $(container)

terminal:
	sudo docker run -it $(container) bash
