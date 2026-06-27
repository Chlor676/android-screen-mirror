package com.example.screenmirroring.streaming

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.ImageView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.BufferedInputStream
import java.net.Socket

class StreamClient(private val host: String, private val port: Int, private val displayView: ImageView) {
    private var socket: Socket? = null
    private var isConnected = false

    fun connect() {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                socket = Socket(host, port)
                isConnected = true
                receiveFrames()
            } catch (e: Exception) {
                e.printStackTrace()
                isConnected = false
            }
        }
    }

    private fun receiveFrames() {
        try {
            val inputStream = BufferedInputStream(socket?.getInputStream())
            val buffer = ByteArray(4)
            val imageBuffer = ByteArray(1024 * 1024) // 1MB buffer

            while (isConnected) {
                // Read frame size (4 bytes)
                val bytesRead = inputStream.read(buffer, 0, 4)
                if (bytesRead != 4) break

                val frameSize = ((buffer[0].toInt() and 0xFF) shl 24) or
                        ((buffer[1].toInt() and 0xFF) shl 16) or
                        ((buffer[2].toInt() and 0xFF) shl 8) or
                        (buffer[3].toInt() and 0xFF)

                // Read frame data
                var totalRead = 0
                while (totalRead < frameSize && isConnected) {
                    val read = inputStream.read(imageBuffer, totalRead, frameSize - totalRead)
                    if (read < 0) break
                    totalRead += read
                }

                if (totalRead == frameSize) {
                    val bitmap = BitmapFactory.decodeByteArray(imageBuffer, 0, frameSize)
                    if (bitmap != null) {
                        CoroutineScope(Dispatchers.Main).launch {
                            displayView.setImageBitmap(bitmap)
                        }
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            isConnected = false
        }
    }

    fun sendInput(inputData: ByteArray) {
        if (isConnected) {
            try {
                socket?.getOutputStream()?.write(inputData)
                socket?.getOutputStream()?.flush()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun disconnect() {
        isConnected = false
        try {
            socket?.close()
        } catch (e: Exception) { }
    }
}
