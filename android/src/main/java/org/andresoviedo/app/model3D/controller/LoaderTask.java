package org.andresoviedo.app.model3D.controller;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.util.Log;
import android.content.Context;

import org.andresoviedo.app.model3D.model.Object3DBuilder;
import org.andresoviedo.app.model3D.model.Object3DData;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.List;

/**
 * This component allows loading the model without blocking the UI.
 *
 * @author andresoviedo
 */
public abstract class LoaderTask extends AsyncTask<Void, Integer, List<Object3DData>> {

	/**
	 * Appplication context
	 */
	protected final Context context;
	/**
	 * URL to the 3D model
	 */
	protected final URL url;
	/**
	 * Callback to notify of events
	 */
	protected final Object3DBuilder.Callback callback;
	/**
	 * Exception when loading data (if any)
	 */
	protected Exception error;

	public LoaderTask(Context context, URL url, Object3DBuilder.Callback callback) {
		this.context = context;
		this.url = url;
		this.callback = callback;
	}


	@Override
	protected void onPreExecute() {
		super.onPreExecute();
	}

	@Override
	protected List<Object3DData> doInBackground(Void... params) {
		try {
			List<Object3DData> data = build();
			callback.onLoadComplete(data);
			build(data);
			return  data;
		} catch (Exception ex) {
			error = ex;
			return null;
		}
	}

	protected abstract List<Object3DData> build() throws Exception;

	protected abstract void build(List<Object3DData> data) throws Exception;

	@Override
	protected void onProgressUpdate(Integer... values) {
		super.onProgressUpdate(values);
	}

	@Override
	protected void onPostExecute(List<Object3DData> data) {
		super.onPostExecute(data);
		if (error != null) {
			callback.onLoadError(error);
		} else {
			callback.onBuildComplete(data);
		}
	}


}