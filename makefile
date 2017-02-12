ERLC=erlc
ERLCFLAGS=-o
SRCDIR=src
BEAMDIR=./ebin


.PHONY: all clean

all:
	@mkdir -p $(BEAMDIR) ;
	@$(ERLC) $(ERLCFLAGS) $(BEAMDIR) $(SRCDIR)/*.erl ;

clean: 
	@rm -rf $(BEAMDIR) ;
