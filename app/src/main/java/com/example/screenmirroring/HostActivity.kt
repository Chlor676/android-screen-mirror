package com.example.screenmirroring

import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Bundle
import android.view.SurfaceView
import androidx.appcompat.app.AppCompatActivity
import com.example.screenmirroring.databinding.ActivityHostBinding
import com.example.screenmirroring.streaming.StreamServer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class HostActivity : AppCompatActivity() {
    private lateinit var binding: ActivityHostBinding
    private var streamServer: StreamServer? = null
    private val REQUEST_CODE_SCREEN_CAPTURE = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHostBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.startButton.setOnClickListener {
            startScreenCapture()
        }

        binding.stopButton.setOnClickListener {
            stopScreenCapture()
        }
    }

    private fun startScreenCapture() {
        val mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(mediaProjectionManager.createScreenCaptureIntent(), REQUEST_CODE_SCREEN_CAPTURE)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_SCREEN_CAPTURE && resultCode == RESULT_OK && data != null) {
            CoroutineScope(Dispatchers.Default).launch {
                streamServer = StreamServer(this@HostActivity, data)
                streamServer?.start()
                runOnUiThread {
                    binding.statusText.text = "Streaming on port 5000"
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        streamServer?.stop()
    }
}
