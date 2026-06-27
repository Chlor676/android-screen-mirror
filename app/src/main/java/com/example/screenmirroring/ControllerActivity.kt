package com.example.screenmirroring

import android.content.Context
import android.os.Bundle
import android.view.MotionEvent
import android.view.InputDevice
import androidx.appcompat.app.AppCompatActivity
import com.example.screenmirroring.databinding.ActivityControllerBinding
import com.example.screenmirroring.input.GamepadInputHandler
import com.example.screenmirroring.input.TouchInputHandler
import com.example.screenmirroring.streaming.StreamClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ControllerActivity : AppCompatActivity() {
    private lateinit var binding: ActivityControllerBinding
    private var streamClient: StreamClient? = null
    private var gamepadHandler: GamepadInputHandler? = null
    private var touchHandler: TouchInputHandler? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityControllerBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.connectButton.setOnClickListener {
            connectToHost()
        }

        binding.disconnectButton.setOnClickListener {
            disconnectFromHost()
        }

        // Setup input handlers
        gamepadHandler = GamepadInputHandler()
        touchHandler = TouchInputHandler()
    }

    private fun connectToHost() {
        val ipAddress = binding.ipInput.text.toString()
        if (ipAddress.isNotEmpty()) {
            CoroutineScope(Dispatchers.Default).launch {
                streamClient = StreamClient(ipAddress, 5000, binding.frameView)
                streamClient?.connect()
                runOnUiThread {
                    binding.statusText.text = "Connected to $ipAddress"
                }
            }
        }
    }

    private fun disconnectFromHost() {
        streamClient?.disconnect()
        runOnUiThread {
            binding.statusText.text = "Disconnected"
        }
    }

    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        if (event != null && (event.source and InputDevice.TOOL_TYPE_UNKNOWN) != 0) {
            gamepadHandler?.handleMotionEvent(event, streamClient)
            return true
        }
        return super.onGenericMotionEvent(event)
    }

    override fun onTouchEvent(event: MotionEvent?): Boolean {
        if (event != null) {
            touchHandler?.handleTouchEvent(event, streamClient)
            return true
        }
        return super.onTouchEvent(event)
    }

    override fun onDestroy() {
        super.onDestroy()
        streamClient?.disconnect()
    }
}
