use std::io::{self, Write};
//use ethproxy::setup;

//static VETHNAME: &str = "veth0";
//static VETHIP: &str = "192.168.35.1/24";

fn main() {
    //let veth = setup::Veth::init(VETHNAME, VETHIP);
    //veth.create_device();
    //veth.destroy_device();
    println!("Ctrl-C to quit");
    let mut input = String::new();

    loop {
        print!("> ");
        io::stdout().flush().unwrap();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        print!("your input is {input}");
    }
}
