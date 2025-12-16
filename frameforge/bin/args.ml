type t = { socket_path : string; veth_name : string; veth_mac : string }

let parse () : t =
  if Array.length Sys.argv <> 4 then (
    prerr_endline
      "Usage: server <network as json> <veth device> <unix socket path>";
    exit 1);

  let json_str = Sys.argv.(1) in
  let veth_name = Sys.argv.(2) in
  let socket_path = Sys.argv.(3) in

  print_endline "----- Parameters -----";
  Printf.printf "Got jsong string : %s\n" json_str;
  Printf.printf "Veth device      : %s\n" veth_name;
  Printf.printf "Socket path      : %s\n" socket_path;

  match Frameforge.Iface.get ~name:veth_name json_str with
  | None ->
      raise
      @@ Invalid_argument
           (Printf.sprintf "Failed to find interface %s" veth_name)
  | Some iface -> { socket_path; veth_name; veth_mac = iface.mac }
