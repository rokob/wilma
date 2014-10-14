-module(auth_handler).

-export([init/3]).
-export([allowed_methods/2, content_types_provided/2, content_types_accepted/2]).
-export([get_json/2]).
-export([from_json/2]).

init(_, _Req, _Opts) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[<<"GET">>, <<"PUT">>, <<"POST">>], Req, State}.

content_types_provided(Req, State) ->
  JSON = {{<<"application">>, <<"json">>, '*'}, get_json},
  ContentTypes = [JSON],
  {ContentTypes, Req, State}.

content_types_accepted(Req, State) ->
  {[{{<<"application">>, <<"json">>, []}, from_json}], Req, State}.

get_json(Req, State) ->
  {Version, _} = cowboy_req:binding(version, Req, 1),
  Result = jiffy:encode({[{<<"version">>, Version}]}),
  {Result, Req, State}.

from_json(Req, State) ->
  {true, Req, State}.
