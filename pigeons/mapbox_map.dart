import 'package:pigeon/pigeon.dart';

/// The distance on each side between rectangles, when one is contained into other.
///
/// All fields' values are in `platform pixel` units.
class MbxEdgeInsets {
  /// Padding from the top.
  double top;

  /// Padding from the left.
  double left;

  /// Padding from the bottom.
  double bottom;

  /// Padding from the right.
  double right;
}

/// Various options for describing the viewpoint of a camera. All fields are
/// optional.
///
/// Anchor and center points are mutually exclusive, with preference for the
/// center point when both are set.
class CameraOptions {
  /// Coordinate at the center of the camera.
  Map<String?, Object?>? center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets? padding;

  /// Point of reference for `zoom` and `angle`, assuming an origin at the
  /// top-left corner of the view.
  ScreenCoordinate? anchor;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double? zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double? bearing;

  /// Pitch toward the horizon measured in degrees.
  double? pitch;
}

/// Describes the viewpoint of a camera.
class CameraState {
  /// Coordinate at the center of the camera.
  Map<String?, Object?> center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets padding;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double bearing;

  /// Pitch toward the horizon measured in degrees.
  double pitch;
}

/// Holds options to be used for setting `camera bounds`.
class CameraBoundsOptions {
  /// The latitude and longitude bounds to which the camera center are constrained.
  CoordinateBounds? bounds;

  /// The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area.
  double? maxZoom;

  /// The minimum zoom level, in Mapbox zoom levels 0-25.5.
  double? minZoom;

  /// The maximum allowed pitch value in degrees.
  double? maxPitch;

  /// The minimum allowed pitch value in degrees.
  double? minPitch;
}

/// Holds information about `camera bounds`.
class CameraBounds {
  /// The latitude and longitude bounds to which the camera center are constrained.
  CoordinateBounds bounds;

  /// The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area.
  double maxZoom;

  /// The minimum zoom level, in Mapbox zoom levels 0-25.5.
  double minZoom;

  /// The maximum allowed pitch value in degrees.
  double maxPitch;

  /// The minimum allowed pitch value in degrees.
  double minPitch;
}

class MapAnimationOptions {
  /// The duration of the animation in milliseconds.
  /// If not set explicitly default duration will be taken 300ms
  int? duration;

  /// The amount of time, in milliseconds, to delay starting the animation after animation start.
  /// If not set explicitly default startDelay will be taken 0ms. This only works for Android.
  int? startDelay;
}

/// Interface for managing animation.
@HostApi()
abstract class _AnimationManager {
  void easeTo(
      CameraOptions cameraOptions, MapAnimationOptions? mapAnimationOptions);

  void flyTo(
      CameraOptions cameraOptions, MapAnimationOptions? mapAnimationOptions);

  void pitchBy(double pitch, MapAnimationOptions? mapAnimationOptions);

  void scaleBy(double amount, ScreenCoordinate? screenCoordinate,
      MapAnimationOptions? mapAnimationOptions);

  void moveBy(ScreenCoordinate screenCoordinate,
      MapAnimationOptions? mapAnimationOptions);

  void rotateBy(ScreenCoordinate first, ScreenCoordinate second,
      MapAnimationOptions? mapAnimationOptions);

  void cancelCameraAnimation();
}

/// Interface for managing camera.
@HostApi()
abstract class _CameraManager {
  /// Convenience method that returns the `camera options` object for given parameters.
  ///
  /// @param bounds The `coordinate bounds` of the camera.
  /// @param padding The `edge insets` of the camera.
  /// @param bearing The bearing of the camera.
  /// @param pitch The pitch of the camera.
  ///
  /// @return The `camera options` object representing the provided parameters.
  CameraOptions cameraForCoordinateBounds(CoordinateBounds bounds,
      MbxEdgeInsets padding, double? bearing, double? pitch);

  /// Convenience method that returns the `camera options` object for given parameters.
  ///
  /// @param coordinates The `coordinates` representing the bounds of the camera.
  /// @param padding The `edge insets` of the camera.
  /// @param bearing The bearing of the camera.
  /// @param pitch The pitch of the camera.
  ///
  /// @return The `camera options` object representing the provided parameters.
  CameraOptions cameraForCoordinates(List<Map<String?, Object?>?> coordinates,
      MbxEdgeInsets padding, double? bearing, double? pitch);

  /// Convenience method that adjusts the provided `camera options` object for given parameters.
  ///
  /// Returns the provided `camera` options with zoom adjusted to fit `coordinates` into the `box`, so that `coordinates` on the left,
  /// top and right of the effective `camera` center at the principal point of the projection (defined by `padding`) fit into the `box`.
  /// Returns the provided `camera` options object unchanged upon an error.
  /// Note that this method may fail if the principal point of the projection is not inside the `box` or
  /// if there is no sufficient screen space, defined by principal point and the `box`, to fit the geometry.
  ///
  /// @param coordinates The `coordinates` representing the bounds of the camera.
  /// @param camera The `camera options` for which zoom should be adjusted. Note that the `camera.center` is required.
  /// @param box The `screen box` into which `coordinates` should fit.
  ///
  /// @return The `camera options` object with the zoom level adjusted to fit `coordinates` into the `box`.
  CameraOptions cameraForCoordinates2(List<Map<String?, Object?>?> coordinates,
      CameraOptions camera, ScreenBox box);

  /// Convenience method that returns the `camera options` object for given parameters.
  ///
  /// @param geometry The `geometry` representing the bounds of the camera.
  /// @param padding The `edge insets` of the camera.
  /// @param bearing The bearing of the camera.
  /// @param pitch The pitch of the camera.
  ///
  /// @return The `camera options` object representing the provided parameters.
  CameraOptions cameraForGeometry(Map<String?, Object?> geometry,
      MbxEdgeInsets padding, double? bearing, double? pitch);

  /// Returns the `coordinate bounds` for a given camera.
  ///
  /// Note that if the given `camera` shows the antimeridian, the returned wrapped `coordinate bounds`
  /// might not represent the minimum bounding box.
  ///
  /// @param camera The `camera options` to use for calculating `coordinate bounds`.
  ///
  /// @return The `coordinate bounds` object representing a given `camera`.
  ///
  CoordinateBounds coordinateBoundsForCamera(CameraOptions camera);

  /// Returns the `coordinate bounds` for a given camera.
  ///
  /// This method is useful if the `camera` shows the antimeridian.
  ///
  /// @param camera The `camera options` to use for calculating `coordinate bounds`.
  ///
  /// @return The `coordinate bounds` object representing a given `camera`.
  ///
  CoordinateBounds coordinateBoundsForCameraUnwrapped(CameraOptions camera);

  /// Returns the `coordinate bounds` and the `zoom` for a given `camera`.
  ///
  /// Note that if the given `camera` shows the antimeridian, the returned wrapped `coordinate bounds`
  /// might not represent the minimum bounding box.
  ///
  /// @param camera The `camera options` to use for calculating `coordinate bounds` and `zoom`.
  ///
  /// @return The object representing `coordinate bounds` and `zoom` for a given `camera`.
  ///
  CoordinateBoundsZoom coordinateBoundsZoomForCamera(CameraOptions camera);

  /// Returns the unwrapped `coordinate bounds` and `zoom` for a given `camera`.
  ///
  /// This method is useful if the `camera` shows the antimeridian.
  ///
  /// @param camera The `camera options` to use for calculating `coordinate bounds` and `zoom`.
  ///
  /// @return The object representing `coordinate bounds` and `zoom` for a given `camera`.
  ///
  CoordinateBoundsZoom coordinateBoundsZoomForCameraUnwrapped(
      CameraOptions camera);

  /// Calculates a `screen coordinate` that corresponds to a geographical coordinate
  /// (i.e., longitude-latitude pair).
  ///
  /// The `screen coordinate` is in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  ///
  /// @param coordinate A geographical `coordinate` on the map to convert to a `screen coordinate`.
  ///
  /// @return A `screen coordinate` on the screen in `platform pixels`.
  ScreenCoordinate pixelForCoordinate(Map<String?, Object?> coordinate);

  /// Calculates a geographical `coordinate` (i.e., longitude-latitude pair) that corresponds
  /// to a `screen coordinate`.
  ///
  /// The screen coordinate is in `platform pixels`relative to the top left corner
  /// of the map (not of the whole screen).
  ///
  /// @param pixel A `screen coordinate` on the screen in `platform pixels`.
  ///
  /// @return A geographical `coordinate` corresponding to a given `screen coordinate`.
  Map<String?, Object?> coordinateForPixel(ScreenCoordinate pixel);

  /// Calculates `screen coordinates` that correspond to geographical `coordinates`
  /// (i.e., longitude-latitude pairs).
  ///
  /// The `screen coordinates` are in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  ///
  /// @param coordinates A geographical `coordinates` on the map to convert to `screen coordinates`.
  ///
  /// @return A `screen coordinates` in `platform pixels` for a given geographical `coordinates`.
  List<ScreenCoordinate?> pixelsForCoordinates(
      List<Map<String?, Object?>?> coordinates);

  /// Calculates geographical `coordinates` (i.e., longitude-latitude pairs) that correspond
  /// to `screen coordinates`.
  ///
  /// The screen coordinates are in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  ///
  /// @param pixels A `screen coordinates` in `platform pixels`.
  ///
  /// @return A `geographical coordinates` that correspond to a given `screen coordinates`.
  List<Map<String?, Object?>?> coordinatesForPixels(
      List<ScreenCoordinate?> pixels);

  /// Changes the map view by any combination of center, zoom, bearing, and pitch, without an animated transition.
  /// The map will retain its current values for any details not passed via the camera options argument.
  /// It is not guaranteed that the provided `camera options` will be set, the map may apply constraints resulting in a
  /// different `camera state`.
  ///
  /// @param cameraOptions The new `camera options` to be set.
  void setCamera(CameraOptions cameraOptions);

  /// Returns the current `camera state`.
  ///
  /// @return The current `camera state`.
  CameraState getCameraState();

/*
    /// Sets the map view with the free camera options.
    ///
    /// The `free camera options` provides more direct access to the underlying camera entity.
    /// For backwards compatibility the state set using this API must be representable with
    /// `camera options` as well. Parameters are clamped to a valid range or discarded as invalid
    /// if the conversion to the pitch and bearing presentation is ambiguous. For example orientation
    /// can be invalid if it leads to the camera being upside down or the quaternion has zero length.
    ///
    /// @param freeCameraOptions The `free camera options` to set.
    void setCamera2(FreeCameraOptions freeCameraOptions);

    /// Gets the map's current free camera options. After mutation, it should be set back to the map.
    ///
    /// @return The current `free camera options`.
    FreeCameraOptions getFreeCameraOptions();
*/

  /// Sets the `camera bounds options` of the map. The map will retain its current values for any
  /// details not passed via the camera bounds options arguments.
  /// When camera bounds options are set, the camera center is constrained by these bounds, as well as the minimum
  /// zoom level of the camera, to prevent out of bounds areas to be visible.
  /// Note that tilting or rotating the map, or setting stricter minimum and maximum zoom within `options` may still cause some out of bounds areas to become visible.
  ///
  /// @param options The `camera bounds options` to set.
  /// @return A string describing an error if the operation was not successful, expected with `void` value otherwise.
  void setBounds(CameraBoundsOptions options);

  /// Returns the `camera bounds` of the map.
  /// @return A `camera bounds` of the map.
  CameraBounds getBounds();

  /// Prepares the drag gesture to use the provided screen coordinate as a pivot `point`. This function should be called each time when user starts a dragging action (e.g. by clicking on the map). The following dragging will be relative to the pivot.
  ///
  /// @param point The pivot `screen coordinate`, measured in `platform pixels` from top to bottom and from left to right.
  void dragStart(ScreenCoordinate point);

  /// Calculates target point where camera should move after drag. The method should be called after `dragStart` and before `dragEnd`.
  ///
  /// @param fromPoint The `screen coordinate` to drag the map from, measured in `platform pixels` from top to bottom and from left to right.
  /// @param toPoint The `screen coordinate` to drag the map to, measured in `platform pixels` from top to bottom and from left to right.
  ///
  /// @return The `camera options` object showing the end point.
  CameraOptions getDragCameraOptions(
      ScreenCoordinate fromPoint, ScreenCoordinate toPoint);

  /// Ends the ongoing drag gesture. This function should be called always after the user has ended a drag gesture initiated by `dragStart`.
  void dragEnd();
}

/// A rectangular area as measured on a two-dimensional map projection.
class CoordinateBounds {
  /// Coordinate at the southwest corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> southwest;

  /// Coordinate at the northeast corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> northeast;

  /// If set to `true`, an infinite (unconstrained) bounds covering the world coordinates would be used.
  /// Coordinates provided in `southwest` and `northeast` fields would be omitted and have no effect.
  bool infiniteBounds;
}

