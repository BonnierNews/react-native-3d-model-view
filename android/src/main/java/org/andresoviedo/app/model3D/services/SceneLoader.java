package org.andresoviedo.app.model3D.services;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.andresoviedo.app.model3D.animation.Animator;
import org.andresoviedo.app.model3D.model.Object3DBuilder;
import org.andresoviedo.app.model3D.model.Object3DBuilder.Callback;
import org.andresoviedo.app.model3D.model.Object3DData;
import org.andresoviedo.app.model3D.view.ModelSurfaceView;
import org.andresoviedo.app.util.url.android.Handler;
import org.apache.commons.io.IOUtils;

import android.os.SystemClock;
import android.util.Log;
import android.content.Context;

/**
 * This class loads a 3D scena as an example of what can be done with the app
 * 
 * @author andresoviedo
 *
 */
public class SceneLoader {

	/**
	 * Default model color: yellow
	 */
	private static float[] DEFAULT_COLOR = {1.0f, 1.0f, 0, 1.0f};
	/**
	 * Parent component
	 */
	protected final ModelSurfaceView parent;
	/**
	 * Parent component
	 */
	protected final Context context;
	/**
	 * List of data objects containing info for building the opengl objects
	 */
	private List<Object3DData> objects = new ArrayList<Object3DData>();
	/**
	 * Whether to draw objects as wireframes
	 */
	private boolean drawWireframe = false;
	/**
	 * Whether to draw using points
	 */
	private boolean drawingPoints = false;
	/**
	 * Whether to draw bounding boxes around objects
	 */
	private boolean drawBoundingBox = false;
	/**
	 * Whether to draw face normals. Normally used to debug models
	 */
	private boolean drawNormals = false;
	/**
	 * Whether to draw using textures
	 */
	private boolean drawTextures = true;
	/**
	 * Light toggle feature: we have 3 states: no light, light, light + rotation
	 */
	private boolean rotatingLight = false;
	/**
	 * Light toggle feature: whether to draw using lights
	 */
	private boolean drawLighting = false;
	/**
	 * Object selected by the user
	 */
	private Object3DData selectedObject = null;
	/**
	 * Initial light position
	 */
	private final float[] lightPosition = new float[]{0, 0, 6, 1};
	/**
	 * Light bulb 3d data
	 */
	private final Object3DData lightPoint = Object3DBuilder.buildPoint(lightPosition).setId("light");
	/**
	 * Animator
	 */
	private Animator animator = new Animator();

	public SceneLoader(ModelSurfaceView main, Context context) {
		this.parent = main;
		this.context = context;
	}

	public void init(final String modelPath, final String texturePath) {
		final URL modelUrl;
		final URL textureUrl;
		try {
			if (modelPath.startsWith("http")) {
				modelUrl = new URL(modelPath);
			} else {
				modelUrl = new File(modelPath).toURI().toURL();
			}
			if (texturePath.startsWith("http")) {
				textureUrl = new URL(texturePath);
			} else {
				textureUrl = new File(texturePath).toURI().toURL();
			}
		} catch (MalformedURLException e) {
			Log.e("SceneLoader", e.getMessage(), e);
			throw new RuntimeException(e);
		}
		Object3DBuilder.loadV6AsyncParallel(context, modelUrl, new Callback() {
			long startTime = SystemClock.uptimeMillis();

			@Override
			public void onBuildComplete(List<Object3DData> datas) {
				for (Object3DData data : datas) {
					loadTexture(data, textureUrl);
				}
				final String elapsed = (SystemClock.uptimeMillis() - startTime)/1000+" secs";
			}

			@Override
			public void onLoadComplete(List<Object3DData> datas) {
				for (Object3DData data : datas) {
					addObject(data);
				}
			}

			@Override
			public void onLoadError(Exception ex) {
				Log.e("SceneLoader",ex.getMessage(),ex);
			}
		});
	}

	public Object3DData getLightBulb() {
		return lightPoint;
	}

	public float[] getLightPosition(){
		return lightPosition;
	}

	/**
	 * Hook for animating the objects before the rendering
	 */
	public void onDrawFrame(){

		animateLight();

		if (objects.isEmpty()) return;

		for (Object3DData obj : objects) {
			animator.update(obj);
		}
	}

	private void animateLight() {
		if (!rotatingLight) return;

		// animate light - Do a complete rotation every 5 seconds.
		long time = SystemClock.uptimeMillis() % 5000L;
		float angleInDegrees = (360.0f / 5000.0f) * ((int) time);
		lightPoint.setRotationY(angleInDegrees);
	}

	protected synchronized void addObject(Object3DData obj) {
		List<Object3DData> newList = new ArrayList<Object3DData>(objects);
		newList.add(obj);
		this.objects = newList;
		requestRender();
	}

	private void requestRender() {
		parent.getgLView().requestRender();
	}

	public synchronized List<Object3DData> getObjects() {
		return objects;
	}

	public void toggleWireframe() {
		if (this.drawWireframe && !this.drawingPoints) {
			this.drawWireframe = false;
			this.drawingPoints = true;
		}
		else if (this.drawingPoints){
			this.drawingPoints = false;
		}
		else {
			this.drawWireframe = true;
		}
		requestRender();
	}

	public boolean isDrawWireframe() {
		return this.drawWireframe;
	}

	public boolean isDrawPoints() {
		return this.drawingPoints;
	}

	public void toggleBoundingBox() {
		this.drawBoundingBox = !drawBoundingBox;
		requestRender();
	}

	public boolean isDrawBoundingBox() {
		return drawBoundingBox;
	}

	public boolean isDrawNormals() {
		return drawNormals;
	}

	public void toggleTextures() {
		this.drawTextures = !drawTextures;
	}

	public void toggleLighting() {
		if (this.drawLighting && this.rotatingLight){
			this.rotatingLight = false;
		}
		else if (this.drawLighting && !this.rotatingLight){
			this.drawLighting = false;
		}
		else {
			this.drawLighting = true;
			this.rotatingLight = true;
		}
		requestRender();
	}

	public boolean isDrawTextures() {
		return drawTextures;
	}

	public boolean isDrawLighting() {
		return drawLighting;
	}

	public Object3DData getSelectedObject() {
		return selectedObject;
	}

	public void setSelectedObject(Object3DData selectedObject) {
		this.selectedObject = selectedObject;
	}

	public void loadTexture(final Object3DData data, final URL url){
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					InputStream stream = url.openStream();
					ByteArrayOutputStream bos = new ByteArrayOutputStream();
					IOUtils.copy(stream,bos);
					stream.close();

					data.setTextureData(bos.toByteArray());
				} catch (IOException ex) {
				}
			}
		}).start();
	}
}
