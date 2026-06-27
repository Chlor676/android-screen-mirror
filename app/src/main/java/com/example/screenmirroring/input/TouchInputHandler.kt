package com.example.screenmirroring.input

import android.view.MotionEvent
import com.example.screenmirroring.streaming.StreamClient

class TouchInputHandler {

    fun handleTouchEvent(event: MotionEvent, streamClient: StreamClient?) {
        val inputData = ByteArray(12)
        inputData[0] = 0x02 // Input type: touch

        // Action
        inputData[1] = when (event.action and MotionEvent.ACTION_MASK) {
            MotionEvent.ACTION_DOWN -> 0
            MotionEvent.ACTION_MOVE -> 1
            MotionEvent.ACTION_UP -> 2
            else -> 3
        }.toByte()

        // X coordinate
        val x = event.x.toInt()
        inputData[2] = (x shr 8).toByte()
        inputData[3] = x.toByte()

        // Y coordinate
        val y = event.y.toInt()
        inputData[4] = (y shr 8).toByte()
        inputData[5] = y.toByte()

        // Pressure
        val pressure = (event.pressure * 255).toInt()
        inputData[6] = pressure.toByte()

        // Pointer count
        inputData[7] = event.pointerCount.toByte()

        streamClient?.sendInput(inputData)
    }
}
