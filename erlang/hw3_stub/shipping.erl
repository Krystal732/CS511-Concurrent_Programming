-module(shipping).
-compile(export_all).
-include_lib("./shipping.hrl").

get_ship([], _) -> error;
get_ship([H|T], N) ->
    if
        H#ship.id == N -> H;
        true -> get_ship(T, N)
    end;
get_ship(Shipping_State, Ship_ID) ->
    get_ship(Shipping_State#shipping_state.ships, Ship_ID).


get_container([], _) -> error;
get_container([H|T], N) ->
    if
        H#container.id == N -> H;
        true -> get_container(T, N)
    end;
get_container(Shipping_State, Container_ID) ->
    get_container(Shipping_State#shipping_state.containers, Container_ID).
    

get_port([], _) -> error;
get_port([H|T], N) ->
    if
        H#port.id == N -> H;
        true -> get_port(T, N)
    end;
get_port(Shipping_State, Port_ID) ->
    get_port(Shipping_State#shipping_state.ports, Port_ID).    

dock_help([], L) -> L;
dock_help([H|T], L) -> 
    {_,DiD,_} = H, dock_help(T, L++[DiD]).

get_occupied_docks(Shipping_State, Port_ID) ->
    D = lists:filter(fun(Nooo)->
        case Nooo of 
            {PoID,_,_} -> PoID == Port_ID;
            _->false end 
        end, Shipping_State#shipping_state.ship_locations),
    dock_help(D, []).


get_ship_location(Shipping_State, Ship_ID) ->
    case lists:keyfind(Ship_ID, 3, Shipping_State#shipping_state.ship_locations) of
        {P, D, _} -> {P, D};
        _ -> error end.


weight_help([], S) -> S;
weight_help([H|T], S) -> 
    weight_help(T, S+H#container.weight).


cid_list ([], L) -> L;
cid_list ([H|T], L) ->
    cid_list(T,L ++ [H#container.id]).


get_container_weight(Shipping_State, Container_IDs) ->
    case is_sublist(cid_list(Shipping_State#shipping_state.containers, []), Container_IDs) of
        true -> 
                W = lists:filter(fun(Nooo)-> lists:member(Nooo#container.id, Container_IDs) end, Shipping_State#shipping_state.containers),
                weight_help(W, 0);
        _ -> error end.
    

get_ship_weight(Shipping_State, Ship_ID) ->
    case maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error) of
        error -> error;
        L -> get_container_weight(Shipping_State, L)
    end.

%make sure containers are on same port as ship -> error
%check ship capactiy -> error
load_check(Shipping_State, Port_ID, Ship_ID, Container_IDs) ->
    L = is_sublist(maps:get(Port_ID, Shipping_State#shipping_state.port_inventory, error), Container_IDs),
    S = get_ship(Shipping_State, Ship_ID),
    C = S#ship.container_cap,
    ((length(maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error)) + length(Container_IDs)) =< C) and L.

move_to_ship(Shipping_State, Port_ID, Ship_ID, Container_IDs) ->
    R = lists:filter(fun (E) -> not lists:member(E, Container_IDs) end, maps:get(Port_ID, Shipping_State#shipping_state.port_inventory)),
    PI = maps:update(Port_ID, R,Shipping_State#shipping_state.port_inventory),
    SI = maps:update(Ship_ID, maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error) ++ Container_IDs, Shipping_State#shipping_state.ship_inventory ),
    Shipping_State#shipping_state{port_inventory = PI,ship_inventory = SI}.

load_ship(Shipping_State, Ship_ID, Container_IDs) ->
    case get_ship_location(Shipping_State, Ship_ID) of
        {P, _} ->     case load_check(Shipping_State, P, Ship_ID, Container_IDs) of
                        true -> move_to_ship(Shipping_State, P, Ship_ID, Container_IDs);
                        false -> error
                    end;
        _ -> error
    end.



    
unload_ship_all(Shipping_State, Ship_ID) ->
    unload_ship(Shipping_State, Ship_ID, maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error)).

unload_check(Shipping_State, Port_ID, Ship_ID, Container_IDs) ->
    L = is_sublist(maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error), Container_IDs),
    S=get_port(Shipping_State, Port_ID),
    C = S#port.container_cap,
    ((length(maps:get(Port_ID, Shipping_State#shipping_state.port_inventory, error)) + length(Container_IDs)) =< C) and L.

move_to_port(Shipping_State, Port_ID, Ship_ID, Container_IDs) ->
    R = lists:filter(fun (E) -> not lists:member(E, Container_IDs) end, maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory)),
    PI = maps:update(Ship_ID, R,Shipping_State#shipping_state.ship_inventory),
    SI = maps:update(Port_ID, maps:get(Port_ID, Shipping_State#shipping_state.port_inventory, error) ++ Container_IDs, Shipping_State#shipping_state.port_inventory ),
    Shipping_State#shipping_state{ship_inventory = PI,port_inventory = SI}.


unload_ship(Shipping_State, Ship_ID, Container_IDs) ->
    case get_ship_location(Shipping_State, Ship_ID) of
        {P, _} -> case unload_check(Shipping_State, P, Ship_ID, Container_IDs) of
                        true -> move_to_port(Shipping_State, P, Ship_ID, Container_IDs);
                        false -> error
                    end;
        _ -> error end.


ship_check(Shipping_State, Ship_ID) ->
    case get_ship(Shipping_State, Ship_ID) of 
        error -> false;
        _ -> true
    end.

dock_check(Shipping_State, {Port_ID, Dock}) ->
    case get_port(Shipping_State, Port_ID) of 
        error -> false;
        P -> case lists:member(Dock, P#port.docks) of
                true -> true;
                _ -> false end
    end.

set_sail(Shipping_State, Ship_ID, {Port_ID, Dock}) ->
    case not lists:member(Dock, get_occupied_docks(Shipping_State, Port_ID)) and  (ship_check(Shipping_State, Ship_ID)  and dock_check(Shipping_State, {Port_ID, Dock})) of 
        true -> Shipping_State#shipping_state{ship_locations = lists:keyreplace(Ship_ID, 3, Shipping_State#shipping_state.ship_locations, {Port_ID, Dock, Ship_ID})};
        false -> error
    end.




%% Determines whether all of the elements of Sub_List are also elements of Target_List
%% @returns true is all elements of Sub_List are members of Target_List; false otherwise
is_sublist(Target_List, Sub_List) ->
    lists:all(fun (Elem) -> lists:member(Elem, Target_List) end, Sub_List).




%% Prints out the current shipping state in a more friendly format
print_state(Shipping_State) ->
    io:format("--Ships--~n"),
    _ = print_ships(Shipping_State#shipping_state.ships, Shipping_State#shipping_state.ship_locations, Shipping_State#shipping_state.ship_inventory, Shipping_State#shipping_state.ports),
    io:format("--Ports--~n"),
    _ = print_ports(Shipping_State#shipping_state.ports, Shipping_State#shipping_state.port_inventory).


%% helper function for print_ships
get_port_helper([], _Port_ID) -> error;
get_port_helper([ Port = #port{id = Port_ID} | _ ], Port_ID) -> Port;
get_port_helper( [_ | Other_Ports ], Port_ID) -> get_port_helper(Other_Ports, Port_ID).


print_ships(Ships, Locations, Inventory, Ports) ->
    case Ships of
        [] ->
            ok;
        [Ship | Other_Ships] ->
            {Port_ID, Dock_ID, _} = lists:keyfind(Ship#ship.id, 3, Locations),
            Port = get_port_helper(Ports, Port_ID),
            {ok, Ship_Inventory} = maps:find(Ship#ship.id, Inventory),
            io:format("Name: ~s(#~w)    Location: Port ~s, Dock ~s    Inventory: ~w~n", [Ship#ship.name, Ship#ship.id, Port#port.name, Dock_ID, Ship_Inventory]),
            print_ships(Other_Ships, Locations, Inventory, Ports)
    end.

print_containers(Containers) ->
    io:format("~w~n", [Containers]).

print_ports(Ports, Inventory) ->
    case Ports of
        [] ->
            ok;
        [Port | Other_Ports] ->
            {ok, Port_Inventory} = maps:find(Port#port.id, Inventory),
            io:format("Name: ~s(#~w)    Docks: ~w    Inventory: ~w~n", [Port#port.name, Port#port.id, Port#port.docks, Port_Inventory]),
            print_ports(Other_Ports, Inventory)
    end.
%% This functions sets up an initial state for this shipping simulation. You can add, remove, or modidfy any of this content. This is provided to you to save some time.
%% @returns {ok, shipping_state} where shipping_state is a shipping_state record with all the initial content.
shipco() ->
    Ships = [#ship{id=1,name="Santa Maria",container_cap=20},
              #ship{id=2,name="Nina",container_cap=20},
              #ship{id=3,name="Pinta",container_cap=20},
              #ship{id=4,name="SS Minnow",container_cap=20},
              #ship{id=5,name="Sir Leaks-A-Lot",container_cap=20}
             ],
    Containers = [
                  #container{id=1,weight=200},
                  #container{id=2,weight=215},
                  #container{id=3,weight=131},
                  #container{id=4,weight=62},
                  #container{id=5,weight=112},
                  #container{id=6,weight=217},
                  #container{id=7,weight=61},
                  #container{id=8,weight=99},
                  #container{id=9,weight=82},
                  #container{id=10,weight=185},
                  #container{id=11,weight=282},
                  #container{id=12,weight=312},
                  #container{id=13,weight=283},
                  #container{id=14,weight=331},
                  #container{id=15,weight=136},
                  #container{id=16,weight=200},
                  #container{id=17,weight=215},
                  #container{id=18,weight=131},
                  #container{id=19,weight=62},
                  #container{id=20,weight=112},
                  #container{id=21,weight=217},
                  #container{id=22,weight=61},
                  #container{id=23,weight=99},
                  #container{id=24,weight=82},
                  #container{id=25,weight=185},
                  #container{id=26,weight=282},
                  #container{id=27,weight=312},
                  #container{id=28,weight=283},
                  #container{id=29,weight=331},
                  #container{id=30,weight=136}
                 ],
    Ports = [
             #port{
                id=1,
                name="New York",
                docks=['A','B','C','D'],
                container_cap=200
               },
             #port{
                id=2,
                name="San Francisco",
                docks=['A','B','C','D'],
                container_cap=200
               },
             #port{
                id=3,
                name="Miami",
                docks=['A','B','C','D'],
                container_cap=200
               }
            ],
    %% {port, dock, ship}
    Locations = [
                 {1,'B',1},
                 {1, 'A', 3},
                 {3, 'C', 2},
                 {2, 'D', 4},
                 {2, 'B', 5}
                ],
    Ship_Inventory = #{
      1=>[14,15,9,2,6],
      2=>[1,3,4,13],
      3=>[],
      4=>[2,8,11,7],
      5=>[5,10,12]},
    Port_Inventory = #{
      1=>[16,17,18,19,20],
      2=>[21,22,23,24,25],
      3=>[26,27,28,29,30]
     },
    #shipping_state{ships = Ships, containers = Containers, ports = Ports, ship_locations = Locations, ship_inventory = Ship_Inventory, port_inventory = Port_Inventory}.
