/**
 * Created by johankasperi 2018-02-05.
 */

package se.bonniernews.rn3d;

import android.content.Context;
import android.location.Location;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.graphics.Paint;
import android.graphics.Canvas;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableNativeArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.util.DisplayMetrics;

import org.andresoviedo.app.model3D.view.ModelSurfaceView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

class RN3DViewManager extends SimpleViewManager<ModelSurfaceView> {
  public static final String REACT_CLASS = "RCT3DScnModelView";

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  protected ModelSurfaceView createViewInstance(ThemedReactContext themedReactContext) {
    ModelSurfaceView view = create3DView(themedReactContext);
    return view;
  }

  @ReactProp(name = "modelSrc")
  public void setModelSrc(final ModelSurfaceView view, final String modelSrc) {
    view.setModelSrc(modelSrc);
  }

  @ReactProp(name = "textureSrc")
  public void setTextureSrc(final ModelSurfaceView view, final String textureSrc) {
    view.setTextureSrc(textureSrc);
  }

  @NonNull
  public static ModelSurfaceView create3DView(ThemedReactContext context) {
    return new ModelSurfaceView(context);
  }
}