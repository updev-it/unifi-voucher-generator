#!/bin/sh

# Files needed
pwd=`pwd`
. $pwd/unifi-api.sh

# Generation settings
time=$((60*24)) # Voucher time limit (minutes)
amount=64 # New vouchers to generate

# HTML Settings
line1="SkyNet Voucher"
line2="Valid for 24 hours"

# Generate vouchers
unifi_login
voucherID=`unifi_create_voucher $time $amount $note`
unifi_get_vouchers $voucherID > vouchers.tmp
unifi_logout

vouchers=`awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/code\042/){print $(i+1)} } }' vouchers.tmp | sed 's/\"//g'`

# Build HTML
if [ -e vouchers.html ]; then
  echo "Removing old vouchers."
  rm vouchers.html
fi

cat > vouchers.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css" integrity="sha256-46qynGAkLSFpVbEBog43gvNhfrOj+BmwXdxFgVK/Kvc=" crossorigin="anonymous" />
    <style>
      body {
        color: #444;
        font-family: -apple-system, system-ui, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      }

      .voucher {
        float: left;

        margin: -1px 0 0 -1px;
        padding: 8px 12px;

        border: 1px dashed #ddd;
      }

      @media print {
        div {
          page-break-inside: avoid;
        }
      }

      .line1 {
        display: inline-block;

        max-width: 150px;

        font-size: 16px;
        line-height: 22px;
      }

      .line2 {
        float: right;

        margin: 2px 0 0 20px;

        color: #777;
        font-size: 12px;
        line-height: 20px;
      }

      .line3 {
        padding-top: 10px;

        font-weight: lighter;
        font-size: 26px;
        line-height: 34px;
        letter-spacing: 2px;
      }
    </style>
  </head>
  <body>
EOF

for code in $vouchers
do
    # line3=${code:0:5}" "${code:5:10}
    line3=${code:0:2}" "${code:2:2}" "${code:4:2}" "${code:6:2}" "${code:8:2}
    html='<div class="voucher"><div class="line1"><i class="fas fa-wifi"></i> '$line1'</div><div class="line2">'$line2'</div><div class="line3">'$line3'</div></div>'
    echo $html >> vouchers.html
done

cat >> vouchers.html <<EOF
</body>
</html>
EOF

# Remove tmp
if [ -e vouchers.tmp ]; then
  echo "Removing vouchers tmp file."
  rm vouchers.tmp
fi
