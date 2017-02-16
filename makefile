erlfiles=$(wildcard src/*.erl)
beamfiles=$(patsubst src/%.erl, ebin/%.beam,$(erlfiles))

ebin/%.beam: src/%.erl
	@mkdir -p ebin
	@erlc -o ebin $<

all: $(beamfiles)

.PHONY: clean run

clean: 
	@rm -rf ebin
	@rm small.png

run: $(beamfiles) 
	@ cd ebin; \
	erl -noshell -s mandel demo -init stop
	@mv ebin/small.ppm small.ppm
	@convert small.ppm small.png
	@rm small.ppm
