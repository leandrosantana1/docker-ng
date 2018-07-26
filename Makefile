REPO=metal3d
.PHONY=all build

version=$(wildcard *.*.*)

all:
	echo $(version)
	$(MAKE) -B $(version)

*.*.*:
	@echo "BUILDING ---> $@"
	docker build -t $(REPO)/ng:$@ $@
