# UniFi Voucher Generator

Generates UniFi Hotspot vouchers using the UniFi controller API ready for printing. Customize the design using CSS.

This should work on any Linux/Mac machine that can reach the UniFi controller.

## Setup

1. Clone the repo:

```
git clone https://github.com/updev-it/unifi-voucher-generator.git
```

2. Set the variables in `unifi_sh_env` with your controller's details (username, password, baseurl, site).

3. Optionally customise the variables in `gen.sh`.

## Run

1. Run `./gen.sh`.

2. Open `vouchers.html` and print!