/*
/// Various options for accessing physical properties of the underlying camera entity.
/// A direct access to these properties allows more flexible and precise controlling
/// of the camera while also being fully compatible and interchangeable with CameraOptions.
/// All fields are optional.
@HostApi()
abstract class FreeCameraOptions {
    /// Get the position of the camera in slightly modified web mercator coordinates
    ///   - The size of 1 unit is the width of the projected world instead of the "mercator meter".
    ///     Coordinate [0, 0, 0] is the north-west corner and [1, 1, 0] is the south-east corner.
    ///   - Z coordinate is conformal and must respect minimum and maximum zoom values.
    ///   - Zoom is automatically computed from the altitude (z)
    ///
    /// @return The position if set.
    Vec3? getPosition();

    /// Set the position of the camera in slightly modified web mercator coordinates
    ///   - The size of 1 unit is the width of the projected world instead of the "mercator meter".
    ///     Coordinate [0, 0, 0] is the north-west corner and [1, 1, 0] is the south-east corner.
    ///   - Z coordinate is conformal and must respect minimum and maximum zoom values.
    ///   - Zoom is automatically computed from the altitude (z)
    ///
    /// @param position The position to be set.
    void setPosition(Vec3? position);

    /// Get the orientation of the camera represented as a unit quaternion [x, y, z, w].
    ///   The default pose of the camera is such that the forward vector is looking up the -Z axis and
    ///   the up vector is aligned with north orientation of the map:
    ///     forward: [0, 0, -1]
    ///     up:      [0, -1, 0]
    ///     right    [1, 0, 0]
    ///
    ///     With the w value as the real part of the complex number
    ///
    /// @return The orientation if set.
    Vec4? getOrientation();

    /// Set the orientation of the camera represented as a unit quaternion [x, y, z, w].
    ///   The default pose of the camera is such that the forward vector is looking up the -Z axis and
    ///   the up vector is aligned with north orientation of the map:
    ///     forward: [0, 0, -1]
    ///     up:      [0, -1, 0]
    ///     right    [1, 0, 0]
    ///
    ///     With the w value as the real part of the complex number
    ///
    ///   Orientation can be set freely but certain constraints still apply
    ///    - Orientation must be representable with only pitch and bearing.
    ///    - Pitch has an upper limit
    ///
    /// @param orientation The orientation to be set.
    ///
    void setOrientation(Vec4? orientation);

    /// Helper function for setting the mercator position as Lat&Lng and altitude in meters
    ///
    /// @param location The mercator `coordinate`.
    /// @param altitude The altitude in meters.
    void setLocation(Map<String?, Object?> location, double altitude);

    /// Helper function for setting orientation of the camera by defining a focus point.
    /// Elevation of 0.0 is used and no up vector.
    ///
    /// @param location The `coordinate` representing focal point.
    void lookAtPoint(Map<String?, Object?> location);

    /// Helper function for setting orientation of the camera by defining a focus point.
    /// No up vector is used.
    ///
    /// @param location The `coordinate` representing focal point.
    /// @param altitude The altitude in meters of the focal point.
    void lookAtPoint2(Map<String?, Object?> location, double altitude);

    /// Helper function for setting orientation of the camera by defining a focus point.
    ///
    /// Up vector is required in certain scenarios where bearing can't be deduced from
    /// the viewing direction.
    ///
    /// @param location The `coordinate` representing focal point.
    /// @param altitude The altitude in meters of the focal point.
    /// @param upVector The up vector.
    void lookAtPoint3(Map<String?, Object?> location, double altitude, Vec3 upVector);

    /// Helper function for setting the orientation of the camera as a pitch and a bearing.
    ///
    /// @param pitch The pitch in degrees
    /// @param bearing The bearing in degrees
    void setPitchBearing(double pitch, double bearing);

}
*/

/// Describes glyphs rasterization modes.
enum GlyphsRasterizationMode {
  /// No glyphs are rasterized locally. All glyphs are loaded from the server.
  NO_GLYPHS_RASTERIZED_LOCALLY,

  /// Ideographs are rasterized locally, and they are not loaded from the server.
  IDEOGRAPHS_RASTERIZED_LOCALLY,

  /// All glyphs are rasterized locally. No glyphs are loaded from the server.
  ALL_GLYPHS_RASTERIZED_LOCALLY,
}

/// Describes the map context mode.
/// We can make some optimizations if we know that the drawing context is not shared with other code.
enum ContextMode {
  /// Unique context mode: in OpenGL, the GL context is not shared, thus we can retain knowledge about the GL state
  /// from a previous render pass. It also enables clearing the screen using glClear for the bottommost background
  /// layer when no pattern is applied to that layer.
  UNIQUE,

  /// Shared context mode: in OpenGL, the GL context is shared with other renderers, thus we cannot rely on the GL
  /// state set from a previous render pass.
  SHARED,
}

/// Describes whether to constrain the map in both axes or only vertically e.g. while panning.
enum ConstrainMode {
  /// No constrains.
  NONE,

  /// Constrain to height only
  HEIGHT_ONLY,

  /// Constrain both width and height axes.
  WIDTH_AND_HEIGHT,
}

/// Satisfies embedding platforms that requires the viewport coordinate systems to be set according to its standards.
enum ViewportMode {
  /// Default viewport
  DEFAULT,

  /// Viewport flipped on the y-axis.
  FLIPPED_Y,
}

/// Describes the map orientation.
enum NorthOrientation {
  /// Default, map oriented upwards
  UPWARDS,

  /// Map oriented righwards
  RIGHTWARDS,

  /// Map oriented downwards
  DOWNWARDS,

  /// Map oriented leftwards
  LEFTWARDS,
}

/// Options for enabling debugging features in a map.
enum MapDebugOptionsData {
  /// Edges of tile boundaries are shown as thick, red lines to help diagnose
  /// tile clipping issues.
  TILE_BORDERS,

  /// Each tile shows its tile coordinate (x/y/z) in the upper-left corner.
  PARSE_STATUS,

  /// Each tile shows a timestamp indicating when it was loaded.
  TIMESTAMPS,

  /// Edges of glyphs and symbols are shown as faint, green lines to help
  /// diagnose collision and label placement issues.
  COLLISION,

  /// Each drawing operation is replaced by a translucent fill. Overlapping
  /// drawing operations appear more prominent to help diagnose overdrawing.
  OVERDRAW,

  /// The stencil buffer is shown instead of the color buffer.
  STENCIL_CLIP,

  /// The depth buffer is shown instead of the color buffer.
  DEPTH_BUFFER,

  /// Visualize residency of tiles in the render cache. Tile boundaries of cached tiles
  /// are rendered with green, tiles waiting for an update with yellow and tiles not in the cache
  /// with red.
  RENDER_CACHE,

  /// Show 3D model bounding boxes. */
  MODEL_BOUNDS,

  /// Show a wireframe for terrain. */
  TERRAIN_WIREFRAME
}

/// Options for enabling debugging features in a map.
class MapDebugOptions {
  MapDebugOptionsData data;
}

/// Enum describing how to place view annotation relatively to geometry.
enum ViewAnnotationAnchor {
  /// The top of the view annotation is placed closest to the geometry.
  TOP,

  /// The left side of the view annotation is placed closest to the geometry. */
  LEFT,

  /// The bottom of the view annotation is placed closest to the geometry. */
  BOTTOM,

  /// The right side of the view annotation is placed closest to the geometry. */
  RIGHT,

  /// The top-left corner of the view annotation is placed closest to the geometry. */
  TOP_LEFT,

  /// The bottom-right corner of the view annotation is placed closest to the geometry. */
  BOTTOM_RIGHT,

  /// The top-right corner of the view annotation is placed closest to the geometry. */
  TOP_RIGHT,

  /// The bottom-left corner of the view annotation is placed closest to the geometry. */
  BOTTOM_LEFT,

  /// The center of the view annotation is placed closest to the geometry. */
  CENTER
}

/// Describes the glyphs rasterization option values.
class GlyphsRasterizationOptions {
  /// Glyphs rasterization mode for client-side text rendering.
  GlyphsRasterizationMode rasterizationMode;

  /// Font family to use as font fallback for client-side text renderings.
  ///
  /// Note: `GlyphsRasterizationMode` has precedence over font family. If `AllGlyphsRasterizedLocally`
  /// or `IdeographsRasterizedLocally` is set, local glyphs will be generated based on the provided font family. If no
  /// font family is provided, the map will fall back to use the system default font. The mechanisms of choosing the
  /// default font are varied in platforms:
  /// - For darwin(iOS/macOS) platform, the default font family is created from the <a href="https://developer.apple.com/documentation/uikit/uifont/1619027-systemfontofsize?language=objc">systemFont</a>.
  ///   If provided fonts are not supported on darwin platform, the map will fall back to use the first available font from the global fallback list.
  /// - For Android platform: the default font <a href="https://developer.android.com/reference/android/graphics/Typeface#DEFAULT">Typeface.DEFAULT</a> will be used.
  ///
  /// Besides, the font family will be discarded if it is provided along with `NoGlyphsRasterizedLocally` mode.
  ///
  String? fontFamily;
}

/// Map memory budget in megabytes.
class MapMemoryBudgetInMegabytes {
  int size;
}

/// Map memory budget in tiles.
class MapMemoryBudgetInTiles {
  int size;
}

/// Describes the map option values.
class MapOptions {
  /// The map context mode. This can be used to optimizations
  /// if we know that the drawing context is not shared with other code.
  ContextMode? contextMode;

  /// The map constrain mode. This can be used to limit the map
  /// to wrap around the globe horizontally. By default, it is set to
  /// `HeightOnly`.
  ConstrainMode? constrainMode;

  /// The viewport mode. This can be used to flip the vertical
  /// orientation of the map as some devices may use inverted orientation.
  ViewportMode? viewportMode;

  /// The orientation of the Map. By default, it is set to
  /// `Upwards`.
  NorthOrientation? orientation;

  /// Specify whether to enable cross-source symbol collision detection
  /// or not. By default, it is set to `true`.
  bool? crossSourceCollisions;

  /// With terrain on, if `true`, the map will render for performance
  /// priority, which may lead to layer reordering allowing to maximize
  /// performance (layers that are draped over terrain will be drawn first,
  /// including fill, line, background, hillshade and raster). Any layers that
  /// are positioned after symbols are draped last, over symbols. Otherwise, if
  /// set to `false`, the map will always be drawn for layer order priority.
  /// By default, it is set to `true`.
  bool? optimizeForTerrain;

  /// The size to resize the map object and renderer backend.
  /// The size is given in `platform pixel` units. macOS and iOS platforms use
  /// device-independent pixel units, while other platforms, such as Android,
  /// use screen pixel units.
  Size? size;

  /// The custom pixel ratio. By default, it is set to 1.0
  double pixelRatio;

  /// Glyphs rasterization options to use for client-side text rendering.
  GlyphsRasterizationOptions? glyphsRasterizationOptions;
}

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `platform pixels`.
class ScreenCoordinate {
  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;
}

/// Describes the coordinate box on the screen, measured in `platform pixels`
/// from top to bottom and from left to right.
class ScreenBox {
  /// The screen coordinate close to the top left corner of the screen.
  ScreenCoordinate min;

  /// The screen coordinate close to the bottom right corner of the screen.
  ScreenCoordinate max;
}

/// A coordinate bounds and zoom.
class CoordinateBoundsZoom {
  /// The latitude and longitude bounds.
  CoordinateBounds bounds;

  /// Zoom.
  double zoom;
}

/// Size type.
class Size {
  /// Width of the size.
  double width;

  /// Height of the size.
  double height;
}

/// Options for querying rendered features.
class RenderedQueryOptions {
  /// Layer IDs to include in the query.
  List<String?>? layerIds;

  /// Filters the returned features with an expression
  String? filter;
}

/// Options for querying source features.
class SourceQueryOptions {
  /// Source layer IDs to include in the query.
  List<String?>? sourceLayerIds;

  /// Filters the returned features with an expression
  String filter;
}

/// A value or a collection of a feature extension.
class FeatureExtensionValue {
  /// An optional value of a feature extension
  String? value;

  /// An optional array of features from a feature extension.
  List<Map<String?, Object?>?>? featureCollection;
}

/// Specifies position of a layer that is added via addStyleLayer method.
class LayerPosition {
  /// Layer should be positioned above specified layer id.
  String? above;

  /// Layer should be positioned below specified layer id.
  String? below;

  /// Layer should be positioned at specified index in a layers stack.
  int? at;
}

/// Represents query result that is returned in QueryFeaturesCallback.
/// @see `queryRenderedFeatures` or `querySourceFeatures`
class QueriedFeature {
  /// Feature returned by the query.
  Map<String?, Object?> feature;

  /// Source id for a queried feature.
  String source;

  /// Source layer id for a queried feature. May be null if source does not support layers, e.g., 'geojson' source,
  /// or when data provided by the source is not layered.
  String? sourceLayer;

  /// Feature state for a queried feature. Type of the value is an Object.
  /// @see `setFeatureState` and `getFeatureState`
  String state;
}

/// Parameters that defines behavior of the render cache.
class RenderCacheOptions {
  /// Maximum size allocated for the render cache in megabytes. Setting the value to zero will effectively disable the feature.
  ///
  /// Recommended starting values for the cache sizes are 64 and 128 for devices with pixel ratio 1.0 and > 1.0 respectively.
  int? size;
}

