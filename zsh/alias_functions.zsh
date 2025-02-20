
pprint() {
    # usage: pprint path
    for v in ${(P)1}; echo $v
}

tssh() {
    ssh $1 -t "tmux new -A"
}
    