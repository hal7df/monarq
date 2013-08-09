#include "webiconprovider.h"

WebIconProvider::WebIconProvider() :
    QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap)
{
}

QPixmap WebIconProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    int width = 50;
    int height = 50;

    if (size)
        *size = QSize(width,height);

    if (id == "icon")
    {
        icon.scaled(requestedSize.width() > 0 ? requestedSize.width() : width, requestedSize.height() > 0 ? requestedSize.height() : height);
        return icon;
    }
    else if (id == "nothing")
    {
        QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width, requestedSize.height() > 0 ? requestedSize.height() : height);
        pixmap.fill(QColor("#00000000").rgba());

        return pixmap;
    }
    else
    {
        QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width, requestedSize.height() > 0 ? requestedSize.height() : height);
        pixmap.fill(QColor(id).rgba());

        return pixmap;
    }
}
