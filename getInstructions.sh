
read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    local ret=$?
    TAG_NAME=${ENTITY%% *}
    ATTRIBUTES=${ENTITY#* }
    return $ret
}

parse_dom () {
    if [[ $TAG_NAME = "counter" ]] ; then
        eval local $ATTRIBUTES
        if [[ $type = "INSTRUCTION" ]] ; then
            MISSED=$missed
            COVERED="${covered::-1}"
            TOT=$(($MISSED + $COVERED))
         fi
     fi
}

while read_dom; do
    parse_dom
done < ../target/site/jacoco/jacoco.xml
echo "$TOT" 