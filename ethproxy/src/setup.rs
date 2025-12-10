use std::process::Command;

pub struct Veth {
    name: String,
    peer: String,
}

impl Veth {
    pub fn init(name: &str) -> Self {
        let peer = format!("{}-peer", name);
        Self {
            name: name.to_string(),
            peer,
        }
    }

    pub fn create_device(&self) {
        // man 4 veth
        // We need to run: ip link add <name> type veth peer name <peer>
        let ip_args = ["link", "show", &self.name];
        match Command::new("ip").args(ip_args).output() {
            Ok(output) => {
                println!("status: {}", output.status);
                println!("stdout: {:?}", output.stdout);
                println!("sderr : {:?}", output.stderr);
            }
            Err(error) => panic!("Probleme running ip: {error:?}"),
        };
    }
}
