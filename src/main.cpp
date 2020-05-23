#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QIcon>
#include <QQuickStyle>
#include "src/VolumesListModel.hpp"
#include "src/SearchEngine.hpp"
#include "src/SearchConfig.hpp"
#include "src/DuplicatesFinder.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setApplicationName("LARGEST");
    app.setApplicationVersion(QString(VERSION));
    app.setApplicationDisplayName("LARGEST APP");
    app.setOrganizationDomain("largestapp.com");
    app.setWindowIcon(QIcon(":/app.ico"));

    QFontDatabase::addApplicationFont(":/fonts/Roboto-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Roboto-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/MaterialIcons-Regular.ttf");
    app.setFont(QFont("Roboto"));

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/");
    engine.addImportPath("qrc:/qml");
    engine.rootContext()->setContextProperty("version", VERSION);

    qmlRegisterType<VolumesListModel>("NativeComponents", 1, 0, "VolumesListModel");
    qmlRegisterType<SearchEngine>("NativeComponents", 1, 0, "SearchEngine");
    qmlRegisterType<SearchConfig>("NativeComponents", 1, 0, "SearchConfig");
    qmlRegisterType<DuplicatesFinder>("NativeComponents", 1, 0, "DuplicatesFinder");

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
