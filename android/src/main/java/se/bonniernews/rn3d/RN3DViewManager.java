/**
 * Created by johankasperi 2018-02-05.
 */

package se.bonniernews.rn3d;

import android.content.Context;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.graphics.Paint;
import android.graphics.Canvas;
import android.widget.RelativeLayout;
import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.util.DisplayMetrics;
import android.graphics.Color;

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

import org.andresoviedo.app.model3D.view.ModelSurfaceView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

class RN3DView extends RelativeLayout {
  public ModelSurfaceView modelView;

  private Context context;
  private String modelSrc;
  private String textureSrc;
  private float[] backgroundColor;

  public RN3DView(Context context) {
    super(context);
    this.context = context;
  }

  private void tryInitScene() {
    if (context != null && modelSrc != null && textureSrc != null && backgroundColor != null) {
      this.modelView = new ModelSurfaceView(context, modelSrc, textureSrc, backgroundColor);
      RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
      layoutParams.addRule(CENTER_IN_PARENT);
      this.modelView.setLayoutParams(layoutParams);
      addView(this.modelView);
    }
  }

  /**
   * React props
   */
  public void setModelSrc(final String modelSrc) {
    this.modelSrc = modelSrc;
    this.tryInitScene();
  }

  public void setTextureSrc(final String textureSrc) {
    this.textureSrc = textureSrc;
    this.tryInitScene();
  }

  public void setBackgroundColor(final Integer color) {
    if (color == null) {
      return;
    }
    float red = (float) Color.red(color) / 255f;
    float green = (float) Color.green(color) / 255f;
    float blue = (float) Color.blue(color) / 255f;
    float alpha = (float) Color.alpha(color) / 255f;

    this.backgroundColor = new float[] {red, green, blue, alpha};
    this.tryInitScene();
  }
}

class RN3DViewManager extends SimpleViewManager<RN3DView> {
  public static final String REACT_CLASS = "RCT3DScnModelView";

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  protected RN3DView createViewInstance(ThemedReactContext themedReactContext) {
    RN3DView view = create3DView(themedReactContext);
    return view;
  }

  @ReactProp(name = "modelSrc")
  public void setModelSrc(final RN3DView view, final String modelSrc) {
    view.setModelSrc(modelSrc);
  }

  @ReactProp(name = "textureSrc")
  public void setTextureSrc(final RN3DView view, final String textureSrc) {
    view.setTextureSrc(textureSrc);
  }

  @ReactProp(name = "backgroundColor", customType = "Color")
  public void setBackgroundColor(final RN3DView view, final Integer color) {
    view.setBackgroundColor(color);
  }


  @NonNull
  public static RN3DView create3DView(ThemedReactContext context) {
    return new RN3DView(context);
  }
}