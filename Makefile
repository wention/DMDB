all: amd64 arm64

amd64: dm8_20240408-amd64 dm8_20240408_full-amd64

arm64: dm8_20231226-arm64 dm8_20231226_full-arm64

dm8_20240408-amd64:
	find DMInstall/source/bin -type f | xargs -i strip {} || true
	docker build --platform=linux/amd64 -t wention/dmdb:$@ .

dm8_20240408_full-amd64:
	find DMInstall/source/bin -type f | xargs -i strip {} || true
	docker build --platform=linux/amd64 -t wention/dmdb:$@ -f Dockerfile.full .

dm8_20231226-arm64:
	find DMInstall/source/bin -type f | xargs -i strip {} || true
	docker build --platform=linux/arm64 -t wention/dmdb:$@ .

dm8_20231226_full-arm64:
	find DMInstall/source/bin -type f | xargs -i strip {} || true
	docker build --platform=linux/arm64 -t wention/dmdb:$@ -f Dockerfile.full .

full:
	docker manifest rm wention/dmdb:full || true
	docker manifest create wention/dmdb:full wention/dmdb:dm8_20240408_full-amd64 wention/dmdb:dm8_20231226_full-arm64

latest:
	docker manifest rm wention/dmdb:latest || true
	docker manifest create wention/dmdb:latest wention/dmdb:dm8_20240408-amd64 wention/dmdb:dm8_20231226-arm64

push: full latest
	docker manifest push wention/dmdb:full
	docker manifest push wention/dmdb:latest


