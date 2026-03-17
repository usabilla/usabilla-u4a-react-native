# Platform-Specific Assets

This folder contains native platform assets that are copied to iOS and Android projects during the build process.

## Structure

```
platform-assets/
├── README.md                        # This file
├── ios/
│   ├── Images.xcassets/
│   │   ├── AppIcon.appiconset/          # App icons (all sizes)
│   │   ├── LaunchImage.imageset/        # Launch/splash screen
│   │   ├── emoticon_*.imageset/         # Standard emoticons
│   │   └── cat_*.imageset/              # Custom cat emoticons
│   ├── LaunchScreen.storyboard          # iOS launch screen UI
│   └── Info.plist                       # App config (fonts, display name, etc.)
│
└── android/
    ├── drawable/                         # Emoticons and images (mdpi)
    │   ├── emoticon_hate.png
    │   ├── emoticon_love.png
    │   ├── emoticon_neutral.png
    │   ├── emoticon_sad.png
    │   ├── emoticon_smile.png
    │   ├── cat_hate.png
    │   ├── cat_love.png
    │   ├── cat_neutral.png
    │   ├── cat_sad.png
    │   ├── cat_smile.png
    │   ├── background.png
    │   ├── footer.png
    │   └── splash_screen.xml             # Splash screen layer definition
    │
    ├── mipmap-{density}/                 # App icons per density
    │   ├── ic_launcher.png               # App icon
    │   ├── ic_launcher_round.png         # Round app icon
    │   └── splash_screen.png             # Splash screen image
    │
    └── values/                           # Android resource values
        ├── strings.xml                   # App name
        └── styles.xml                    # App theme (includes SplashTheme)
```

## Contents

### iOS Assets (50 files, ~2.0 MB)

