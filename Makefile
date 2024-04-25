all: latest full

full:
	docker build -t wention/dmdb:full -f Dockerfile.full .

latest:
	docker build -t wention/dmdb:latest .
