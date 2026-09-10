# About

Use the [digitalxero/go-msi](https://github.com/digitalxero/go-msi) library to create a MSI package.

## Develop

Install [Chocolatey](https://chocolatey.org/install).

Install [MSYS2](https://community.chocolatey.org/packages/msys2), [Go](https://community.chocolatey.org/packages/go), and [LessMSI](https://github.com/activescott/lessmsi):

```batch
choco install -y msys2 --params="'/NoPath'"
choco install -y go
choco install -y lessmsi
```

Execute the following commands in a MSYS2 `bash` session.

Build the application and the MSI:

```bash
go generate ./...
CGO_ENABLED=0 GOAMD64=v3 go build -trimpath -ldflags "-s -w"
./use-go-msi.exe build-msi
```

Install the unsigned MSI:

```bash
lessmsi l -t _Tables use-go-msi-unsigned.msi
lessmsi l -t Property use-go-msi-unsigned.msi
lessmsi l -t Feature use-go-msi-unsigned.msi
lessmsi l -t FeatureComponents use-go-msi-unsigned.msi
lessmsi l -t Component use-go-msi-unsigned.msi
lessmsi l -t File use-go-msi-unsigned.msi
lessmsi l -t Icon use-go-msi-unsigned.msi
lessmsi l -t Directory use-go-msi-unsigned.msi
lessmsi l -t Shortcut use-go-msi-unsigned.msi
msiexec -i use-go-msi-unsigned.msi -qn -norestart '-l*v' install.log || echo "ERROR: $(cat install.log)"
find /c/Program\ Files/use-go-msi -type f
```

Uninstall with one of:

```bash
msiexec -x use-go-msi-unsigned.msi -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
msiexec -x '{401D679C-A1DF-4AD4-B7DC-E715471ADCE5}' -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
```

## References

* https://github.com/digitalxero/go-msi
* https://thesvg.org/icon/gopher