/// Various options needed for displaying view annotation.
class ViewAnnotationOptions {
  /// Geometry the view annotation is bound to. Currently only support 'point' geometry type.
  /// Note: geometry must be set when adding a new view annotation, otherwise an operation error will be returned from the call that is associated to this option.
  Map<String?, Object?>? geometry;

  /// Optional style symbol id connected to given view annotation.
  ///
  /// View annotation's visibility behaviour becomes tied to feature visibility where feature could represent an icon or a text label.
  /// E.g. if the bounded symbol is not visible view annotation also becomes not visible.
  ///
  /// Note: Invalid associatedFeatureId (meaning no actual symbol has such feature id) will lead to the cooresponding annotation to be invisible.
  String? associatedFeatureId;

  /// View annotation width in `platform pixels`.
  int? width;

  /// View annotation height in `platform pixels`.
  int? height;

  /// If true, the annotation will be visible even if it collides with other previously drawn annotations.
  /// If allowOverlap is null, default value `false` will be applied.
  bool? allowOverlap;

  /// Specifies if this view annotation is visible or not.
  ///
  /// Note: For Android and iOS platforms, if this property is not specified explicitly when creating / updating view annotation, visibility will be
  /// handled automatically based on actual Android or iOS view's visibility e.g. if actual view is set to be not visible - Android / iOS part
  /// will automatically update view annotation to have `visible = false`.
  ///
  /// If visible is null, default value `true` will be applied.
  bool? visible;

  /// Anchor describing where the view annotation will be located relatively to given geometry.
  /// If anchor is null, default value `CENTER` will be applied.
  ViewAnnotationAnchor? anchor;

  /// Extra X offset in `platform pixels`.
  /// Providing positive value moves view annotation to the right while negative moves it to the left.
  int? offsetX;

  /// Extra Y offset in `platform pixels`.
  /// Providing positive value moves view annotation to the top while negative moves it to the bottom.
  int? offsetY;

  /// Specifies if this view annotation is selected meaning it should be placed on top of others.
  /// If selected in null, default value `false` will be applied.
  bool? selected;
}

/// Type information of the variant's content
enum Type { SCREEN_BOX, SCREEN_COORDINATE, LIST }

/// Geometry for querying rendered features. */
class RenderedQueryGeometry {
  /// ScreenCoordinate/List<ScreenCoordinate>/ScreenBox in Json mode.
  String value;
  Type type;
}

/// Map class provides map rendering functionality.
///
@HostApi()
abstract class _MapInterface {
  @async
  void loadStyleURI(String styleURI);

  @async
  void loadStyleJson(String styleJson);

  @async
  void clearData();

  void setMemoryBudget(MapMemoryBudgetInMegabytes? mapMemoryBudgetInMegabytes,
      MapMemoryBudgetInTiles? mapMemoryBudgetInTiles);

  /// Gets the size of the map.
  ///
  /// @return The `size` of the map in `platform pixels`.
  Size getSize();

  /// Triggers a repaint of the map.
  void triggerRepaint();

  /// Tells the map rendering engine that there is currently a gesture in progress. This
  /// affects how the map renders labels, as it will use different texture filters if a gesture
  /// is ongoing.
  ///
  /// @param inProgress The `boolean` value representing if a gesture is in progress.
  void setGestureInProgress(bool inProgress);

  /// Returns `true` if a gesture is currently in progress.
  ///
  /// @return `true` if a gesture is currently in progress, `false` otherwise.
  bool isGestureInProgress();

  /// Tells the map rendering engine that the animation is currently performed by the
  /// user (e.g. with a `setCamera` calls series). It adjusts the engine for the animation use case.
  /// In particular, it brings more stability to symbol placement and rendering.
  ///
  /// @param inProgress The `boolean` value representing if user animation is in progress
  void setUserAnimationInProgress(bool inProgress);

  /// Returns `true` if user animation is currently in progress.
  ///
  /// @return `true` if a user animation is currently in progress, `false` otherwise.
  bool isUserAnimationInProgress();

  /// When loading a map, if prefetch zoom `delta` is set to any number greater than 0,
  /// the map will first request a tile at zoom level lower than `zoom - delta`, with requested
  /// zoom level a multiple of `delta`, in an attempt to display a full map at lower resolution as quick as possible.
  ///
  /// @param delta The new prefetch zoom delta.
  void setPrefetchZoomDelta(int delta);

  /// Returns the map's prefetch zoom delta.
  ///
  /// @return The map's prefetch zoom `delta`.
  int getPrefetchZoomDelta();

  /// Sets the north `orientation mode`.
  void setNorthOrientation(NorthOrientation orientation);

  /// Sets the map `constrain mode`.
  void setConstrainMode(ConstrainMode mode);

  /// Sets the `viewport mode`.
  void setViewportMode(ViewportMode mode);

  /// Returns the `map options`.
  ///
  /// @return The map's `map options`.
  MapOptions getMapOptions();

  /// Returns the `map debug options`.
  ///
  /// @return An array of `map debug options` flags currently set to the map.
  List<MapDebugOptions?> getDebug();

  /// Sets the `map debug options` and enables debug mode based on the passed value.
  ///
  /// @param debugOptions An array of `map debug options` to be set.
  /// @param value A `boolean` value representing the state for a given `map debug options`.
  ///
  void setDebug(List<MapDebugOptions?> debugOptions, bool value);

  /// Queries the map for rendered features.
  ///
  /// @param geometry The `screen pixel coordinates` (point, line string or box) to query for rendered features.
  /// @param options The `render query options` for querying rendered features.
  /// @param callback The `query features callback` called when the query completes.
  /// @return A `cancelable` object that could be used to cancel the pending query.
  @async
  List<QueriedFeature?> queryRenderedFeatures(
      RenderedQueryGeometry geometry, RenderedQueryOptions options);

  /// Queries the map for source features.
  ///
  /// @param sourceId The style source identifier used to query for source features.
  /// @param options The `source query options` for querying source features.
  /// @param callback The `query features callback` called when the query completes.
  @async
  List<QueriedFeature?> querySourceFeatures(
      String sourceId, SourceQueryOptions options);

  /// Returns all the leaves (original points) of a cluster (given its cluster_id) from a GeoJsonSource, with pagination support: limit is the number of leaves
  /// to return (set to Infinity for all points), and offset is the amount of points to skip (for pagination).
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  ///
  /// @param sourceIdentifier GeoJsonSource identifier.
  /// @param cluster Cluster from which to retrieve leaves from
  /// @param limit The number of points to return from the query (must use type [Long], set to maximum for all points). Defaults to 10.
  /// @param offset The amount of points to skip (for pagination, must use type [Long]). Defaults to 0.
  /// @param callback The result will be returned through the [QueryFeatureExtensionCallback].
  ///         The result is a feature collection or a string describing an error if the operation was not successful.
  @async
  FeatureExtensionValue getGeoJsonClusterLeaves(String sourceIdentifier,
      Map<String?, Object?> cluster, int? limit, int? offset);

  /// Returns the children (original points or clusters) of a cluster (on the next zoom level)
  /// given its id (cluster_id value from feature properties) from a GeoJsonSource.
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  ///
  /// @param sourceIdentifier GeoJsonSource identifier.
  /// @param cluster cluster from which to retrieve children from
  /// @param callback The result will be returned through the [QueryFeatureExtensionCallback].
  ///         The result is a feature collection or a string describing an error if the operation was not successful.
  @async
  FeatureExtensionValue getGeoJsonClusterChildren(
      String sourceIdentifier, Map<String?, Object?> cluster);

  /// Returns the zoom on which the cluster expands into several children (useful for "click to zoom" feature)
  /// given the cluster's cluster_id (cluster_id value from feature properties) from a GeoJsonSource.
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  ///
  /// @param sourceIdentifier GeoJsonSource identifier.
  /// @param cluster cluster from which to retrieve the expansion zoom from
  /// @param callback The result will be returned through the [QueryFeatureExtensionCallback].
  ///         The result is a feature extension value containing a value or a string describing an error if the operation was not successful.
  @async
  FeatureExtensionValue getGeoJsonClusterExpansionZoom(
      String sourceIdentifier, Map<String?, Object?> cluster);

  /// Updates the state object of a feature within a style source.
  ///
  /// Update entries in the `state` object of a given feature within a style source. Only properties of the
  /// `state` object will be updated. A property in the feature `state` object that is not listed in `state` will
  /// retain its previous value.
  ///
  /// Note that updates to feature `state` are asynchronous, so changes made by this method migth not be
  /// immediately visible using `getStateFeature`.
  ///
  /// @param sourceId The style source identifier.
  /// @param sourceLayerId The style source layer identifier (for multi-layer sources such as vector sources).
  /// @param featureId The feature identifier of the feature whose state should be updated.
  /// @param state The `state` object with properties to update with their respective new values.
  void setFeatureState(
      String sourceId, String? sourceLayerId, String featureId, String state);

  /// Gets the state map of a feature within a style source.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by other methods might not be
  /// immediately visible.
  ///
  /// @param sourceId The style source identifier.
  /// @param sourceLayerId The style source layer identifier (for multi-layer sources such as vector sources).
  /// @param featureId The feature identifier of the feature whose state should be queried.
  /// @param callback The `query feature state callback` called when the query completes.
  @async
  String getFeatureState(
      String sourceId, String? sourceLayerId, String featureId);

  /// Removes entries from a feature state object.
  ///
  /// Remove a specified property or all property from a feature's state object, depending on the value of
  /// `stateKey`.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by this method migth not be
  /// immediately visible using `getStateFeature`.
  ///
  /// @param sourceId The style source identifier.
  /// @param sourceLayerId The style source layer identifier (for multi-layer sources such as vector sources).
  /// @param featureId The feature identifier of the feature whose state should be removed.
  /// @param stateKey The key of the property to remove. If `null`, all feature's state object properties are removed.
  void removeFeatureState(String sourceId, String? sourceLayerId,
      String featureId, String? stateKey);

  /// Reduces memory use. Useful to call when the application gets paused or sent to background.
  void reduceMemoryUse();

  /// Gets the resource options for the map.
  ///
  /// All optional fields of the retuned object are initialized with the actual values.
  ///
  /// Note that result of this method is different from the `resource options` that were provided to the map's constructor.
  ///
  /// @return The `resource options` for the map.
  ResourceOptions getResourceOptions();

  /// Gets elevation for the given coordinate.
  /// Note: Elevation is only available for the visible region on the screen.
  ///
  /// @param coordinate The `coordinate` defined as longitude-latitude pair.
  /// @return The elevation (in meters) multiplied by current terrain exaggeration, or empty if elevation for the coordinate is not available.
  double? getElevation(Map<String?, Object?> coordinate);

  /// Enables or disables the experimental render cache feature.
  ///
  /// Render cache is an experimental feature aiming to reduce resource usage of map rendering
  /// by caching intermediate rendering results of tiles into specific cache textures for reuse between frames.
  /// Performance benefit of the cache depends on the style as not all layers are cacheable due to e.g.
  /// viewport aligned features. Render cache always prefers quality over performance.
  ///
  /// @param options The `render cache options` defining the render cache behavior.
  void setRenderCacheOptions(RenderCacheOptions options);

  /// Returns the `render cache options` used by the map.
  ///
  /// @return The `render cache options` currently used by the map.
  RenderCacheOptions getRenderCacheOptions();

/*
    /// Clears temporary map data.
    ///
    /// Clears temporary map data from the data path defined in the given resource options.
    /// Useful to reduce the disk usage or in case the disk cache contains invalid data.
    /// Note that calling this API will affect all maps that use the same data path.
    /// Note that calling this API does not affect persistent map data like offline style packages.
    ///
    /// @param resourceOptions The `resource options` that contan the map data path to be used
    /// @param callback Called once the request is complete or an error occurred.
    @async
    undefined clearData(ResourceOptions resourceOptions);
*/
}

/// Describes the reason for a style package download request failure.
enum StylePackErrorType {
  /// The operation was canceled.
  CANCELED,

  /// The style package does not exist.
  DOES_NOT_EXIST,

  /// There is no available space to store the resources.
  DISK_FULL,

  /// Other reason.
  OTHER,
}

/// The `style pack` represents a stored style package.
class StylePack {
  /// The style associated with the style package.
  String styleURI;

  /// The glyphs rasterization mode of the style package.
  ///
  /// It defines which glyphs will be loaded from the server.
  GlyphsRasterizationMode glyphsRasterizationMode;

  /// The number of resources that are known to be required for this style package.
  int requiredResourceCount;

  /// The number of resources that have been fully downloaded and are ready for
  /// offline access.
  int completedResourceCount;

  /// The cumulative size, in bytes, of all resources that have
  /// been fully downloaded.
  int completedResourceSize;

  /// The earliest point in time when any of the style package resources gets expired.
  ///
  /// Unitialized for incomplete style packages or for complete style packages with all immutable resources.
  int? expires;
}

