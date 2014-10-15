PROJECT = wilma_api
DEPS = cowboy jiffy erlydtl merl eunit_formatters erlang_protobuffs
dep_cowboy = git https://github.com/ninenines/cowboy 1.0.0
dep_jiffy = git https://github.com/davisp/jiffy 0.13.2
dep_merl = git https://github.com/erlydtl/merl master
dep_erlydtl = git https://github.com/erlydtl/erlydtl 0.9.4
dep_eunit_formatters = git https://github.com/seancribbs/eunit_formatters
dep_erlang_protobuffs = git https://github.com/basho/erlang_protobuffs 0.8.1

CT_SUITES = eunit
include erlang.mk

eunit: ERLC_OPTS = $(TEST_ERLC_OPTS) # to have -ifdef(TEST) working properly
eunit: clean app
	$(gen_verbose) erl -noshell -pa ebin -eval 'eunit:test({application, $(PROJECT)}, [no_tty, {report, {eunit_progress, [colored, profile]}}])' -s init stop
