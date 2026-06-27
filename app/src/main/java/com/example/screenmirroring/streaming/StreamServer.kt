package com.example.screenmirroring.streaming

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.hardware.display.DisplayManager
import android.media.Image
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Handler
import android.os.Looper
import java.io.ByteArrayOutputStream
import java.net.ServerSocket
import java.net.Socket
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class StreamServer(private val activity: Activity, private val data: Intent) {
    private var serverSocket: ServerSocket? = null
    private var mediaProjection: MediaProjection? = null
    private var imageReader: ImageReader? = null
    private val clients = mutableListOf<Socket>()
    private var isRunning = false

    fun start() {
        isRunning = true
        setupMediaProjection()
        startServer()
    }

    private fun setupMediaProjection() {
        val mediaProjectionManager = activity.getSystemService(android.content.Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        mediaProjection = mediaProjectionManager.getMediaProjection(Activity.RESULT_OK, data)

        val displayManager = activity.getSystemService(android.content.Context.DISPLAY_SERVICE) as DisplayManager
        val display = displayManager.getDisplay(0)
        val width = display?.width ?: 1920
        val height = display?.height ?: 1080

        imageReader = ImageReader.newInstance(width, height, android.graphics.PixelFormat.RGBA_8888, 2)
        imageReader?.setOnImageAvailableListener({ reader ->
            val image = reader.acquireLatestImage()
            if (image != null) {
                val bitmap = imageToBitmap(image)
                image.close()
                broadcastFrame(bitmap)
            }
        }, Handler(Looper.getMainLooper()))

        mediaProjection?.createVirtualDisplay(
            "ScreenMirror",
            width,
            height,
            activity.resources.displayMetrics.densityDpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_PUBLIC,
            imageReader?.surface,
            null,
            null
        )
    }

    private fun imageToBitmap(image: Image): Bitmap {
        val planes = image.planes
        val buffer = planes[0].buffer
        buffer.rewind()
        val pixelStride = planes[0].pixelStride
        val padding = planes[0].rowPadding
        val bitmap = Bitmap.createBitmap(
            image.width + padding / pixelStride,
            image.height,
            Bitmap.Config.ARGB_8888
        )
        bitmap.copyPixelsFromBuffer(buffer)
        return Bitmap.createBitmap(bitmap, 0, 0, image.width, image.height)
    }

    private fun startServer() {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                serverSocket = ServerSocket(5000)
                while (isRunning) {
                    val client = serverSocket?.accept()
                    if (client != null) {
                        clients.add(client)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun broadcastFrame(bitmap: Bitmap) {
        val jpegData = bitmapToJpeg(bitmap)
        val clientIterator = clients.iterator()
        while (clientIterator.hasNext()) {
            val client = clientIterator.next()
            try {
                val outputStream = client.getOutputStream()
                outputStream.write(jpegData.size shr 24 and 0xFF)
                outputStream.write(jpegData.size shr 16 and 0xFF)
                outputStream.write(jpegData.size shr 8 and 0xFF)
                outputStream.write(jpegData.size and 0xFF)
                outputStream.write(jpegData)
                outputStream.flush()
            } catch (e: Exception) {
                clientIterator.remove()
                try {
                    client.close()
                } catch (ex: Exception) { }
            }
        }
    }

    private fun bitmapToJpeg(bitmap: Bitmap): ByteArray {
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)
        return outputStream.toByteArray()
    }

    fun stop() {
        isRunning = false
        clients.forEach { try { it.close() } catch (e: Exception) { } }
        clients.clear()
        serverSocket?.close()
        mediaProjection?.stop()
        imageReader?.close()
    }
}