/// A `style pack load` progress includes information about
/// the number of resources that have completed downloading
/// and the total number of resources that are required.
class StylePackLoadProgress {
  /// The number of resources that are ready for offline access.
  int completedResourceCount;

  /// The cumulative size, in bytes, of all resources that are ready for offline access.
  int completedResourceSize;

  /// The number of resources that have failed to download due to an error.
  int erroredResourceCount;

  /// The number of resources that are known to be required for this style package.
  int requiredResourceCount;

  /// The number of resources that have been fully downloaded from the network.
  int loadedResourceCount;

  /// The cumulative size, in bytes, of all resources that have been fully downloaded
  /// from the network.
  int loadedResourceSize;
}

/// Describes a style package load request error.
class StylePackError {
  /// The reason for the response error.
  StylePackErrorType type;

  /// An error message.
  String message;
}

/// Describes the style package load option values.
class StylePackLoadOptions {
  /// Specifies glyphs rasterization mode.
  ///
  /// If provided, updates the style package's glyphs rasterization mode,
  /// which defines which glyphs will be loaded from the server.
  ///
  /// By default, ideographs are rasterized locally and other glyphs are loaded
  /// from network (i.e. `IdeographsRasterizedLocally` value is used).
  GlyphsRasterizationMode? glyphsRasterizationMode;

  /// A custom Mapbox value associated with this style package for storing metadata.
  ///
  /// If provided, the custom value value will be stored alongside the style package. Previous values will
  /// be replaced with the new value.
  ///
  /// Developers can use this field to store custom metadata associated with a style package.
  String? metadata;

  /// Accepts expired data when loading style resources.
  ///
  /// This flag should be set to true to accept expired responses. When a style resource is already loaded but expired,
  /// no attempt will be made to refresh the data. This may lead to outdated data. Set to false to ensure that data
  /// for a style is up-to-date.
  bool acceptExpired;
}

/// Describes the style package load option values.
class TilesetDescriptorOptions {
  /// The style associated with the tileset descriptor
  String styleURI;

  /// Minimum zoom level for the tile package.
  ///
  /// Note: the implementation loads and stores the loaded tiles
  /// in batches, each batch has a pre-defined zoom range and it contains
  /// all child tiles within the range.
  /// The currently used tile batches zoom ranges are:
  /// - Global coverage: 0 - 5
  /// - Regional information: 6 - 10
  /// - Local information: 11 - 14
  /// - Streets detail: 15 - 16
  ///
  /// Internally, the implementation maps the given tile pack zoom range
  /// and geometry to a set of pre-defined batches to load, therefore
  /// it is highly recommended to choose the `minZoom` and `maxZoom` values
  /// in accordance with the tile batches zoom ranges (see the list above).
  int minZoom;

  /// Maximum zoom level for the tile package.
  ///
  /// maxZoom value cannot exceed the maximum allowed tile batch zoom value,
  /// @see `minZoom`
  int maxZoom;

  /// Pixel ratio to be accounted for when downloading raster tiles.
  ///
  /// The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
  double pixelRatio;

  /// Style package load options, associated with the tileset descriptor.
  ///
  /// If provided, `offline manager` will create a style package while resolving the corresponding
  /// tileset descriptor and load all the resources as defined in the provided style package options,
  /// i.e. resolving of corresponding the tileset descriptor will be equivalent to calling the `loadStylePack`
  /// method of `offline manager`.
  /// If not provided, resolving of the corresponding tileset descriptor will not cause creating of a new style
  /// package but the loaded resources will be stored in the disk cache.
  StylePackLoadOptions? stylePackOptions;
}

/*
/// An `offline manager` manages downloads and storage for style packages and also produces tileset descriptors for the `tile store`.
///
/// All the asynchronous methods calls complete even if the `offline manager` instance gets out of scope before.
@HostApi()
abstract class OfflineManager {
    /// Construct a new `tileset descriptor` for the `tile store`.
    ///
    /// Tileset descriptors are used by the `tile store` to create new offline regions.
    /// Resolving the created tileset descriptor includes loading and parsing the style and might include
    /// creation or update of a style package - depending on the given options.
    ///
    /// @param tilesetDescriptorOptions The `tileset descriptor options` to manage.
    /// @return A new `tileset descriptor`.
    TilesetDescriptor createTilesetDescriptor(TilesetDescriptorOptions tilesetDescriptorOptions);

    /// Loads a new style package or updates the existing one.
    ///
    /// If a style package with the given id already exists, it gets updated with
    /// the values provided to the given load options. The missing resources get
    /// loaded and the expired resources get updated.
    ///
    /// If there no values provided to the given load options, the existing style package
    /// gets refreshed: the missing resources get loaded and the expired resources get updated.
    ///
    /// A failed load request can be reattempted with another loadStylePack() call.
    ///
    /// If the style cannot be fetched for any reason, the load request is terminated.
    /// If the style is fetched but loading some of the style package resources fails,
    /// the load request proceeds trying to load the remaining style package resources.
    ///
    /// @param styleURI The URI of the style package's associated style
    /// @param loadOptions The `style pack load options`.
    /// @param onProgress The callback that may be invoked multiple times to report progess of the loading operation.
    /// @param onFinished The callback that is invoked only once upon success, failure, or cancelation of the loading operation.
    /// @return A `cancelable` object that could be used to cancel the load request.
    Cancelable loadStylePack(String styleURI, StylePackLoadOptions loadOptions, StylePackLoadProgressCallback onProgress, StylePackCallback onFinished);

    /// An overloaded version that does not report progess of the loading operation.
    ///
    /// @param styleURI The URI of the style package's associated style
    /// @param loadOptions The `style pack load options`.
    /// @param onFinished The callback that is invoked only once upon success, failure, or cancelation of the loading operation.
    /// @return A `cancelable` object that could be used to cancel the load request.
    Cancelable loadStylePack2(String styleURI, StylePackLoadOptions loadOptions, StylePackCallback onFinished);

    /// Returns a list of the existing style packages.
    ///
    /// Note: The user-provided callbacks will be executed on a worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param callback The `style packs callback`.
    @async
    List<StylePack?> getAllStylePacks();

    /// Returns a style package by its id.
    ///
    /// Note: The user-provided callbacks will be executed on a worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param styleURI The URI of the style package's associated style
    /// @param callback The `style pack callback`.
    @async
    StylePack getStylePack(String styleURI);

    /// Returns a style package's associated metadata
    ///
    /// The style package's associated metadata that a user previously set.
    ///
    /// @param styleURI The URI of the style package's associated style
    /// @param callback The `style pack metadata callback`.
    @async
    String getStylePackMetadata(String styleURI);

    /// Removes a style package.
    ///
    /// Removes a style package from the existing packages list. The actual resources
    /// eviction might be deferred as the implementation can first put the resources to the disk cache.
    /// Call `MapboxMap#clearData()` API to make sure all the temporary data is physically removed
    /// from the disk cache.
    ///
    /// All pending loading operations for the style package with the given id will
    /// fail with `Canceled` error.
    ///
    /// @param styleURI The URI of the style package's associated style
    void removeStylePack(String styleURI);

}
*/

/// Describes the reason for an offline request response error.
enum ResponseErrorReason {
  /// The resource is not found.
  NOT_FOUND,

  /// The server error. */
  SERVER,

  /// The connection error. */
  CONNECTION,

  /// The error happened because of a rate limit. */
  RATE_LIMIT,

  /// Other reason. */
  OTHER
}

/// Describes the download state of a region.
enum OfflineRegionDownloadState {
  /// Indicates downloading is inactive.
  INACTIVE,

  /// Indicates downloading is active. */
  ACTIVE
}

/// Describes an offline request response error.
class ResponseError {
  /// The reason for the response error.
  ResponseErrorReason reason;

  /// An error message
  String message;

  /// Time after which to try again.
  int? retryAfter;
}

/// A region's status includes its active/inactive state as well as counts
/// of the number of resources that have completed downloading, their total
/// size in bytes, and the total number of resources that are required.
///
/// Note that the total required size in bytes is not currently available. A
/// future API release may provide an estimate of this number.
class OfflineRegionStatus {
  /// Describes the download state.
  OfflineRegionDownloadState downloadState;

  /// The number of resources that have been fully downloaded and are ready for
  /// offline access.
  int completedResourceCount;

  /// The cumulative size, in bytes, of all resources (inclusive of tiles) that have
  /// been fully downloaded.
  int completedResourceSize;

  /// The number of tiles that are known to be required for this region. This is a
  /// subset of `completedResourceCount`.
  int completedTileCount;

  /// The number of tiles that are known to be required for this region.
  int requiredTileCount;

  /// The cumulative size, in bytes, of all tiles that have been fully downloaded.
  /// This is a subset of `completedResourceSize`.
  int completedTileSize;

  /// The number of resources that are known to be required for this region. See the
  /// documentation for `requiredResourceCountIsPrecise` for an important caveat
  /// about this number.
  int requiredResourceCount;

  /// This property is true when the value of requiredResourceCount is a precise
  /// count of the number of required resources, and false when it is merely a lower
  /// bound.
  ///
  /// Specifically, it is false during early phases of an offline download. Once
  /// style and tile sources have been downloaded, it is possible to calculate the
  /// precise number of required resources, at which point it is set to true.
  bool requiredResourceCountIsPrecise;
}

/// An offline region definition is a geographic region defined by a style URL,
/// a geometry, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
/// and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
/// the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
/// The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
class OfflineRegionGeometryDefinition {
  /// The style associated with the offline region
  String styleURL;

  /// The geometry that defines the boundary of the offline region
  Map<String?, Object?> geometry;

  /// Minimum zoom level for the offline region
  double minZoom;

  /// Maximum zoom level for the offline region
  double maxZoom;

  /// Pixel ratio to be accounted for when downloading assets
  double pixelRatio;

  /// Specifies glyphs rasterization mode. It defines which glyphs will be loaded from the server
  GlyphsRasterizationMode glyphsRasterizationMode;
}

/// An offline region definition is a geographic region defined by a style URL,
/// geographic bounding box, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
/// and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
/// the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
/// The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
class OfflineRegionTilePyramidDefinition {
  /// The style associated with the offline region.
  String styleURL;

  /// The bounds covering the region.
  CoordinateBounds bounds;

  /// Minimum zoom level for the offline region.
  double minZoom;

  /// Maximum zoom level for the offline region.
  double maxZoom;

  /// Pixel ratio to be accounted for when downloading assets.
  double pixelRatio;

  /// Specifies glyphs download mode.
  GlyphsRasterizationMode glyphsRasterizationMode;
}

/// An offline region represents an identifiable geographic region with optional metadata.
@HostApi()
abstract class OfflineRegion {
  /// The regions identifier
  int getIdentifier();

  /// The tile pyramid defining the region. Tile pyramid and geometry definitions are
  /// mutually exclusive.
  ///
  /// @return A definition describing the tile pyramid including attributes, otherwise empty.
  OfflineRegionTilePyramidDefinition? getTilePyramidDefinition();

  /// The geometry defining the region. Geometry and tile pyramid definitions are
  /// mutually exclusive.
  ///
  /// @return A definition describing the geometry including attributes, otherwise empty.
  OfflineRegionGeometryDefinition? getGeometryDefinition();

  /// Arbitrary binary region metadata.
  ///
  /// @return The metadata associated with the region.
  Uint8List getMetadata();

  /// Sets arbitrary binary region metadata for the region.
  ///
  /// Note that this setter is asynchronous and the given metadata is applied only
  /// after the resulting callback is invoked with no error.
  ///
  /// @param metadata The metadata associated with the region.
  /// @param callback Called once the request is complete or an error occurred.
  @async
  void setMetadata(Uint8List metadata);

  /// Sets the download state of an offline region
  /// A region is either inactive (not downloading, but previously-downloaded
  /// resources are available for use), or active (resources are being downloaded
  /// or will be downloaded, if necessary, when network access is available).
  ///
  /// If the region is already in the given state, this call is ignored.
  ///
  /// @param state The new state to set.
  void setOfflineRegionDownloadState(OfflineRegionDownloadState state);

/*
    /// Register an observer to be notified when the state of the region changes.
    ///
    /// @param observer The observer that will be notified when a region’s status changes.
    void setOfflineRegionObserver(OfflineRegionObserver observer);
*/

  /// Invalidate all the tiles for the region forcing to revalidate
  /// the tiles with the server before using. This is more efficient than deleting the
  /// offline region and downloading it again because if the data on the cache matches
  /// the server, no new data gets transmitted.
  ///
  /// @param callback Called once the request is complete or an error occurred.
  @async
  void invalidate();

  /// Remove an offline region from the database and perform any resources
  /// evictions necessary as a result.
  ///
  /// @param callback Called once the request is complete or an error occurred.
  @async
  void purge();
}

