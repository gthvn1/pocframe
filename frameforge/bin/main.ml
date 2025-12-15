let () =
  let socket_path = Args.parse () in
  Frameforge.(Server.run socket_path Ethernet_handler.handle)
