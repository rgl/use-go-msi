# About

Use the [digitalxero/go-msi](https://github.com/digitalxero/go-msi) library to create a MSI package.

## Develop

Install [Chocolatey](https://chocolatey.org/install).

Install [MSYS2](https://community.chocolatey.org/packages/msys2) and [Go](https://community.chocolatey.org/packages/go):

```batch
choco install -y msys2 --params="'/NoPath'"
choco install -y go
```

Execute the following commands in a MSYS2 `bash` session.

Build and execute the application:

```bash
go generate ./...
CGO_ENABLED=0 GOAMD64=v3 go build -trimpath -ldflags "-s -w"
./use-go-msi.exe
```

## References

* https://github.com/digitalxero/go-msi
* https://thesvg.org/icon/gopher