/// The `offline region manager` that manages offline packs. All of the class’s instance methods are asynchronous
/// reflecting the fact that offline resources are stored in a database. The offline manager maintains a canonical
/// collection of offline packs.
@HostApi()
abstract class OfflineRegionManager {
/*
    /// Invoke a call to fetch a list of offline regions.
    ///
    /// @param callback Invoked upon success and failure. This callback is invoked on the database thread and the user
    /// is responsible for dispatching to an appropriate thread before passing it along.
    @async
    List<OfflineRegion?> getOfflineRegions();

    /// Creates a new offline region based on a geometry
    ///
    /// @param geometryDefinition A previously defined definition over the region.
    /// @param callback Invoked upon success and failure. This callback is invoked on the database thread and the user
    /// is responsible for dispatching to an appropriate thread before passing it along.
    @async
    OfflineRegion createOfflineRegion(OfflineRegionGeometryDefinition geometryDefinition);

    /// Creates a new offline region based on a tile pyramid
    ///
    /// @param tilePyramidDefinition A tile pyramid definition
    /// @param callback Invoked upon success and failure. This callback is invoked on the database thread and the user
    /// is responsible for dispatching to an appropriate thread before passing it along.
    @async
    OfflineRegion createOfflineRegion2(OfflineRegionTilePyramidDefinition tilePyramidDefinition);

    /// Merge offline regions from a secondary database into the main offline database.
    ///
    /// @param filePath The file path to the secondary database.
    /// @param callback Invoked upon success and failure. This callback is invoked on the database thread and the user
    /// is responsible for dispatching to an appropriate thread before passing it along.
    @async
    List<OfflineRegion?> mergeOfflineDatabase(String filePath);
*/

  /// Sets the maximum number of Mapbox-hosted tiles that may be downloaded and stored on the current device.
  ///
  /// By default, the limit is set to 6,000.
  /// Once this limit is reached, `OfflineRegionObserver.mapboxTileCountLimitExceeded()`
  /// fires every additional attempt to download additional tiles until already downloaded tiles are removed
  /// by calling `OfflineRegion.purge()` API.
  ///
  /// @param limit the maximum number of tiles allowed to be downloaded
  void setOfflineMapboxTileCountLimit(int limit);
}

/// ProjectedMeters is a coordinate in a specific
/// [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html) projection.
///
/// This specific Spherical Mercator projection assumes the Earth is a sphere with a radius
/// of 6,378,137 meters. Coordinates are determined as distances, in meters, on the surface
/// of that sphere.
class ProjectedMeters {
  /// Projected meters in north direction.
  double northing;

  /// Projected meters in east direction.
  double easting;
}

/// Describes a point on the map in Mercator projection.
class MercatorCoordinate {
  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;
}

/// Collection of [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html) projection methods.
@HostApi()
abstract class Projection {
  /// Calculate distance spanned by one pixel at the specified latitude
  /// and zoom level.
  ///
  /// @param latitude The latitude for which to return the value.
  /// @param zoom The zoom level.
  ///
  /// @return Returns the distance measured in meters.
  double getMetersPerPixelAtLatitude(double latitude, double zoom);

  /// Calculate Spherical Mercator ProjectedMeters coordinates.
  ///
  /// @param coordinate A longitude-latitude pair for which to calculate
  /// `projected meters` coordinates.
  ///
  /// @return Returns Spherical Mercator ProjectedMeters coordinates.
  ProjectedMeters projectedMetersForCoordinate(
      Map<String?, Object?> coordinate);

  /// Calculate a longitude-latitude pair for a Spherical Mercator projected
  /// meters.
  ///
  /// @param projectedMeters Spherical Mercator ProjectedMeters coordinates for
  /// which to calculate a longitude-latitude pair.
  ///
  /// @return Returns a longitude-latitude pair.
  Map<String?, Object?> coordinateForProjectedMeters(
      ProjectedMeters projectedMeters);

  /// Calculate a point on the map in Mercator Projection for a given
  /// coordinate at the specified zoom scale.
  ///
  /// @param coordinate The longitude-latitude pair for which to return the value.
  /// @param zoomScale The current zoom factor (2 ^ Zoom level) applied on the map, is used to
  /// calculate the world size as tileSize * zoomScale (i.e., 512 * 2 ^ Zoom level)
  /// where tileSize is the width of a tile in pixels.
  ///
  /// @return Returns a point on the map in Mercator projection.
  MercatorCoordinate project(
      Map<String?, Object?> coordinate, double zoomScale);

  /// Calculate a coordinate for a given point on the map in Mercator Projection.
  ///
  /// @param coordinate Point on the map in Mercator projection.
  /// @param zoomScale The current zoom factor applied on the map, is used to
  /// calculate the world size as tileSize * zoomScale (i.e., 512 * 2 ^ Zoom level)
  /// where tileSize is the width of a tile in pixels.
  ///
  /// @return Returns a coordinate.
  Map<String?, Object?> unproject(
      MercatorCoordinate coordinate, double zoomScale);
}

/// Describes tile store usage modes.
enum TileStoreUsageMode {
  /// Tile store usage is disabled.
  ///
  /// The implementation skips checking tile store when requesting a tile.
  DISABLED,

  /// Tile store enabled for accessing loaded tile packs.
  ///
  /// The implementation first checks tile store when requesting a tile.
  /// If a tile pack is already loaded, the tile will be extracted and returned. Otherwise, the implementation
  /// falls back to requesting the individual tile and storing it in the disk cache.
  READ_ONLY,

  /// Tile store enabled for accessing local tile packs and for loading new tile packs from server.
  ///
  /// All tile requests are converted to tile pack requests, i.e.
  /// the tile pack that includes the request tile will be loaded, and the tile extracted
  /// from it. In this mode, no individual tile requests will be made.
  ///
  /// This mode can be useful if the map trajectory is predefined and the user cannot pan
  /// freely (e.g. navigation use cases), so that there is a good chance tile packs are already loaded
  /// in the vicinity of the user.
  ///
  /// If users can pan freely, this mode is not recommended. Otherwise, panning
  /// will download tile packs instead of using individual tiles. Note that this means that we could first
  /// download an individual tile, and then a tile pack that also includes this tile. The individual tile in
  /// the disk cache won’t be used as long as the up-to-date tile pack exists in the cache.
  READ_AND_UPDATE,
}

/// Options to configure a resource
class ResourceOptions {
  /// The access token that is used to access resources provided by Mapbox services.
  String accessToken;

  /// The base URL that would be used to make HTTP requests. By default it is `https://api.mapbox.com`.
  String? baseURL;

  /// The path to the map data folder.
  ///
  /// The implementation will use this folder for storing offline style packages and temporary data.
  ///
  /// The application must have sufficient permissions to create files within the provided directory.
  /// If a dataPath is not provided, the default location will be used (the application data path defined
  /// in the `Mapbox Common SystemInformation API`).
  String? dataPath;

  /// The path to the folder where application assets are located. Resources whose protocol is `asset://`
  /// will be fetched from an asset folder or asset management system provided by respective platform.
  /// This option is ignored for Android platform. An iOS application may provide path to an application bundle's path.
  String? assetPath;

/*
    /// The tile store instance.
    ///
    /// This setting can be applied only if tile store usage is enabled,
    /// otherwise it is ignored.
    ///
    /// If not set and tile store usage is enabled, a tile store at the default
    /// location will be created and used.
    TileStore? tileStore;
*/

  /// The tile store usage mode.
  TileStoreUsageMode? tileStoreUsageMode;
}

/// Settings class provides non-persistent, in-process key-value storage.
@HostApi()
abstract class Settings {
  /// Sets setting value for a specified key.
  ///
  /// @param key A name of the key.
  /// @param value The `value` for the key.
  void set(String key, String value);

  /// Return value for a key.
  ///
  /// @param key A name of the key.
  ///
  /// @return `value` if a key exists in settings otherwise a `null value` will be returned.
  String get(String key);
}

/// Set of options for taking map snapshot with `map snapshotter`.
class MapSnapshotOptions {
  /// Dimensions of the snapshot in `platform pixel` units.
  Size size;

  /// Ratio between the number device-independent and screen pixels.
  double pixelRatio;

  /// Glyphs rasterization options to use for client-side text rendering.
  /// By default, `GlyphsRasterizationOptions` will use `NoGlyphsRasterizedLocally` mode.
  GlyphsRasterizationOptions? glyphsRasterizationOptions;

  /// The `resource options` to be used by the snapshotter.
  ResourceOptions resourceOptions;
}

/// An image snapshot of a map rendered by `map snapshotter`.
@HostApi()
abstract class MapSnapshot {
  /// Calculate screen coordinate on the snapshot from geographical `coordinate`.
  ///
  /// @param coordinate A geographical `coordinate`.
  /// @return A `screen coordinate` measured in `platform pixels` on the snapshot for geographical `coordinate`.
  ScreenCoordinate screenCoordinate(Map<String?, Object?> coordinate);

  /// Calculate geographical coordinates from a point on the snapshot.
  ///
  /// @param screenCoordinate A `screen coordinate` on the snapshot in `platform pixels`.
  /// @return A geographical `coordinate` for a `screen coordinate` on the snapshot.
  Map<String?, Object?> coordinate(ScreenCoordinate screenCoordinate);

  /// Get list of attributions for the sources in this snapshot.
  ///
  /// @return A list of attributions for the sources in this snapshot.
  List<String?> attributions();

  /// Get the rendered snapshot `image`.
  ///
  /// @return A rendered snapshot `image`.
  MbxImage image();
}

/// MapSnapshotter exposes functionality to capture static map images.
@HostApi()
abstract class MapSnapshotter {
  /// Sets the `size` of the snapshot
  ///
  /// @param size The new `size` of the snapshot in `platform pixels`.
  void setSize(Size size);

  /// Gets the size of the snapshot
  ///
  /// @return Snapshot `size` in `platform pixels`.
  Size getSize();

  /// Returns `true` if the snapshotter is in the tile mode.
  ///
  /// @return `true` if the snapshotter is in the tile mode, `false` otherwise.
  bool isInTileMode();

  /// Sets the snapshotter to the tile mode.
  ///
  /// In the tile mode, the snapshotter fetches the still image of a single tile.
  ///
  /// @param set A `boolean` value representing if the snapshotter is in the tile mode.
  void setTileMode(bool set);

/*
    /// Start the rendering of a snapshot.
    ///
    /// Request that a new snapshot be rendered. If there is a pending snapshot request, it
    /// is cancelled automatically.
    ///
    /// @param callback The `snapshot complete callback` to call once the snapshot is complete or an error occurred.
    @async
    MapSnapshot start();
*/

  /// Cancel the current snapshot operation.
  ///
  /// Cancel the current snapshot operation, if any. The callback passed to the start method
  /// is called with error parameter set.
  void cancel();

  /// Get elevation for the given coordinate.
  /// Note: Elevation is only available for the visible region on the screen.
  ///
  /// @param coordinate defined as longitude-latitude pair.
  ///
  /// @return Elevation (in meters) multiplied by current terrain exaggeration, or empty if elevation for the coordinate is not available.
  double? getElevation(Map<String?, Object?> coordinate);
}

/// Describes the kind of a style property value.
enum StylePropertyValueKind {
  /// The property value is not defined.
  UNDEFINED,

  /// The property value is a constant. */
  CONSTANT,

  /// The property value is a style [expression](https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions). */
  EXPRESSION,

  /// Property value is a style [transition](https://docs.mapbox.com/mapbox-gl-js/style-spec/#transition). */
  TRANSITION
}

/// The information about style object (source or layer).
class StyleObjectInfo {
  /// The object's identifier.
  String id;

  /// The object's type.
  String type;
}

/// Image type.
class MbxImage {
  /// The width of the image, in screen pixels.
  int width;

  /// The height of the image, in screen pixels.
  int height;

  /// 32-bit premultiplied RGBA image data.
  ///
  /// An uncompressed image data encoded in 32-bit RGBA format with premultiplied
  /// alpha channel. This field should contain exactly `4 * width * height` bytes. It
  /// should consist of a sequence of scanlines.
  Uint8List data;
}

/// Describes the image stretch areas.
class ImageStretches {
  /// The first stretchable part in screen pixel units.
  double first;

  /// The second stretchable part in screen pixel units.
  double second;
}

/// Describes the image content, e.g. where text can be fit into an image.
///
/// When sizing icons with `icon-text-fit`, the icon size will be adjusted so that the this content box fits exactly around the text.
class ImageContent {
  /// Distance to the left, in screen pixels.
  double left;

  /// Distance to the top, in screen pixels.
  double top;

  /// Distance to the right, in screen pixels.
  double right;

  /// Distance to the bottom, in screen pixels.
  double bottom;
}

/// The `transition options` controls timing for the interpolation between a transitionable style
/// property's previous value and new value. These can be used to define the style default property
/// transition behavior. Also, any transitionable style property may also have its own `-transition`
/// property that defines specific transition timing for that specific layer property, overriding
/// the global transition values.
class TransitionOptions {
  /// Time allotted for transitions to complete. Units in milliseconds. Defaults to `300.0`.
  int? duration;

  /// Length of time before a transition begins. Units in milliseconds. Defaults to `0.0`.
  int? delay;

  /// Whether the fade in/out symbol placement transition is enabled. Defaults to `true`.
  bool? enablePlacementTransitions;
}

