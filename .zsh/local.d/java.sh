# Java-specific settings
if [[ ${UNAME_KERNEL} == "Linux" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-14-openjdk-amd64"
  export PATH=${PATH}:${JAVA_HOME}/bin
elif [[ ${UNAME_KERNEL} == "Darwin" ]]; then
  export JAVA_17_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
  export JAVA_HOME=$JAVA_17_HOME
  export PATH=$JAVA_HOME/bin:$PATH
else
  echo "Not a configured Java platform"
  return
fi
