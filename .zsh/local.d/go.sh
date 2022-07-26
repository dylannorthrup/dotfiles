## Golang Stuff
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export PATH="${PATH}:${GOBIN}"

vigo () {
  vim "${GOPATH}/src/$*/$*.go"
}

newgo () {
  if [ ! -d "${GOPATH}/src/$*" ]; then
    mkdir -p "${GOPATH}/src/$*"
  fi
  vigo $*
  go install "${GOPATH}/src/$*/$*.go"
}

grun () {
  if [ "${PWD}X" != "${GOPATH}X" ]; then
    cd $GOPATH
  fi
  export GOBIN="$GOPATH/bin"
  go install src/$*/$*.go
  if [ $? -eq 0 ]; then
    $*
  else
    echo "Problem doing a go install of src/$*/$*.go"
  fi
}

