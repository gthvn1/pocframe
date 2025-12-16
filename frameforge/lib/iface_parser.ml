let rec read_ifaces (ifaces : Yojson.Safe.t list) =
  match ifaces with
  | [] -> Printf.printf "done\n"
  | iface :: rest ->
      let open Yojson.Safe.Util in
      let ifname = iface |> member "ifname" |> to_string in
      let mac_addr = iface |> member "address" |> to_string in
      Printf.printf "Find dev %s with MAC %s\n" ifname mac_addr;
      read_ifaces rest

let parse_and_print_interfaces (json_str: string) =
  let json = Yojson.Safe.from_string json_str in
  Format.printf "Parsed to %a\n" Yojson.Safe.pp json;
  match json with
  | `List interfaces -> read_ifaces interfaces
  | _ -> Printf.printf "Found something else"
