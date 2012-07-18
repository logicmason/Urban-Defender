OUTPUT=example.swf
SOURCES=*.as ui/*.as Makefile

all: $(OUTPUT)

clean:
	rm -f $(OUTPUT)

run: $(OUTPUT)
	open $(OUTPUT)

example.swf: $(SOURCES)
	mxmlc \
		-static-link-runtime-shared-libraries \
		-default-frame-rate 25 \
		-default-size 600 500 \
		-use-network \
		-optimize=true \
		-output $@ \
		-frame=Core,Core \
		Init.as

.PHONY: all clean
