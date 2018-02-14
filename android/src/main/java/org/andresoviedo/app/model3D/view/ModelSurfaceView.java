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

import se.bonniernews.rn3d.RN3DView;
/**
 * This is the actual opengl view. From here we can detect touch gestures for example
 * 
 * @author andresoviedo
 *
 */
public class ModelSurfaceView extends GLSurfaceView {

	private RN3DView parent;

	private ModelRenderer mRenderer;
	private TouchController touchHandler;
	private SceneLoader scene;
	private Handler handler;

	private String modelSrc;
	private String textureSrc;
	private float[] backgroundColor;
	private float scale;

	public ModelSurfaceView(Context context, RN3DView parent, String modelSrc, String textureSrc, float[] backgroundColor) {
		super(context);
		this.parent = parent;

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

	public void setScale(float scale) {
		this.scale = scale;
		this.scene.setScale(scale);
	}

	public void setPlay(boolean play) {
		if (this.scene.getAnimator() != null) {
			this.scene.getAnimator().setPlay(play);
			if (play) {
				this.parent.onAnimationStart();
			} else {
				this.parent.onAnimationStop();
			}
		}
	}

	public void setProgress(float progress) {
		if (this.scene.getAnimator() != null && this.scene.getSelectedObject() != null) {
			this.scene.getAnimator().setProgress(progress, this.scene.getSelectedObject());
		}
	}

	public float getScale() {
		return this.scale;
	}

	public void onLoadModelSuccess() {
		parent.onLoadModelSuccess();
	}

	public void onLoadModelError() {
		parent.onLoadModelError();
	}

	public void onAnimationStart() { parent.onAnimationStart(); }

	public void onAnimationStop() { parent.onAnimationStop(); }

	public void onAnimationUpdate(double progress) { parent.onAnimationUpdate(progress); }


}