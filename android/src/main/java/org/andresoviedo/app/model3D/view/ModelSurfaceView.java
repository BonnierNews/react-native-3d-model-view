package org.andresoviedo.app.model3D.view;

import java.io.File;

import org.andresoviedo.app.model3D.controller.TouchController;

import org.andresoviedo.app.model3D.services.SceneLoader;
import org.andresoviedo.app.util.Utils;
import org.andresoviedo.app.util.content.ContentUtils;
import android.os.Handler;

import android.opengl.GLSurfaceView;
import android.view.MotionEvent;
import android.content.Context;
import android.util.Log;

/**
 * This is the actual opengl view. From here we can detect touch gestures for example
 * 
 * @author andresoviedo
 *
 */
public class ModelSurfaceView extends GLSurfaceView {

	private ModelRenderer mRenderer;
	private TouchController touchHandler;
	private SceneLoader scene;
	private Handler handler;

	private String modelSrc;
	private String textureSrc;
	private float[] backgroundColor;

	public ModelSurfaceView(Context context, String modelSrc, String textureSrc, float[] backgroundColor) {
		super(context);
		this.modelSrc = modelSrc;
		this.textureSrc = textureSrc;
		this.backgroundColor = backgroundColor;

		// Create an OpenGL ES 2.0 context.
		setEGLContextClientVersion(2);

		// This is the actual renderer of the 3D space
		mRenderer = new ModelRenderer(this);
		setRenderer(mRenderer);

		// Render the view only when there is a change in the drawing data
		// TODO: enable this again
		// setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);

		touchHandler = new TouchController(this, mRenderer);

		handler = new Handler(context.getMainLooper());

		scene = new SceneLoader(this, context);
		scene.init(modelSrc, textureSrc);
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		return touchHandler.onTouchEvent(event);
	}

	public ModelSurfaceView getModelActivity() {
		return this;
	}

	public ModelRenderer getModelRenderer(){
		return mRenderer;
	}

	public SceneLoader getScene() { return scene; }

	public ModelSurfaceView getgLView() {
		return this;
	}

	public float[] getBackgroundColor(){
		return backgroundColor;
	}

	private void tryInitScene() {
		if (modelSrc != null && textureSrc != null && backgroundColor != null) {
			scene.init(modelSrc, textureSrc);
		}
	}
}