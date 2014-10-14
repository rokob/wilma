-module(index_handler).

-export([init/3, rest_init/2]).
-export([content_types_provided/2]).
-export([get_html/2]).

init(_, _Req, _Opts) ->
  random:seed(now()),
  {upgrade, protocol, cowboy_rest}.

rest_init(Req, [Type]) ->
  {ok, Req, Type}.

content_types_provided(Req, State) ->
  {[{{<<"text">>, <<"html">>, '*'}, get_html}], Req, State}.

get_html(Req, State) ->
  Id = new_random_id(),
  Vars = [{server, Id}],
  Vars2 = case State of
    web ->
      [{version, 1} | Vars];
    api ->
      {Version, _} = cowboy_req:binding(version, Req, 0),
      [{version, Version} | Vars]
    end,
  {ok, Body} = index_dtl:render(Vars2),
  {Body, Req, State}.

% Private

new_random_id() ->
  Initial = random:uniform(62) - 1,
  new_random_id(<<Initial>>, 7).

new_random_id(Bin, 0) ->
  Chars = <<"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890">>,
  << <<(binary_part(Chars, B, 1))/binary>> || <<B>> <= Bin >>;
new_random_id(Bin, Rem) ->
  Next = random:uniform(62) - 1,
  new_random_id(<<Bin/binary, Next>>, Rem - 1).
