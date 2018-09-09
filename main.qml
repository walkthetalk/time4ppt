import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3

ApplicationWindow {
	id: mainWindow
	visible: true
	width: mainlayout.implicitWidth
	height: mainlayout.implicitHeight
	flags:Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
	color: Qt.rgba(0,0,0,0)

	font.family: "黑体"
	font.bold: true

	ColumnLayout {
		id: mainlayout
		spacing: vspace1
		ColumnLayout {
			spacing: vspace2
			Label {
				id: lbl1
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[0]
				font: fontArray[0]
				text: textArray[0]
			}
			Label {
				id: lbl2
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[1]
				font: fontArray[1]
				text: textArray[1]
			}
			Label {
				id: lbl3
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[2]
				font: fontArray[2]
				text: textArray[2]
			}
		}

		ColumnLayout {
			spacing: vspace2
			Label {
				id: lbl4
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[3]
				font: fontArray[3]
				text: textArray[3]
			}
			Label {
				id: lbl5
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[4]
				font: fontArray[4]
				text: textArray[4]
			}
			Label {
				id: lbl6
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				color: colorArray[5]
				font: fontArray[5]
				text: textArray[5]
			}
		}
	}

	property date beginDate
	property date endDate

	property bool offDirForward
	property int offYear
	property int offMonth
	property int offDay
	property int offHour
	property int offMinute
	property int offSecond
	property int cfsIdx
	property int vspace1: 8
	property int vspace2: 2
	property var colorArray: [
		Qt.rgba(0,255,0),
		Qt.rgba(0,0,0),
		Qt.rgba(0,0,0),
		Qt.rgba(0,255,0),
		Qt.rgba(0,0,0),
		Qt.rgba(0,0,0)
	]
	property var fontArray: [
		Qt.font(mainWindow.font),
		Qt.font(mainWindow.font),
		Qt.font(mainWindow.font),
		Qt.font(mainWindow.font),
		Qt.font(mainWindow.font),
		Qt.font(mainWindow.font)
	]
	property var textArray: [
		"天文时间",
		beginDate.toLocaleString(Qt.locale("zh_CN"), "yyyy/MM/dd dddd"),
		beginDate.toLocaleString(Qt.locale("zh_CN"), "hh:mm:ss"),
		"作战时间",
		endDate.toLocaleString(Qt.locale("zh_CN"), "yyyy/MM/dd dddd"),
		endDate.toLocaleString(Qt.locale("zh_CN"), "hh:mm:ss")
	]
	Timer {
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			var other
			if (offDirForward > 0) {
				beginDate = new Date()
				other = beginDate
				other.setFullYear(other.getFullYear() + offYear)
				other.setMonth(other.getMonth() + offMonth)
				other.setDate(other.getDate() + offDay)
				other.setHours(other.getHours() + offHour)
				other.setMinutes(other.getMinutes() + offMinute)
				other.setSeconds(other.getSeconds() + offSecond)
				endDate = other
			}
			else {
				endDate = new Date()
				other = endDate
				other.setFullYear(other.getFullYear() - offYear)
				other.setMonth(other.getMonth() - offMonth)
				other.setDate(other.getDate() - offDay)
				other.setHours(other.getHours() - offHour)
				other.setMinutes(other.getMinutes() - offMinute)
				other.setSeconds(other.getSeconds() - offSecond)
				beginDate = other
			}
		}
	}

	MouseArea {
		id: dragArea
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton

		property var clickPos
		onPressed: {
			clickPos = Qt.point(mouse.x, mouse.y)
		}
		onPositionChanged: {
			var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
			mainWindow.x += delta.x
			mainWindow.y += delta.y
		}

		onClicked: {
			if (mouse.button === Qt.MidButton)
				Qt.quit()
			if (mouse.button === Qt.RightButton) {
				if (mouse.buttons & Qt.LeftButton)
					fontDialog.visible = true
				else
					settings.visible = true
			}
		}

		onWheel: {
			var sizeOff = 0
			if (wheel.angleDelta.y > 0)
				sizeOff += 1
			else
				sizeOff -= 1
			if (wheel.buttons & Qt.LeftButton) {
				vspace1 += sizeOff
				vspace2 += sizeOff
			}
			else {
				var tmp = fontArray
				for (var i = 0; i < tmp.length; i++)
					tmp[i].pointSize += sizeOff;
				fontArray = tmp
			}
		}
	}


	ApplicationWindow {
		id: settings
		visible: false
		width: settingsContent.implicitWidth + 16
		height: settingsContent.implicitHeight + 16

		ColumnLayout {
			id: settingsContent
			x: 8
			y: 8

			RowLayout {
				Label {
					text: "时间差："
				}

				Button {
					text: (dirForward.checked ? "+" : "-")
						+ offYear + "年"
						+ offMonth + "月"
						+ offDay + "日"
						+ offHour + "时"
						+ offMinute + "分"
						+ offSecond + "秒"
					onClicked: {
						setTimeOffset.visible = true
					}
				}
			}

			RowLayout {
				Label { text: "段间距" }
				TextFieldAdv {
					text: vspace1
					onTextChanged: {
						vspace1 = parseInt(text)
					}
				}
			}

			RowLayout {
				Label { text: "行间距" }
				TextFieldAdv {
					text: vspace2
					onTextChanged: {
						vspace2 = parseInt(text)
					}
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 0
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 1
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 2
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 3
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 4
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Layout.fillWidth: true
				property int idx: 5
				Button {
					text: "颜色"
					onClicked: {
						cfsIdx = parent.idx
						colorDialog.open()
					}
				}
				Button {
					text: "字体 " + fontArray[parent.idx].pointSize
					onClicked: {
						cfsIdx = parent.idx
						fontDialog.open()
					}
				}
				Label {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					color: colorArray[parent.idx]
					font: fontArray[parent.idx]
					text: textArray[parent.idx]
				}
			}

			RowLayout {
				Button {
					text: "退出程序"
					onClicked: {
						Qt.quit()
					}
				}
			}
		}
	}

	ApplicationWindow {
		id: setTimeOffset
		visible: false
		width: grid.implicitWidth + 16
		height: grid.implicitHeight + 16

		ColumnLayout {
			id: grid
			x: 8
			y: 8
			ButtonGroup {
				buttons: dirCol.children
			}

			RowLayout {
				id: dirCol
				spacing: 16

				RadioButton {
					id: dirBackward
					text: "向前"
				}

				RadioButton {
					id: dirForward
					checked: true
					text: "向后"
				}
			}

			RowLayout {
				Label { text: "年" }
				TextFieldAdv {
					id: offsetYear
				}
			}

			RowLayout {
				Label { text: "月" }
				TextFieldAdv {
					id: offsetMonth
				}
			}

			RowLayout {
				Label { text: "日" }
				TextFieldAdv {
					id: offsetDay
				}
			}

			RowLayout {
				Label { text: "时" }
				TextFieldAdv {
					id: offsetHour
				}
			}

			RowLayout {
				Label { text: "分" }
				TextFieldAdv {
					id: offsetMinute
				}
			}

			RowLayout {
				Label { text: "秒" }
				TextFieldAdv {
					id: offsetSecond
				}
			}

			RowLayout {
				Button {
					text: "取消"
					onClicked: { setTimeOffset.visible = false }
				}
				Button {
					text: "确定"
					onClicked: {
						setTimeOffset.visible = false
						if (dirForward.checked)
							offDirForward = true
						else
							offDirForward = false
						offYear = parseInt(offsetYear.text)
						offMonth = parseInt(offsetMonth.text)
						offDay = parseInt(offsetDay.text)
						offHour = parseInt(offsetHour.text)
						offMinute = parseInt(offsetMinute.text)
						offSecond = parseInt(offsetSecond.text)
					}
				}
			}
		}
	}

	ColorDialog {
		id: colorDialog
		visible: false
		title: "选择颜色"
		onAccepted: {
			// workaround for array emit change
			var tmp = colorArray
			tmp[cfsIdx].r = colorDialog.color.r
			tmp[cfsIdx].g = colorDialog.color.g
			tmp[cfsIdx].b = colorDialog.color.b
			tmp[cfsIdx].a = colorDialog.color.a
			colorArray = tmp
		}
	}

	FontDialog {
		id: fontDialog
		visible: false
		title: "选择字体"
		onAccepted: {
			// workaround for array emit change
			var tmp = fontArray
			copyFont(tmp[cfsIdx], fontDialog.font)
			fontArray = tmp
		}
	}

	function copyFont(dst, src) {
		dst.bold = src.bold
		dst.family = src.family
		dst.italic = src.italic
		dst.pointSize = src.pointSize
		dst.weight = src.weight
		dst.underline = src.underline
		dst.strikeout = src.strikeout
		dst.overline = src.overline
		dst.styleName = src.styleName
	}

	Component.onCompleted: {
		var tmp = fontArray
		var bigSize = tmp[0].pointSize + 4
		tmp[0].pointSize = bigSize
		tmp[2].pointSize = bigSize
		tmp[3].pointSize = bigSize
		tmp[5].pointSize = bigSize
		fontArray = tmp
	}
}
