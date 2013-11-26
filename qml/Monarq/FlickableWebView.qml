/****************************************************************************
 ** Thanks to the KDE Plasma Active team for pinch support.
 **
 ** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
 ** All rights reserved.
 ** Contact: Nokia Corporation (qt-info@nokia.com)
 **
 ** This file is part of the QtDeclarative module of the Qt Toolkit.
 **
 ** $QT_BEGIN_LICENSE:LGPL$
 ** GNU Lesser General Public License Usage
 ** This file may be used under the terms of the GNU Lesser General Public
 ** License version 2.1 as published by the Free Software Foundation and
 ** appearing in the file LICENSE.LGPL included in the packaging of this
 ** file. Please review the following information to ensure the GNU Lesser
 ** General Public License version 2.1 requirements will be met:
 ** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
 **
 ** In addition, as a special exception, Nokia gives you certain additional
 ** rights. These rights are described in the Nokia Qt LGPL Exception
 ** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
 **
 ** GNU General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU General
 ** Public License version 3.0 as published by the Free Software Foundation
 ** and appearing in the file LICENSE.GPL included in the packaging of this
 ** file. Please review the following information to ensure the GNU General
 ** Public License version 3.0 requirements will be met:
 ** http://www.gnu.org/copyleft/gpl.html.
 **
 ** Other Usage
 ** Alternatively, this file may be used in accordance with the terms and
 ** conditions contained in a signed written agreement between you and Nokia.
 **
 **
 **
 **
 **
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

 import QtQuick 1.1
 import QtWebKit 1.0

 Flickable {
     property alias title: webView.title
     property url icon: getFavicon()
     property alias progress: webView.progress
     property bool loading: webView.progress != 1
     property url url: webView.url
     property alias html: webView.html
     property alias back: webView.back
     property alias forward: webView.forward
     property alias settings: webView.settings
     property alias contentsScale: webView.contentsScale
     signal loadFinished

     id: flickable
     width: parent.width
     contentWidth: Math.max(parent.width,webView.width)
     contentHeight: Math.max(parent.height,webView.height)
     anchors.fill: parent
     pressDelay: 200
     boundsBehavior: Flickable.StopAtBounds

     onWidthChanged : {
         // Expand (but not above 1:1) if otherwise would be smaller that available width.
         if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
             webView.contentsScale = width / webView.width * webView.contentsScale;
     }

     onUrlChanged: {
         url=webView.fixUrl(url);
         webView.url = url;
     }

     function goBack()
     {
         webView.back.trigger();
     }
     function goForward()
     {
         webView.forward.trigger();
     }
     function stop()
     {
         webView.stop.trigger();
     }
     function reload()
     {
         webView.reload.trigger();
     }
     function loadUrl ()
     {
         webView.fixUrl();
     }

     function getFavicon (url)
     {
         var prefix;
         var colonPosition;
         var slashPosition;
         var fUrl

         fUrl = url.toString();

         colonPosition = fUrl.indexOf(":");
         slashPosition = fUrl.indexOf("/");

         while (slashPosition != colonPosition+1)
         {
             fUrl = fUrl.substring(slashPosition+1,fUrl.length-1);
             colonPosition = fUrl.indexOf(":");
             slashPosition = fUrl.indexOf("/")
         }

         prefix = fUrl.substring(0,colonPosition+2);
         fUrl = fUrl.substring(colonPosition+3,fUrl.length-1);
         fUrl = fUrl.substring(0,slashPosition);
         return prefix+fUrl+"favicon.ico";
     }

     PinchArea {
         id: pinchZoomer
         anchors.fill: parent
         pinch.target: webView
     }

     WebView {
         id: webView
         transformOrigin: Item.TopLeft

         function fixUrl(fUrl)
         {
             if (fUrl == "") return fUrl;
             else return fUrl;
             /*if (fUrl.indexOf(":")<0) {
                 if (fUrl.indexOf(".")<0 || fUrl.indexOf(" ")>=0) {
                     // Run search query through Google
                     return "https://encrypted.google.com/search?q="+fUrl;
                 } else {
                     return "http://"+fUrl;
                 }
             }
             return fUrl;*/
         }

         url: "start.html"
         smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
         focus: true

         onAlert: console.log(message)

         function doZoom(zoom,centerX,centerY)
         {
             if (centerX) {
                 var sc = zoom*contentsScale;
                 scaleAnim.to = sc;
                 flickVX.from = flickable.contentX
                 flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,webView.width*sc-flickable.width))
                 finalX.value = flickVX.to
                 flickVY.from = flickable.contentY
                 flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,webView.height*sc-flickable.height))
                 finalY.value = flickVY.to
                 quickZoom.start()
             }
         }

         Keys.onLeftPressed: webView.contentsScale -= 0.1
         Keys.onRightPressed: webView.contentsScale += 0.1

         settings.pluginsEnabled: true
         settings.offlineWebApplicationCacheEnabled: true
         settings.offlineStorageDatabaseEnabled: true
         settings.localStorageDatabaseEnabled: true

         contentsScale: 1
         onLoadFinished: flickable.onLoadFinished
         onContentsSizeChanged: {
             // zoom out
             contentsScale = Math.min(1,flickable.width / contentsSize.width)
         }
         onUrlChanged: {
             // got to topleft
             flickable.contentX = 0
             flickable.contentY = 0
             url = fixUrl(url);
         }
         onDoubleClick: {
                         if (!heuristicZoom(clickX,clickY,2.5)) {
                             var zf = flickable.width / contentsSize.width
                             if (zf >= contentsScale)
                                 zf = 2.0*contentsScale // zoom in (else zooming out)
                             doZoom(zf,clickX*zf,clickY*zf)
                          }
                        }

         SequentialAnimation {
             id: quickZoom

             PropertyAction {
                 target: webView
                 property: "renderingEnabled"
                 value: false
             }
             ParallelAnimation {
                 NumberAnimation {
                     id: scaleAnim
                     target: webView
                     property: "contentsScale"
                     // the to property is set before calling
                     easing.type: Easing.Linear
                     duration: 200
                 }
                 NumberAnimation {
                     id: flickVX
                     target: flickable
                     property: "contentX"
                     easing.type: Easing.Linear
                     duration: 200
                     from: 0 // set before calling
                     to: 0 // set before calling
                 }
                 NumberAnimation {
                     id: flickVY
                     target: flickable
                     property: "contentY"
                     easing.type: Easing.Linear
                     duration: 200
                     from: 0 // set before calling
                     to: 0 // set before calling
                 }
             }
             // Have to set the contentXY, since the above 2
             // size changes may have started a correction if
             // contentsScale < 1.0.
             PropertyAction {
                 id: finalX
                 target: flickable
                 property: "contentX"
                 value: 0 // set before calling
             }
             PropertyAction {
                 id: finalY
                 target: flickable
                 property: "contentY"
                 value: 0 // set before calling
             }
             PropertyAction {
                 target: webView
                 property: "renderingEnabled"
                 value: true
             }
         }
         onZoomTo: doZoom(zoom,centerX,centerY)
     }
 }
