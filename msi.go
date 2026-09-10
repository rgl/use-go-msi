package main

import (
	"fmt"
	"os"

	"go.digitalxero.dev/go-msi"
)

func buildMSI(destinationPath string) error {
	f, err := os.Create(destinationPath)
	if err != nil {
		return err
	}
	defer f.Close()

	title := "Use go-msi Unsigned"

	builder := msi.NewPackage().
		WithAllUsers(true).
		WithProductName(title).
		WithVersion("0.0.0.0").
		WithManufacturer("Example").
		WithProductCode("{401D679C-A1DF-4AD4-B7DC-E715471ADCE5}").
		WithUpgradeCode("{2DEF3E8C-CA8E-4987-B183-44C6C9836A02}").
		InstallToProgramFiles()

	builder.
		Feature("app").
		WithTitle(title).
		WithLevel(1)

	iconFileSource, err := msi.FileSourceFromPath("main.ico")
	if err != nil {
		return fmt.Errorf("cannot infer file source from the main icon path: %w", err)
	}
	builder.Icon("app", iconFileSource)

	install := builder.
		RootDirectory("INSTALLFOLDER", "use-go-msi")

	component := install.
		Component("app").
		AssociateToFeature("app")

	component.
		WithFilePath("use-go-msi.exe", "use-go-msi.exe")

	component.
		Shortcut(fmt.Sprintf("%s.lnk", title), "[INSTALLFOLDER]use-go-msi.exe").
		InDirectory("ProgramMenuFolder").
		Description(fmt.Sprintf("Launch %s", title)).
		Icon("app", 0)

	pkg, err := builder.Build()
	if err != nil {
		return err
	}

	return pkg.WriteMSI(f)
}
