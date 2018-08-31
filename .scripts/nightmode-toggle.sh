t=true

toggle() {
    $t && t=false || t=true;
}


trap "toggle" USR1

while true; do
    if $t ; then
        sct 2500
	echo 
    else
	sct
	echo 
    fi
    sleep 1 &
    wait
done
