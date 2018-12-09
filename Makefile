.PHONY=all build latest deploy

REPO=metal3d
MAJOR=7
versions=$(shell npm show "@angular/cli@*" version | sed "s/'//g" | awk '/@$(MAJOR)/{print $$2}')
LATEST_VERSION=$(lastword $(versions))

all:
	echo $(sort $(versions))
	for v in $(versions); do touch $$v; done
	$(MAKE) -B $(sort $(versions))

latest:
	docker tag $(REPO)/ng:$(LATEST_VERSION) $(REPO)/ng:latest

*.*.*:
	@echo "BUILDING ---> $@"
	docker build --build-arg VERSION=$@ -t $(REPO)/ng:$@ src/
	docker tag $(REPO)/ng:$@ $(REPO)/ng:$(basename $@)
	docker tag $(REPO)/ng:$(basename $@) $(REPO)/ng:$(basename $(basename $@))
	rm $@

deploy:
	docker push $(REPO)/ng

check:
	@echo node versions $(sort $(versions))
	@echo latest echo $(LATEST_VERSION)
