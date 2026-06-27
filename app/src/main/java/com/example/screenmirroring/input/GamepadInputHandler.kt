package com.example.screenmirroring.input

import android.view.MotionEvent
import android.view.InputDevice
import com.example.screenmirroring.streaming.StreamClient

class GamepadInputHandler {

    fun handleMotionEvent(event: MotionEvent, streamClient: StreamClient?) {
        val inputDevice = InputDevice.getDevice(event.deviceId)
        if (inputDevice?.sources?.and(InputDevice.TOOL_TYPE_UNKNOWN) == 0) return

        val inputData = ByteArray(16)
        inputData[0] = 0x01 // Input type: gamepad

        // Left stick
        val lx = getCenteredAxis(event, MotionEvent.AXIS_X).toInt()
        val ly = getCenteredAxis(event, MotionEvent.AXIS_Y).toInt()
        inputData[1] = (lx shr 8).toByte()
        inputData[2] = lx.toByte()
        inputData[3] = (ly shr 8).toByte()
        inputData[4] = ly.toByte()

        // Right stick
        val rx = getCenteredAxis(event, MotionEvent.AXIS_Z).toInt()
        val ry = getCenteredAxis(event, MotionEvent.AXIS_RZ).toInt()
        inputData[5] = (rx shr 8).toByte()
        inputData[6] = rx.toByte()
        inputData[7] = (ry shr 8).toByte()
        inputData[8] = ry.toByte()

        // Triggers
        val lt = (getCenteredAxis(event, MotionEvent.AXIS_LTRIGGER) * 255).toInt()
        val rt = (getCenteredAxis(event, MotionEvent.AXIS_RTRIGGER) * 255).toInt()
        inputData[9] = lt.toByte()
        inputData[10] = rt.toByte()

        // D-Pad
        val hatX = event.getAxisValue(MotionEvent.AXIS_HAT_X)
        val hatY = event.getAxisValue(MotionEvent.AXIS_HAT_Y)
        inputData[11] = if (hatX > 0) 1 else if (hatX < 0) 2 else 0
        inputData[12] = if (hatY > 0) 1 else if (hatY < 0) 2 else 0

        streamClient?.sendInput(inputData)
    }

    private fun getCenteredAxis(event: MotionEvent, axis: Int): Float {
        val range = InputDevice.getDevice(event.deviceId)?.getMotionRange(axis, event.source)
        val flat = range?.flat ?: 0.5f
        var value = event.getAxisValue(axis)

        if (Math.abs(value) > flat) {
            return value
        }
        return 0f
    }
}
