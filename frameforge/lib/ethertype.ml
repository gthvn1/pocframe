type t = Ether_ipv4 | Ether_ipv6 | Ether_arp | Ether_unknown of int

let to_string = function
  | Ether_ipv4 -> "IPv4"
  | Ether_ipv6 -> "IPv6"
  | Ether_arp -> "ARP"
  | Ether_unknown x -> Printf.sprintf "Unknown (0x%2X)" x

(** [is_dot1q b] check if the two bytes is 0x8100 that is IEEE 802.1Q *)
let is_dot1q (b : bytes) : bool =
  Bytes.length b >= 2
  && Bytes.get_uint8 b 0 = 0x81
  && Bytes.get_uint8 b 1 = 0x00