/// Represents a tile coordinate.
class CanonicalTileID {
  /// The z value of the coordinate (zoom-level).
  int z;

  /// The x value of the coordinate.
  int x;

  /// The y value of the coordinate.
  int y;
}

/// Options for custom geometry tiles.
class TileOptions {
  /// Douglas-Peucker simplification tolerance (higher means simpler geometries and faster performance). Default is `0.375`.
  double tolerance;

  /// Size of the tiles. Tile size must be a power of 2. Default is `512`.
  int tileSize;

  /// Tile buffer size on each side (measured in 1/512ths of a tile; higher means fewer rendering artifacts near tile edges but slower performance). Default is `128`.
  int buffer;

  /// If the data includes geometry outside the tile boundaries, setting this to true clips the geometry to the tile boundaries. Default is `false`;
  bool clip;

  /// If the data includes wrapped coordinates, setting this to true unwraps the coordinates. Default is `false`;
  bool wrap;
}

/*
/// Options for custom geometry source.
class CustomGeometrySourceOptions {
    /// The callback that provides data for a tile.
    FetchTileFunctionCallback fetchTileFunction;
    /// The callback that cancels a tile.
    CancelTileFunctionCallback cancelTileFunction;
    /// A minimum zoom level, at which to create vector tiles.
    ///
    /// The default value is `0`.
    int minZoom;
    /// A maximum zoom level, at which to create vector tiles.
    ///
    /// A higher maximum zoom level provides greater details at high map zoom levels.
    ///
    /// The default value is `18`.
    int maxZoom;
    /// Tile options.
    TileOptions tileOptions;
}
*/

/// Holds a style property value with meta data.
class StylePropertyValue {
  /// The property value.
  String value;

  /// The kind of the property value.
  StylePropertyValueKind kind;
}

/// Parameters that define the current camera position for a `CustomLayerHost::render()` function.
class CustomLayerRenderParameters {
  /// The width.
  double width;

  /// The height.
  double height;

  /// The latitude of camera position.
  double latitude;

  /// The longitude of camera position.
  double longitude;

  /// The zoom of the camera.
  double zoom;

  /// The bearing (orientation) of the camera. In degrees clockwise from north, it describes the direction in which the camera points.
  double bearing;

  /// The pitch of the camera, the angle of pitch applied to the camera around the x-axis.
  double pitch;

  /// The field of view of the camera in degrees
  double fieldOfView;

  /// The projection matrix used for rendering. It projects spherical mercator coordinates to gl coordinates.
  List<double?> projectionMatrix;

  /// If terrain is enabled, provides value to elevation data from render thread. Empty if terrain is not enabled.
  ElevationData? elevationData;
}

/// Interface for managing style of the `map`.
@HostApi()
abstract class StyleManager {
  /// Get the URI of the current style in use.
  ///
  /// @return A string containing a style URI.
  @async
  String getStyleURI();

  /// Load style from provided URI.
  ///
  /// This is an asynchronous call. To check the result of this operation the user must register an observer observing
  /// `MapLoaded` or `MapLoadingError` events. In case of successful style load, `StyleLoaded` event will be also emitted.
  ///
  /// @param uri URI where the style should be loaded from.
  @async
  void setStyleURI(String uri);

  /// Get the JSON serialization string of the current style in use.
  ///
  /// @return A JSON string containing a serialized style.
  @async
  String getStyleJSON();

  /// Load the style from a provided JSON string.
  ///
  /// @param json A JSON string containing a serialized style.
  @async
  void setStyleJSON(String json);

  /// Returns the map style's default camera, if any, or a default camera otherwise.
  /// The map style's default camera is defined as follows:
  /// - [center](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-center)
  /// - [zoom](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-zoom)
  /// - [bearing](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-bearing)
  /// - [pitch](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-pitch)
  ///
  /// The style default camera is re-evaluated when a new style is loaded.
  ///
  /// @return The default `camera options` of the current style in use.
  @async
  CameraOptions getStyleDefaultCamera();

  /// Returns the map style's transition options. By default, the style parser will attempt
  /// to read the style default transition options, if any, fallbacking to an immediate transition
  /// otherwise. Transition options can be overriden via `setStyleTransition`, but the options are
  /// reset once a new style has been loaded.
  ///
  /// The style transition is re-evaluated when a new style is loaded.
  ///
  /// @return The `transition options` of the current style in use.
  @async
  TransitionOptions getStyleTransition();

  /// Overrides the map style's transition options with user-provided options.
  ///
  /// The style transition is re-evaluated when a new style is loaded.
  ///
  /// @param transitionOptions The `transition options`.
  @async
  void setStyleTransition(TransitionOptions transitionOptions);

  /// Adds a new [style layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
  ///
  /// Runtime style layers are valid until they are either removed or a new style is loaded.
  ///
  /// @param properties A map of style layer properties.
  /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  @async
  void addStyleLayer(String properties, LayerPosition? layerPosition);

/*
    /// Adds a new [style custom layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
    ///
    /// Runtime style layers are valid until they are either removed or a new style is loaded.
    ///
    /// @param layerId A style layer identifier.
    /// @param layerHost The `custom layer host`.
    /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
    ///
    /// @return A string describing an error if the operation was not successful, or empty otherwise.
    void addStyleCustomLayer(String layerId, CustomLayerHost layerHost, LayerPosition? layerPosition);
*/

  /// Adds a new [style layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
  ///
  /// Whenever a new style is being parsed and currently used style has persistent layers,
  /// an engine will try to do following:
  ///   - keep the persistent layer at its relative position
  ///   - keep the source used by a persistent layer
  ///   - keep images added through `addStyleImage` method
  ///
  /// In cases when a new style has the same layer, source or image resource, style's resources would be
  /// used instead and `MapLoadingError` event will be emitted.
  ///
  /// @param properties A map of style layer properties.
  /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  @async
  void addPersistentStyleLayer(String properties, LayerPosition? layerPosition);

/*
    /// Adds a new [style custom layer](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers).
    ///
    /// Whenever a new style is being parsed and currently used style has persistent layers,
    /// an engine will try to do following:
    ///   - keep the persistent layer at its relative position
    ///   - keep the source used by a persistent layer
    ///   - keep images added through `addStyleImage` method
    ///
    /// In cases when a new style has the same layer, source or image resource, style's resources would be
    /// used instead and `MapLoadingError` event will be emitted.
    ///
    /// @param layerId A style layer identifier.
    /// @param layerHost The `custom layer host`.
    /// @param layerPosition If not empty, the new layer will be positioned according to `layer position` parameters.
    ///
    /// @return A string describing an error if the operation was not successful, or empty otherwise.
    void addPersistentStyleCustomLayer(String layerId, CustomLayerHost layerHost, LayerPosition? layerPosition);
*/

  /// Checks if a style layer is persistent.
  ///
  /// @param layerId A style layer identifier.
  /// @return A string describing an error if the operation was not successful, boolean representing state otherwise.
  @async
  bool isStyleLayerPersistent(String layerId);

  /// Removes an existing style layer.
  ///
  /// @param layerId An identifier of the style layer to remove.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  @async
  void removeStyleLayer(String layerId);

  /// Moves an existing style layer
  ///
  /// @param layerId Identifier of the style layer to move.
  /// @param layerPosition The layer will be positioned according to the LayerPosition parameters. If an empty LayerPosition
  ///                      is provided then the layer is moved to the top of the layerstack.
  ///
  /// @return A string describing an error if the operation was not successful, or empty otherwise.
  @async
  void moveStyleLayer(String layerId, LayerPosition? layerPosition);

  /// Checks whether a given style layer exists.
  ///
  /// @param layerId Style layer identifier.
  ///
  /// @return A `true` value if the given style layer exists, `false` otherwise.
  @async
  bool styleLayerExists(String layerId);

  /// Returns the existing style layers.
  ///
  /// @return The list containing the information about existing style layer objects.
  @async
  List<StyleObjectInfo?> getStyleLayers();

  /// Gets the value of style layer property.
  ///
  /// @param layerId A style layer identifier.
  /// @param property The style layer property name.
  /// @return The `style property value`.
  @async
  StylePropertyValue getStyleLayerProperty(String layerId, String property);

  /// Sets a value to a style layer property.
  ///
  /// @param layerId A style layer identifier.
  /// @param property The style layer property name.
  /// @param value The style layer property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleLayerProperty(String layerId, String property, Object value);

  /// Gets style layer properties.
  ///
  /// @return The style layer properties or a string describing an error if the operation was not successful.
  @async
  String getStyleLayerProperties(String layerId);

  /// Sets style layer properties.
  /// This method can be used to perform batch update for a style layer properties. The structure of a
  /// provided `properties` value must conform to a format for a corresponding [layer type](https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/).
  /// Modification of a layer [id](https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#id) and/or a [layer type] (https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#type) is not allowed.
  ///
  /// @param layerId A style layer identifier.
  /// @param properties A map of style layer properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleLayerProperties(String layerId, String properties);

  /// Adds a new [style source](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources).
  ///
  /// @param sourceId An identifier for the style source.
  /// @param properties A map of style source properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void addStyleSource(String sourceId, String properties);

  /// Gets the value of style source property.
  ///
  /// @param sourceId A style source identifier.
  /// @param property The style source property name.
  /// @return The value of a `property` in the source with a `sourceId`.
  @async
  StylePropertyValue getStyleSourceProperty(String sourceId, String property);

  /// Sets a value to a style source property.
  /// Note: When setting the `data` property of a `geojson` source, this method never returns an error.
  /// In case of success, a `map-loaded` event will be propagated. In case of errors, a `map-loading-error` event will be propagated instead.
  ///
  ///
  /// @param sourceId A style source identifier.
  /// @param property The style source property name.
  /// @param value The style source property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleSourceProperty(String sourceId, String property, Object value);

  /// Gets style source properties.
  ///
  /// @param sourceId A style source identifier.
  ///
  /// @return The style source properties or a string describing an error if the operation was not successful.
  @async
  String getStyleSourceProperties(String sourceId);

  /// Sets style source properties.
  ///
  /// This method can be used to perform batch update for a style source properties. The structure of a
  /// provided `properties` value must conform to a format for a corresponding [source type](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/).
  /// Modification of a source [type](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#type) is not allowed.
  ///
  /// @param sourceId A style source identifier.
  /// @param properties A map of Style source properties.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleSourceProperties(String sourceId, String properties);

  /// Updates the image of an [image style source](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image).
  ///
  /// @param sourceId A style source identifier.
  /// @param image An `image`.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void updateStyleImageSourceImage(String sourceId, MbxImage image);

  /// Removes an existing style source.
  ///
  /// @param sourceId An identifier of the style source to remove.
  @async
  void removeStyleSource(String sourceId);

  /// Checks whether a given style source exists.
  ///
  /// @param sourceId A style source identifier.
  ///
  /// @return `true` if the given source exists, `false` otherwise.
  @async
  bool styleSourceExists(String sourceId);

  /// Returns the existing style sources.
  ///
  /// @return The list containing the information about existing style source objects.
  @async
  List<StyleObjectInfo?> getStyleSources();

  /// Sets the style global [light](https://docs.mapbox.com/mapbox-gl-js/style-spec/#light) properties.
  ///
  /// @param properties A map of style light properties values, with their names as a key.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleLight(String properties);

  /// Gets the value of a style light property.
  ///
  /// @param property The style light property name.
  /// @return The style light property value.
  @async
  StylePropertyValue getStyleLightProperty(String property);

  /// Sets a value to the the style light property.
  ///
  /// @param property The style light property name.
  /// @param value The style light property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleLightProperty(String property, Object value);

  /// Sets the style global [terrain](https://docs.mapbox.com/mapbox-gl-js/style-spec/#terrain) properties.
  ///
  /// @param properties A map of style terrain properties values, with their names as a key.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleTerrain(String properties);

  /// Gets the value of a style terrain property.
  ///
  /// @param property The style terrain property name.
  /// @return The style terrain property value.
  @async
  StylePropertyValue getStyleTerrainProperty(String property);

  /// Sets a value to the the style terrain property.
  ///
  /// @param property The style terrain property name.
  /// @param value The style terrain property value.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void setStyleTerrainProperty(String property, Object value);

  /// Get an `image` from the style.
  ///
  /// @param imageId The identifier of the `image`.
  ///
  /// @return The `image` for the given `imageId`, or empty if no image is associated with the `imageId`.
  @async
  MbxImage? getStyleImage(String imageId);

