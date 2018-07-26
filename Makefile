.PHONY=all build latest deploy

REPO=metal3d
LATEST_VERSION=6.0.8
versions=$(wildcard *.*.*)

all:
	$(MAKE) -B $(versions)

latest:
	$(MAKE) $(LATEST_VERSION)
	docker tag $(REPO)/ng:$(LATEST_VERSION) $(REPO)/ng:latest

*.*.*:
	@echo "BUILDING ---> $@"
	docker build -t $(REPO)/ng:$@ $@
	docker tag $(REPO)/ng:$@ $(REPO)/ng:$(basename $@)
	docker tag $(REPO)/ng:$(basename $@) $(REPO)/ng:$(basename $(basename $@))

deploy:
	docker push $(REPO)/ng
