function Component()
{
    if (systemInfo.productType === "osx" && installer.isInstaller()) {
        installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
        installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
        installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);
        installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
    }
}

Component.prototype.createOperations = function()
{
    component.createOperations();

    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut", "@TargetDir@/LargestApp.exe", "@StartMenuDir@/LargestApp.lnk",
            "workingDirectory=@TargetDir@", "description=Open Largest App");
        component.addOperation("CreateShortcut", "@TargetDir@/maintenancetool.exe", "@StartMenuDir@/Uninstall Largest App.lnk",
            "workingDirectory=@TargetDir@", "description=Uninstall Largest App");
                component.addOperation("CreateShortcut", "@TargetDir@/LargestApp.exe", "@DesktopDir@/LargestApp.lnk",
            "workingDirectory=@TargetDir@", "description=Open Largest App");

    }

    installer.installationFinished.connect(this, onFinished);
}

onFinished = function()
{
    gui.clickButton(buttons.NextButton);
}
