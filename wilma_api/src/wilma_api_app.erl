% @author Andrew Ledvina <wvvwwvw@gmail.com>
% @copyright Andrew Ledvina, 2014
% @doc API Application
% @end

-module(wilma_api_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-define(APPNAME, wilma_api).

% @doc Start the app
% @end
start(_Type, _Args) ->
  cowboy:start_http(wilma_api_listener, 100, [{port, 8080}],
    [{env, [{dispatch, dispatch()}]}]
  ),
  wilma_api_sup:start_link().

% @doc Stop the app
% @end
stop(_State) ->
  ok.

% Private

dispatch() ->
  cowboy_router:compile([
    {<<"api.wilma.com">>, api_routes()},
    {<<"[www.]wilma.com">>, web_routes()}
  ]).

web_routes() ->
  [
    {"/assets/[...]", cowboy_static, {priv_dir, ?APPNAME, "static/assets"}},
    {"/", index_handler, [web]}
  ].

api_routes() ->
  [
    {"/assets/[...]", cowboy_static, {priv_dir, ?APPNAME, "static/assets"}},
    {"/:version", [{version, function, fun is_version/1}], index_handler, [api]},
    {"/:version/auth", [{version, function, fun is_version/1}], auth_handler, []}
  ].

is_version(Value) when is_binary(Value) ->
  try
    [$v | Num] = binary_to_list(Value),
    {true, list_to_integer(Num)}
  catch 
    _:_ -> false
  end.
