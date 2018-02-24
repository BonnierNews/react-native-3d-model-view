/**
 * Created by johankasperi 2018-02-05.
 */

package se.bonniernews.rn3d;

import android.content.Context;
import android.support.annotation.Nullable;
import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.facebook.infer.annotation.Assertions;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.Map;

@ReactModule(name = RN3DViewManager.REACT_CLASS)
class RN3DViewManager extends ViewGroupManager<RN3DView> {
  public static final String REACT_CLASS = "RCT3DScnModelView";
  private RN3DView view;

  public static final int COMMAND_START_ANIMATION = 1;
  public static final int COMMAND_STOP_ANIMATION = 2;
  public static final int COMMAND_SET_PROGRESS = 3;

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  protected RN3DView createViewInstance(ThemedReactContext themedReactContext) {
    this.view = new RN3DView(themedReactContext);
    return this.view;
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

  @ReactProp(name = "scale")
  public void setScale(final RN3DView view, final float scale) {
    view.setScale(scale);
  }

  @ReactProp(name = "autoPlayAnimations")
  public void setAutoPlayAnimations(final RN3DView view, final boolean autoPlay) {
    view.setPlay(autoPlay);
  }

  @Override
  public Map<String,Integer> getCommandsMap() {
    return MapBuilder.of(
            "startAnimation",
            COMMAND_START_ANIMATION,
            "stopAnimation",
            COMMAND_STOP_ANIMATION,
            "setProgress",
            COMMAND_SET_PROGRESS);
  }

  @Override
  public void receiveCommand(RN3DView view, int commandType, @Nullable ReadableArray args) {
    Assertions.assertNotNull(view);
    Assertions.assertNotNull(args);
    switch (commandType) {
      case COMMAND_START_ANIMATION: {
        view.setPlay(true);
        return;
      }
      case COMMAND_STOP_ANIMATION: {
        view.setPlay(false);
        return;
      }
      case COMMAND_SET_PROGRESS: {
        view.setProgress((float)args.getDouble(0));
        return;
      }
      default:
        throw new IllegalArgumentException(String.format(
                "Unsupported command %d received by %s.",
                commandType,
                getClass().getSimpleName()));
    }
  }

  @Override
  @Nullable
  public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
    MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
    return builder
            .put("onLoadModelSuccess", MapBuilder.of("registrationName", "onLoadModelSuccess"))
            .put("onLoadModelError", MapBuilder.of("registrationName", "onLoadModelError"))
            .put("onAnimationStart", MapBuilder.of("registrationName", "onAnimationStart"))
            .put("onAnimationStop", MapBuilder.of("registrationName", "onAnimationStop"))
            .put("onAnimationUpdate", MapBuilder.of("registrationName", "onAnimationUpdate"))
            .build();
  }
}
