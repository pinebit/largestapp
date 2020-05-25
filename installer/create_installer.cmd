pushd packages\com.largestapp.desktop\data
c:\qt\5.14.1\msvc2017_64\bin\windeployqt.exe --qmldir c:\GitHub\LargestApp\qml LargestApp.exe
popd
c:\qt\Tools\QtInstallerFramework\3.2\bin\binarycreator.exe -c config\config.xml -p packages LargestAppInstaller.exe
