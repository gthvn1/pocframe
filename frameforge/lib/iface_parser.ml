(* Currently we just need the mac address but it can evolve *)
type interface = { mac : string }

let found_iface name ifaces : interface option =
  let rec aux = function
    | [] -> None
    | iface :: rest ->
        let open Yojson.Safe.Util in
        let ifname = iface |> member "ifname" |> to_string in
        if ifname = name then
          let mac_addr = iface |> member "address" |> to_string in
          Some { mac = mac_addr }
        else aux rest
  in
  aux ifaces

let get_iface (name : string) (json_str : string) : interface option =
  let json = Yojson.Safe.from_string json_str in
  (* Format.printf "Parsed to %a\n" Yojson.Safe.pp json; *)
  match json with
  | `List interfaces -> found_iface name interfaces
  | _ -> failwith "Only `List is expected"
