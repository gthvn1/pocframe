let () =
  let socket_path = Args.parse () in
  let open Frameforge in
  Server.run socket_path Ethernet_handler.handle
