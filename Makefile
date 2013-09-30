TEX_SOURCES = cv.tex kompetencer.tex
PDF_TARGETS = $(TEX_SOURCES:.tex=.pdf)
CONFIG_FILE = public_html.in
PUBLISH_DIR = $(shell if [[ -f $(CONFIG_FILE) ]]; then cat $(CONFIG_FILE); else echo $(HOME)/public_html; fi)

all: $(PDF_TARGETS)

%.pdf: %.tex
	date --date "$(shell git 2>/dev/null log $<|head -n3|awk '/^Date:/{print $$2,$$3,$$4,$$5,$$6}')" +"%F %H:%M" > $<.ts
	pdflatex $<

#if git 2>/dev/null status --porcelain $< | grep --silent $< \

publish:
	cp $(PDF_TARGETS) $(PUBLISH_DIR)

clean:
	rm -f $(PDF_TARGETS)
