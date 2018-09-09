import QtQuick 2.11
import QtQuick.Controls 2.4

TextField {
	id: control
	text: "0"
	validator: IntValidator{
		bottom: -1000
		top: 1000
	}
	MouseArea {
		anchors.fill: parent
		onWheel: {
			var sizeOff = 0
			if (wheel.angleDelta.y > 0)
				sizeOff += 1
			else
				sizeOff -= 1
			var oldVal = parseInt(control.text)
			var newVal = oldVal + sizeOff
			control.text = newVal
		}
	}
}
