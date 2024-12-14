# Notes

## Missing language configs

### DOTNET

```
pacman(
	"dotnet-sdk",
	"dotnet-sdk-6.0",
	"dotnet-sdk-7.0",
	"dotnet-runtime",
	"dotnet-runtime-6.0",
	"dotnet-runtime-7.0",
	"mono",
	"nuget",
	"aspnet-runtime",
	"aspnet-runtime-6.0",
	"aspnet-runtime-7.0"
);
```

Install netcoredbg

### ELIXIR+ERLANG

```
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
KERL_BUILD_DOCS="yes" asdf install erlang latest
asdf global erlang latest

asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
KERL_BUILD_DOCS="yes" asdf install elixir latest
asdf global elixir latest
```

### JAVA

```
pacman maven

asdf plugin add erlang https://github.com/halcyon/asdf-java.git

asdf install java openjdk-11:latest
asdf install java openjdk-13:latest
asdf install java openjdk-17:latest

export JAVA_HOME="$(asdf which java | sed 's/bin.java$//')"
```

### RUST

```
sudo pacman -S --noconfirm rustup &&
  rustup default nightly &&
  return "$OK"
```
