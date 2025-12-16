let () =
  let arg = Args.parse () in
  Frameforge.Server.run arg.socket_path
