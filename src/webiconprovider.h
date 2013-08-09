#ifndef WEBICONPROVIDER_H
#define WEBICONPROVIDER_H

#include <QDeclarativeImageProvider>

class WebIconProvider : public QDeclarativeImageProvider
{
    Q_OBJECT
public:
    WebIconProvider();
    Q_INVOKABLE void setPixmap(QPixmap pixmap) { icon = pixmap; }
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:
    QPixmap icon;
signals:
    
public slots:
    
};

#endif // WEBICONPROVIDER_H
