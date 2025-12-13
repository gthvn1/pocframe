let () =
  if Array.length Sys.argv < 3 then (
    prerr_endline "Usage: server <network as json> <unix socket>";
    exit 1);

  let open Frameforge in
  let json_str = Sys.argv.(1) in
  print_endline json_str;
  let socket_path = Sys.argv.(2) in
  Server.run socket_path Ethernet_handler.handle
