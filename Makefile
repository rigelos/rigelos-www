DOCS := index intro tutorial guide guide-ffi guide-macros guide-lifetimes \
	guide-tasks guide-container guide-pointers guide-testing \
	guide-plugin guide-crates complement-bugreport guide-error-handling \
	complement-lang-faq complement-design-faq complement-project-faq \
    rustdoc guide-unsafe guide-strings reference

D := $(S)src/doc
DOC_TARGETS := 

RUSTDOC_HTML_OPTS_NO_CSS = --html-before-content=src/doc/version_info.html.template \
	--html-in-header=src/doc/favicon.inc \
	--html-after-content=src/doc/footer.inc \
	--markdown-playground-url='http://play.rust-lang.org/'

RUSTDOC_HTML_OPTS = $(RUSTDOC_HTML_OPTS_NO_CSS) --markdown-css rust.css

define DEF_DOC
# HTML (rustdoc)
DOC_TARGETS += $(1)
$(1): src/doc/$(1).md
	@rustdoc src/doc/$(1).md $$(RUSTDOC_HTML_OPTS)
endef

$(foreach docname,$(DOCS),$(eval $(call DEF_DOC,$(docname))))

doc/:
	mkdir -p $@

HTML_DEPS += doc/rust.css
doc/rust.css: $(D)/rust.css | doc/
	cp $(D)/rust.css doc/

docs: $(HTML_DEPS) $(DOC_TARGETS)
clean:
	rm -rf doc