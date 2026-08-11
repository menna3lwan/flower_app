# assets/images

Product photography, marketing/hero imagery, and other raster images
exported from the Figma design.

None are checked in yet — the UI skeleton renders
`common/widgets/media/app_image_placeholder.dart` in every image slot
instead (see that file's doc comment). Drop exported PNG/JPG/WebP files
here and register each one in `lib/core/constants/app_assets.dart`;
never reference a path string directly from a widget.