**Images.xcassets/** (47 files)
- **AppIcon.appiconset** - 22 icon sizes
  - All required iOS app icon sizes from 20x20 to 1024x1024
  - Covers iPhone, iPad, App Store, all scales (@1x, @2x, @3x)
- **LaunchImage.imageset** - 3 images
  - Launch screen images at @1x, @2x, @3x scales
- **Emoticon Imagesets** - 10 custom images
  - `emoticon_hate`, `emoticon_love`, `emoticon_neutral`, `emoticon_sad`, `emoticon_smile`
  - `cat_hate`, `cat_love`, `cat_neutral`, `cat_sad`, `cat_smile`
  - Each includes Contents.json and image file

**LaunchScreen.storyboard** (1 file)
- iOS Interface Builder file defining launch screen UI
- References LaunchImage from Images.xcassets
- Configured for all device sizes with Auto Layout

**Info.plist** (1 file)
- App configuration including:
  - `UIAppFonts` - Custom font references (Inter fonts)
  - `CFBundleDisplayName` - App display name
  - `UISupportedInterfaceOrientations` - Portrait/landscape
  - `UIStatusBarStyle` - Status bar appearance
  - App capabilities and permissions

### Android Assets (30 files, ~200 KB)

**drawable/** (13 files)
- Emoticon and cat images (mdpi density)
- Background and footer images
- **splash_screen.xml** - Layer-list drawable defining splash layout

**mipmap-{density}/** (15 files across 5 folders)
- `mipmap-hdpi/` - High density (~160dpi)
- `mipmap-mdpi/` - Medium density (~120dpi)
- `mipmap-xhdpi/` - Extra-high density (~320dpi)
- `mipmap-xxhdpi/` - Extra-extra-high density (~480dpi)
- `mipmap-xxxhdpi/` - Extra-extra-extra-high density (~640dpi)
- Each contains: `ic_launcher.png`, `ic_launcher_round.png`, `splash_screen.png`

**values/** (2 files)
- **strings.xml** - App name resource string (`RNUsabilla`)
- **styles.xml** - App theme configurations:
  - `AppTheme` - Main application theme
  - `SplashTheme` - Splash screen theme (references @drawable/splash_screen)

## Usage

These assets are **automatically copied** to the generated iOS and Android projects by the `build-sample.sh` script.

### Automatic Copy Process

When you run `./.script/build-sample.sh`, the script:

1. **Generates native projects** (if missing)
   - Creates `ios/` and `android/` folders from React Native template

2. **Copies platform assets**
   - iOS Images.xcassets: `platform-assets/ios/Images.xcassets` → `ios/RNUsabilla/Images.xcassets`
   - iOS LaunchScreen: `platform-assets/ios/LaunchScreen.storyboard` → `ios/RNUsabilla/LaunchScreen.storyboard`
   - iOS Info.plist: `platform-assets/ios/Info.plist` → `ios/RNUsabilla/Info.plist`
   - Android drawable: `platform-assets/android/drawable/*` → `android/app/src/main/res/drawable/`
   - Android mipmaps: `platform-assets/android/mipmap-*/*` → `android/app/src/main/res/mipmap-*/`
   - Android values: `platform-assets/android/values/*` → `android/app/src/main/res/values/`

3. **Links fonts and other assets**
   - Links fonts from `assets/fonts/` using react-native-asset

### Manual Copy

If you need to manually copy these assets to an existing project:

```bash
# iOS
cp -R platform-assets/ios/Images.xcassets ios/RNUsabilla/
cp platform-assets/ios/LaunchScreen.storyboard ios/RNUsabilla/
cp platform-assets/ios/Info.plist ios/RNUsabilla/

# Android
cp -R platform-assets/android/drawable/* android/app/src/main/res/drawable/
cp -R platform-assets/android/mipmap-*/* android/app/src/main/res/mipmap-*/
cp platformassets/android/values/*.xml android/app/src/main/res/values/
```

## Customization

To customize app icons, launch screens, or emoticons:

1. **Replace the image files** in this folder
   - iOS: Edit/replace images in `Images.xcassets/*/` folders
   - Android: Replace files in `drawable/` and `mipmap-*/` folders

2. **Keep the same filenames** to avoid build issues

3. **Run build script** to regenerate projects with new assets
   ```bash
   ./.script/build-sample.sh -c  # Clean build with new assets
   ```

## Asset Guidelines

### iOS App Icons
- Provide all required sizes (see `AppIcon.appiconset/Contents.json`)
- PNG format, no transparency
- Square images (iOS applies corner radius automatically)

### Android App Icons
- Provide icons for all densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Launcher icons: 48x48dp (varies by density)
  - mdpi: 48x48px
  - hdpi: 72x72px
  - xhdpi: 96x96px
  - xxhdpi: 144x144px
  - xxxhdpi: 192x192px
- PNG format with transparency supported

### Launch/Splash Screens
- **iOS**: Edit `LaunchScreen.storyboard` and replace images in `LaunchImage.imageset`
- **Android**: Edit `splash_screen.xml` and replace `mipmap-*/splash_screen.png` images
- Keep consistent branding across platforms

### Emoticons
- **iOS**: Any size, @1x scale (iOS scales automatically)
- **Android**: Place in `drawable/` folder for mdpi density
- PNG format with transparency recommended

## Size Information

- **Total size**: ~2.1 MB
- **Total files**: 81 files (82 including this README)

**iOS assets**: ~2.0 MB (50 files)
- Images.xcassets: ~1.8 MB (47 files)
- LaunchScreen.storyboard: ~2.4 KB (1 file)
- Info.plist: ~2.0 KB (1 file)

**Android assets**: ~200 KB (30 files)
- drawable: ~180 KB (13 files)
- mipmap-*: ~15 KB (15 files across 5 folders)
- values: ~400 bytes (2 files)

## Version Control

✅ **This folder IS committed to git**

Unlike `ios/` and `android/` folders which are generated and excluded, `platform-assets/` contains the **source-of-truth** for platform-specific images and configuration files, and is versioned.

## Why Platform-Specific Assets?

Some assets must be in native project formats and cannot be handled by React Native's asset linking:

**iOS-specific:**
- App icons in Xcode's `.appiconset` format
- Launch screen storyboard files
- Info.plist configuration (fonts, permissions, display settings)

**Android-specific:**
- App icons in multiple density `mipmap-*` folders
- XML drawables for splash screens
- Resource values (strings, styles, themes)

These platform assets are kept separate from `assets/` folder (which contains React Native-managed assets like fonts and images used in the app code).

## Related Files

- **Main README**: `../README.MD` - Full sample app documentation
- **Build Script**: `../.script/build-sample.sh` - Automated build with asset copying
- **Clean Script**: `../.script/clean.sh` - Clean generated files and caches
- **App Assets**: `../assets/` - React Native assets (fonts, images)

---

💡 **Tip**: To see which custom fonts are registered, check the `UIAppFonts` array in `Info.plist`!

💡 **Tip**: Android splash screen theme is configured in `styles.xml` as `SplashTheme`!
