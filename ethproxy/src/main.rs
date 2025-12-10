use ethproxy::setup;

static VETHNAME: &str = "veth0";

fn main() {
    let veth = setup::Veth::init(VETHNAME);
    veth.create_device();
}