  /// Adds an image to be used in the style. This API can also be used for updating
  /// an image. If the image for a given `imageId` was already added, it gets replaced by the new image.
  ///
  /// The image can be used in [`icon-image`](https://www.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-icon-image),
  /// [`fill-pattern`](https://www.mapbox.com/mapbox-gl-js/style-spec/#paint-fill-fill-pattern),
  /// [`line-pattern`](https://www.mapbox.com/mapbox-gl-js/style-spec/#paint-line-line-pattern) and
  /// [`text-field`](https://www.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-text-field) properties.
  ///
  /// @param imageId An identifier of the image.
  /// @param scale A scale factor for the image.
  /// @param image A pixel data of the image.
  /// @param sdf An option to treat whether image is SDF(signed distance field) or not.
  /// @param stretchX An array of two-element arrays, consisting of two numbers that represent
  /// the from position and the to position of areas that can be stretched horizontally.
  /// @param stretchY An array of two-element arrays, consisting of two numbers that represent
  /// the from position and the to position of areas that can be stretched vertically.
  /// @param content An array of four numbers, with the first two specifying the left, top
  /// corner, and the last two specifying the right, bottom corner. If present, and if the
  /// icon uses icon-text-fit, the symbol's text will be fit inside the content box.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void addStyleImage(
      String imageId,
      double scale,
      MbxImage image,
      bool sdf,
      List<ImageStretches?> stretchX,
      List<ImageStretches?> stretchY,
      ImageContent? content);

  /// Removes an image from the style.
  ///
  /// @param imageId The identifier of the image to remove.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void removeStyleImage(String imageId);

  /// Checks whether an image exists.
  ///
  /// @param imageId The identifier of the image.
  ///
  /// @return True if image exists, false otherwise.
  @async
  bool hasStyleImage(String imageId);

/*
    /// Adds a custom geometry to be used in the style. To add the data, implement the fetchTileFunction callback in the options and call setStyleCustomGeometrySourceTileData()
    ///
    /// @param sourceId A style source identifier
    /// @param options The `custom geometry source options` for the custom geometry.
    void addStyleCustomGeometrySource(String sourceId, CustomGeometrySourceOptions options);
*/

  /// Set tile data of a custom geometry.
  ///
  /// @param sourceId A style source identifier.
  /// @param tileId A `canonical tile id` of the tile.
  /// @param featureCollection An array with the features to add.
  // @async
  // void setStyleCustomGeometrySourceTileData(String sourceId, CanonicalTileID tileId, String featureCollection);

  /// Invalidate tile for provided custom geometry source.
  ///
  /// @param sourceId A style source identifier,.
  /// @param tileId A `canonical tile id` of the tile.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void invalidateStyleCustomGeometrySourceTile(
      String sourceId, CanonicalTileID tileId);

  /// Invalidate region for provided custom geometry source.
  ///
  /// @param sourceId A style source identifier
  /// @param bounds A `coordinate bounds` object.
  ///
  /// @return A string describing an error if the operation was not successful, empty otherwise.
  @async
  void invalidateStyleCustomGeometrySourceRegion(
      String sourceId, CoordinateBounds bounds);

  /// Check if the style is completely loaded.
  ///
  /// Note: The style specified sprite would be marked as loaded even with sprite loading error (An error will be emitted via `MapLoadingError`).
  /// Sprite loading error is not fatal and we don't want it to block the map rendering, thus the function will still return `true` if style and sources are fully loaded.
  ///
  /// @return `true` iff the style JSON contents, the style specified sprite and sources are all loaded, otherwise returns `false`.
  ///
  @async
  bool isStyleLoaded();

  /// Function to get the projection provided by the Style Extension.
  ///
  /// @return Projection that is currently applied to the map
  @async
  String getProjection();

  /// Function to set the projection provided by the Style Extension.
  ///
  /// @param projection The projection to be set.
  @async
  void setProjection(String projection);
}

/// 3 component vector.
class Vec3 {
  /// The x component of the vector.
  double x;

  /// The y component of the vector.
  double y;

  /// The z component of the vector.
  double z;
}

/// 4 component vector.
class Vec4 {
  /// The x component of the vector.
  double x;

  /// The y component of the vector.
  double y;

  /// The z component of the vector.
  double z;

  /// The w component of the vector.
  double w;
}

/// Read-only data that is needed to correctly position the single view annotation on screen.
/// Used inside ViewAnnotationPositionsUpdateListener callback to notify the listener about the visible view annotations' position updates.
///
class ViewAnnotationPositionDescriptor {
  /// Unique id in order to lookup an actual view in platform SDKs.
  String identifier;

  /// View annotation width in `platform pixels` for drawing the annotation.
  int width;

  /// View annotation height in `platform pixels` for drawing the annotation.
  int height;

  /// Left-top screen coordinate in `platform pixels` for view annotation.
  ScreenCoordinate leftTopCoordinate;
}

/// Allows to cancel the associated asynchronous operation
///
/// The the associated asynchronous operation is not automatically canceled if this
/// object goes out of scope.
@HostApi()
abstract class Cancelable {
  /// Cancels the associated asynchronous operation
  ///
  /// If the associated asynchronous operation has already finished, this call is ignored.
  void cancel();
}

/*
@HostApi()
abstract class ValueConverter {
    /// Converts JSON string to a value.
    ///
    /// @param json The string to be converted.
    ///
    /// @return expected The value or string describing an error.
    String fromJson(String json);

    /// Converts value to a JSON string.
    /// The method is intended to be used when `machine-readable` string is needed.
    ///
    /// @param value The value to be converted.
    ///
    /// @return string The value converted to a JSON string.
    String toJson(String value);

    /// Converts value to a `human-readable` JSON string.
    /// Space (0x20) character is used for indentation.
    ///
    /// @param value The value to be converted.
    /// @param indent The indentation level for converted JSON.
    ///
    /// @return string The value converted to a JSON string.
    String toJson2(String value, int indent);

}
*/

/// HTTP defines a set of request methods to indicate the desired action to be performed for a given resource.
enum HttpMethod {
  /// The GET method requests a representation of the specified resource. Requests using GET should only retrieve data.
  GET,

  /// The HEAD method asks for a response identical to that of a GET request, but without the response body.
  HEAD,

  /// The POST method sends data (stored in the request body) to a server to create or update a given resource.
  POST,
}

/// Classify network types based on cost.
enum NetworkRestriction {
  /// Allow access to all network types.
  NONE,

  /// Forbid network access to expensive networks, such as cellular.
  DISALLOW_EXPENSIVE,

  /// Forbid access to all network types.
  DISALLOW_ALL,
}

/// Enum which describes possible error types which could happen during HTTP request/download calls.
enum HttpRequestErrorType {
  /// Establishing connection related error.
  CONNECTION_ERROR,

  /// SSL related error.
  SSLERROR,

  /// Request was cancelled by the user.
  REQUEST_CANCELLED,

  /// Timeout error.
  REQUEST_TIMED_OUT,

  /// Range request failed.
  RANGE_ERROR,

  /// Other than above error.
  OTHER_ERROR,
}

/// Enum which represents different error cases which could happen during download session.
enum DownloadErrorCode {
  /// General filesystem related error code. For cases like: write error, no such file or directory, not enough space and etc.
  FILE_SYSTEM_ERROR,

  /// General network related error. Should be probably representation of HttpRequestError.
  NETWORK_ERROR,
}

/// Enum representing state of download session.
enum DownloadState {
  /// Download session initiated but not started yet.
  PENDING,

  /// Download session is in progress.
  DOWNLOADING,

  /// Download session failed.
  FAILED,

  /// Download session successfully finished.
  FINISHED,
}

/// UAComponents holds Application and SDK information for generating User-Agent string.
///
/// The UA string itself is broken down into four components:
/// 1. Application Name and version - appName/appVersion.
/// 2. Application Identifier and OS Information - (appIdentifier; appBuildNumber; osName osVersion). This will be skipped from UA string, if any one of the field is empty or unknown.
/// 3. SDK Name and Version - sdkName/sdkVersion.
/// 4. SDK Identifier - (sdkIdentifier; sdkBuildNumber). This will be skipped from UA string, if any one of the field is empty or unknown.
///
/// User Agent String Example: AppName/1.0 (app.bundle.identifier; v1; iOS 13.0.1) MapboxFramework/1.0 (framework.bundle.identifier; v1) Mapbox Common Library/v1.0.0
///
/// Note that if the User-Agent is already part of the HTTP request headers, we skip the generation using the information provided through the UserAgentComponents.
class UAComponents {
  /// Application Name (e.g. kCFBundleNameKey on Darwin)
  String appNameComponent;

  /// Application Version (e.g. may be simple version 1.0)
  String appVersionComponent;

  /// Application Identifier (e.g. bundle identifier on Darwin, package name of Android)
  String appIdentifierComponent;

  /// Application Build Number (e.g. kCFBundleVersionKey on Darwin)
  String appBuildNumberComponent;

  /// OS Name (e.g. iOS or Android)
  String osNameComponent;

  /// OS Version (e.g 13.1.0)
  String osVersionComponent;

  /// SDK/Framework Name (e.g. Maps)
  String sdkNameComponent;

  /// SDK/Framework Version (e.g v1.0.0)
  String sdkVersionComponent;

  /// SDK/Framework Identifier
  String sdkIdentifierComponent;

  /// SDK/Framework Build Number
  String sdkBuildNumberComponent;
}

/// HttpRequest holds basic information for construction of an HTTP request
class HttpRequest {
  /// HTTP defines a set of request methods to indicate the desired action to be performed for a given resource.
  /// Specify desired method using this parameter.
  HttpMethod method;

  /// URL the request should be sent to
  String url;

  /// HTTP headers to include
  Map<String?, String?> headers;

  /// Keep compression flag. If set to true, responses will not be automatically decompressed.
  /// Default is false.
  bool keepCompression;

  /// Timeout defines how long, in seconds, the request is allowed to take in total (including connecting to the host).
  /// Default is 0, meaning no timeout.
  int timeout;

  /// Restrict the request to the specified network types. If none of the specified network types is available, the
  /// download fails with a connection error.
  ///
  /// Default is allowed to all network types
  NetworkRestriction networkRestriction;

  /// Application and SDK information for generating a User-Agent string.
  UAComponents uaComponents;

  /// HTTP Body data transmitted in an HTTP transaction message immediatelly following the headers if there is any.
  /// Body data is used by POST HTTP methods.
  Uint8List? body;
}

/// Record which contains detailed information about HTTP error happened during request/download call.
class HttpRequestError {
  /// Error type.
  HttpRequestErrorType type;

  /// Detailed description of the error.
  String message;
}

/// Record which contains data received in HTTP response.
class HttpResponseData {
  /// Map which contains HTTP response headers in a format header name:value. All the header names are in lower case format.
  Map<String?, String?> headers;

  /// HTTP response code.
  int code;

  /// Data chunk received in HTTP response.
  Uint8List data;
}

/// Record which is used to report HTTP response to the caller.
class HttpResponse {
  /// HTTP request data which was use to send HTTP request.
  HttpRequest request;

  /// Result of HTTP request call.
  HttpResponseData result;
}

/// Structure to configure download session.
class DownloadOptions {
  /// Structure which contains parameters to use for sending HTTP request.
  /// Http method will be ignored from this request.
  HttpRequest request;

  /// Absolute path where to store downloaded file. If a file with the specified name already exists and resume is set to
  /// false, the existing file is overwritten.
  String localPath;

  /// If localPath points to an existing file on disk, resume the download starting from an offset equal to file size.
  bool resume;
}

/// Structure to hold error information about download request.
class DownloadError {
  /// Download error code.
  DownloadErrorCode code;

  /// Human readable string describing an error.
  String message;
}

/// Structure to hold current status information about ongoing download session.
class DownloadStatus {
  /// Download id which was created by download request.
  int downloadId;

  /// State of download request.
  DownloadState state;

  /// The optional which contains error information in case of failure when state is set to DownloadState::Failed.
  DownloadError? error;

  /// Total amount of bytes to receive. In some cases this value is unknown until we get final part of the file.
  int? totalBytes;

  /// Amount of bytes already received and saved on the disk. Includes previous download attempts for a resumed
  /// download.
  int receivedBytes;

  /// Amount of bytes received during the current resume attempt. For downloads that weren't resumed,
  /// this value will be the same as receivedBytes.
  int transferredBytes;

  /// Download options used to send the download request.
  DownloadOptions downloadOptions;

  /// HTTP result. This field is only set for DownloadState::Failed and DownloadState::Finished.
  /// For DownloadState::Failed expect HttpRequestError to be provided for cases when DownloadErrorCode is
  /// NetworkError.
  /// And for DownloadState::Finished HttpResponseData is set, but with empty data field (since all the data was written to the disk).
  HttpResponseData? httpResult;
}

/*
/// HTTP service factory.
///
/// This class is used to get a pointer/reference to HTTP service platform implementation.
/// In order to set a custom implementation, the client must call `setUserDefined()` method once before any actual HTTP service is required.
@HostApi()
abstract class HttpServiceFactory {
    /// Replaces the implementation of the HTTP service with a custom one.
    ///
    /// If a default implementation has been created or previous a user defined implementation has been set already,
    /// it will be replaced. The factory maintains a strong reference to the provided implementation
    /// which can be released with the reset() method.
    void setUserDefined(HttpServiceInterface custom);

    /// Releases the implementation of the HTTP service.
    ///
    /// The strong reference from the factory to a custom HTTP service implementation will be released. This can be
    /// used to release the HTTP service implementation once it is no longer needed. It may otherwise be kept until
    /// the end of the program.
    void reset();

    /// Returns an instance of the HTTP service.
    ///
    /// If a user defined implementation has been set with setUserDefined(), it will be returned.
    /// Otherwise, a default implementation is allocated on the first call of after a call to reset().
    /// The default implementation is kept until a call to reset() or setUserDefined() releases it.
    HttpServiceInterface getInstance();

}
*/

