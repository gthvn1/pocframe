let () =
  if Array.length Sys.argv <> 4 then (
    prerr_endline
      "Usage: server <network as json> <veth device> <unix socket path>";
    exit 1);

  let open Frameforge in
  let json_str = Sys.argv.(1) in
  let veth_device = Sys.argv.(2) in
  let socket_path = Sys.argv.(3) in
  print_endline "----- Parameters -----";
  Printf.printf "Got jsong string : %s\n" json_str;
  Printf.printf "Veth device      : %s\n" veth_device;
  Printf.printf "Socket path      : %s\n" socket_path;
  (* TODO: find information about veth device in json before calling server and pass the info.
     We will need at least the MAC address. *)
  Server.run socket_path Ethernet_handler.handle
