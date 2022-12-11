```
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@17/"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"' >> ~/.zshrc

source ~/.zshrc
java -version
```

安装 sdkman

```
curl -s "https://get.sdkman.io" | bash
source "/Users/qinxin/.sdkman/bin/sdkman-init.sh"
sdk help
```

安装 gradle

```
sdk install gradle 7.6

echo 'export GRADLE_HOME="/Users/qinxin/.sdkman/candidates/gradle/current/"' >> ~/.zshrc
echo 'export PATH=$GRADLE_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

gradle --help
```