/// Instance that allows connecting or disconnecting the Mapbox stack to the network.
@HostApi()
abstract class OfflineSwitch {
  /// Connects or disconnects the Mapbox stack. If set to false, current and new HTTP requests will fail
  /// with HttpRequestErrorType#ConnectionError.
  ///
  /// @param connected Set false to disconnect the Mapbox stack
  void setMapboxStackConnected(bool connected);

  /// Provides information if the Mapbox stack is connected or disconnected via OfflineSwitch.
  ///
  /// @return True if the Mapbox stack is disconnected via setMapboxStackConnected(), false otherwise.
  bool isMapboxStackConnected();

/*
    /// Returns the OfflineSwitch singleton instance.
    OfflineSwitch getInstance();
*/

  /// Releases the OfflineSwitch singleton instance.
  ///
  /// Users can call this method if they want to do manual cleanup of the resources allocated by Mapbox services.
  /// If the user calls getInstance() after reset, a new instance of the OfflineSwitch singleton will be allocated.
  void reset();
}

/*
/// TileStore manages downloads and storage for requests to tile-related API endpoints, enforcing a disk usage
/// quota: tiles available on disk may be deleted to make room for a new download. This interface can be used by an
/// app developer to set the disk quota. The rest of TileStore API is intended for native SDK consumption only.
@HostApi()
abstract class TileStore {
    /// Creates a TileStore instance for the given storage path.
    ///
    /// The returned instance exists as long as it is retained by the client.
    /// If the tile store instance already exists for the given path this method will return it without creating
    /// a new instance, thus making sure that there is only one tile store instance for a path at a time.
    ///
    /// If the given path is empty, the tile store at the default location is returned.
    /// On iOS, this storage path is excluded from automatic cloud backup.
    /// On Android, please exclude the storage path in your Manifest.
    /// Please refer to the [Android Documentation](https://developer.android.com/guide/topics/data/autobackup.html#IncludingFiles) for detailed information.
    ///
    /// @param  path The path on disk where tiles and metadata will be stored
    /// @return Returns a TileStore instance.
    TileStore create(String path);

    /// Creates a TileStore instance at the default location.
    ///
    /// If the tile store instance already exists for the default location this method will return it without creating
    /// a new instance, thus making sure that there is only one tile store instance for a path at a time.
    ///
    /// @return Returns a TileStore instance.
    TileStore create2();

    /// Adds a new observer to the TileStore instance.
    ///
    /// Note that observers will be notified of changes until they're explicitly removed again.
    ///
    /// @param observer The observer to be added.
    void addObserver(TileStoreObserver observer);

    /// Removes an existing observer from the TileStore instance.
    ///
    /// If the observer isn't attached to the TileStore anymore, this is a no-op.
    ///
    /// @param observer The observer to be removed.
    void removeObserver(TileStoreObserver observer);

    /// Loads a new tile region or updates the existing one.
    ///
    /// Creating of a new region requires providing both geometry and tileset
    /// descriptors to the given load options, otherwise the load request fails
    /// with RegionNotFound error.
    ///
    /// If a tile region with the given id already exists, it gets updated with
    /// the values provided to the given load options. The missing resources get
    /// loaded and the expired resources get updated.
    ///
    /// If there no values provided to the given load options, the existing tile region
    /// gets refreshed: the missing resources get loaded and the expired resources get updated.
    ///
    /// A failed load request can be reattempted with another loadTileRegion() call.
    ///
    /// If there is already a pending loading operation for the tile region with the given id
    /// the pending loading operation will fail with an error of Canceled type.
    ///
    /// Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param id The tile region identifier.
    /// @param loadOptions The tile region load options.
    /// @param onProgress Invoked multiple times to report progess of the loading operation.
    /// @param onFinished Invoked only once upon success, failure, or cancelation of the loading operation.
    /// @return Returns a Cancelable object to cancel the load request
    Cancelable loadTileRegion(String id, TileRegionLoadOptions loadOptions, TileRegionLoadProgressCallback onProgress, TileRegionCallback onFinished);

    /// An overloaded version that does not report progess of the loading operation.
    ///
    /// @param id The tile region identifier.
    /// @param loadOptions The tile region load options.
    /// @param onFinished Invoked only once upon success, failure, or cancelation of the loading operation.
    /// @return Returns a Cancelable object to cancel the load request
    Cancelable loadTileRegion2(String id, TileRegionLoadOptions loadOptions, TileRegionCallback onFinished);

    /// An overloaded version that does not report progess or finished status of the loading operation.
    ///
    /// @param id The tile region identifier.
    /// @param loadOptions The tile region load options.
    /// @return Returns a Cancelable object to cancel the load request
    Cancelable loadTileRegion3(String id, TileRegionLoadOptions loadOptions);

    /// Checks if a tile region with the given id contains all tilesets from all of the given tileset descriptors.
    ///
    /// Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param id The tile region identifier.
    /// @param descriptors The list of tileset descriptors.
    /// @param callback The result callback.
    @async
    undefined tileRegionContainsDescriptors(String id, List<TilesetDescriptor?> descriptors);

    /// Returns a list of the existing tile regions.
    ///
    /// Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param callback The result callback.
    @async
    undefined getAllTileRegions();

    /// Returns a tile region by its id.
    ///
    /// Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param id The tile region id.
    /// @param callback The result callback.
    @async
    undefined getTileRegion(String id);

    /// Returns a tile region's associated geometry
    ///
    /// The region associated geometry is provided by the client and it represents the area, which the tile
    /// region must cover. The actual regional geometry depends on the tiling scheme and might exceed the
    /// associated geometry.
    ///
    /// Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
    /// it is the responsibility of the user to dispatch to a user-controlled thread.
    ///
    /// @param id The tile region id.
    /// @param callback The result callback.
    @async
    undefined getTileRegionGeometry(String id);

    /// Returns a tile region's associated metadata
    ///
    /// The region's associated metadata that a user previously set for this region.
    ///
    /// @param id The tile region id.
    /// @param callback The result callback.
    @async
    undefined getTileRegionMetadata(String id);

    /// Removes a tile region.
    ///
    /// Removes a tile region from the existing packages list. The actual resources
    /// eviction might be deferred. All pending loading operations for the tile region
    /// with the given id will fail with Canceled error.
    ///
    /// @param id The tile region identifier.
    void removeTileRegion(String id);

    /// An overloaded version with a callback for feedback.
    /// On successful tile region removal, the given callback is invoked with the removed tile region. Otherwise, the given callback is invoked with an error.
    ///
    /// @param id The tile region identifier.
    /// @param callback A callback to be invoked when a tile region was removed.
    @async
    undefined removeTileRegion2(String id);

    /// Sets additional options for this instance.
    ///
    /// @param key The configuration option that should be changed. Valid keys are listed in \c TileStoreOptions.
    /// @param value The value for the configuration option, or null if it should be reset.
    void setOption(String key, String value);

    /// Sets additional options for this instance that are specific to a data type.
    ///
    /// @param key The configuration option that should be changed. Valid keys are listed in \c TileStoreOptions.
    /// @param domain The data type this setting should be applied for.
    /// @param value The value for the configuration option, or null if it should be reset.
    void setOption2(String key, TileDataDomain domain, String value);

    /// Computes a polygon of the area covered by the tiles cached in TileStore with the specified TilesetDescriptors.
    /// @param descriptors The list of tileset descriptors.
    /// @param callback A callback that will be invoked with the resulting polygon.
    @async
    undefined computeCoveredArea(List<TilesetDescriptor?> descriptors);

}
*/

/// Describes the tiles data domain.
enum TileDataDomain {
  /// Data for Maps.
  MAPS,

  /// Data for Navigation.
  NAVIGATION,

  /// Data for Search.
  SEARCH,

  /// Data for ADAS
  ADAS,
}

/// Describes the reason for a tile region download request failure.
enum TileRegionErrorType {
  /// The operation was canceled.
  CANCELED,

  /// tile region does not exist.
  DOES_NOT_EXIST,

  /// Tileset descriptors resolving failed.
  TILESET_DESCRIPTOR,

  /// There is no available space to store the resources
  DISK_FULL,

  /// Other reason.
  OTHER,

  /// The region contains more tiles than allowed.
  TILE_COUNT_EXCEEDED,
}

/// TileRegion represents an identifiable geographic tile region with metadata
class TileRegion {
  /// The id of the tile region
  String id;

  /// The number of resources that are known to be required for this tile region.
  int requiredResourceCount;

  /// The number of resources that have been fully downloaded and are ready for
  /// offline access.
  ///
  /// The tile region is complete if `completedResourceCount` is equal to `requiredResourceCount`.
  int completedResourceCount;

  /// The cumulative size, in bytes, of all resources (inclusive of tiles) that have
  /// been fully downloaded.
  int completedResourceSize;

  /// The earliest point in time when any of the region resources gets expired.
  ///
  /// Unitialized for incomplete tile regions or for complete tile regions with all immutable resources.
  int? expires;
}

/// A tile region's load progress includes counts
/// of the number of resources that have completed downloading
/// and the total number of resources that are required.
class TileRegionLoadProgress {
  /// The number of resources that are ready for offline access.
  int completedResourceCount;

  /// The cumulative size, in bytes, of all resources (inclusive of tiles) that
  /// are ready for offline access.
  int completedResourceSize;

  /// The number of resources that have failed to download due to an error.
  int erroredResourceCount;

  /// The number of resources that are known to be required for this tile region.
  int requiredResourceCount;

  /// The number of resources that are ready for offline use and that (at least partially)
  /// have been downloaded from the network.
  int loadedResourceCount;

  /// The cumulative size, in bytes, of all resources (inclusive of tiles) that have
  /// been downloaded from the network.
  int loadedResourceSize;
}

/// Describes a tile region load request error.
class TileRegionError {
  /// The reason for the response error.
  TileRegionErrorType type;

  /// An error message
  String message;
}

/// Describes the tile region load option values.
class TileRegionLoadOptions {
  /// The tile region's associated geometry.
  ///
  /// If provided, updates the tile region's associated geometry i.e. geometry,
  /// which is used in the tile cover algorithm to find out a set of tiles to be loaded
  /// for the tile region.
  ///
  /// Providing an empty geometry list is equivalent to removeTileRegion() call.
  Map<String?, Object?>? geometry;

  /// The tile region's tileset descriptors.
  ///
  /// If provided, updates the tile region's tileset descriptors that define
  /// the tilesets and zoom ranges of the tiles for the tile region.
  ///
  /// Providing an empty tileset descriptors list is equivalent to removeTileRegion() call.
  List<TilesetDescriptor?>? descriptors;

  /// A custom Mapbox Value associated with this tile region for storing metadata.
  ///
  /// If provided, the custom value value will be stored alongside the tile region. Previous values will
  /// be replaced with the new value.
  ///
  /// Developers can use this field to store custom metadata associated with a tile region. This value
  /// can be retrieved with getTileRegionMetadata().
  String? metadata;

  /// Accepts expired data when loading tiles.
  ///
  /// This flag should be set to true to accept expired responses. When a tile is already loaded but expired, no
  /// attempt will be made to refresh the data. This may lead to outdated data. Set to false to ensure that data
  /// for a tile is up-to-date. Set to true to continue loading a group without updating expired data for tiles that
  /// are already downloaded.
  bool acceptExpired;

  /// Controls which networks may be used to load the tile.
  ///
  /// By default, all networks are allowed. However, in some situations, it's useful to limit the kind of networks
  /// that are allowed, e.g. to ensure that data is only transferred over a connection that doesn't incur cost to
  /// the user, like a WiFi connection, and prohibit data transfer over expensive connections like cellular.
  NetworkRestriction networkRestriction;

  /// Starts loading the tile region at the given location and then proceeds to tiles that are further away
  /// from it.
  ///
  /// Note that this functionality is not currently implemented.
  Map<String?, Object?>? startLocation;

  /// Limits the download speed of the tile region.
  ///
  /// Note that this is not a strict bandwidth limit, but only limits the average download speed. tile regions may
  /// be temporarily downloaded with higher speed, then pause downloading until the rolling average has dropped below
  /// this value.
  ///
  /// If unspecified, the download speed will not be restricted.
  ///
  /// Note that this functionality is not currently implemented.
  int? averageBytesPerSecond;

  /// Extra tile region load options.
  ///
  /// If provided, contains an object value with extra tile region load options.
  ///
  /// There are currently no extra options.
  String? extraOptions;
}

/// A bundle that encapsulates tilesets creation for the tile store implementation.
///
/// Tileset descriptors describe the type of data that should be part of the Offline Region, like the routing profile for Navigation and the Tilesets of the Map style.
@HostApi()
abstract class TilesetDescriptor {}