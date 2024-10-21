local camera: Camera

function setupCamera(cameraSubject: Humanoid)
	camera.CameraSubject = cameraSubject
end

function setup() end

function init(camera_: Camera)
	camera = camera_

	setup()
end

return {
	init = init,
	setupCamera = setupCamera,
}
