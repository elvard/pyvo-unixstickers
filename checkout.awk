#!/usr/bin/gawk -f

1 == NR {
    contacts[FILENAME] = $0
}

/\d+/ {
    qty = $1
    $1 = ""
    product = substr($0, 2)
    checkout[product] = checkout[product] + qty
}

END {
    for (product in checkout) {
        print checkout[product] "x", product
    }
}
