# Setup Notes (aapka laptop)

| Cheez | Value |
|---|---|
| Flutter | 3.47.6 stable, `C:\dev\flutter` |
| Dart | 3.13.5 (Flutter ke saath) |
| Project | `C:\dev\abhay_app` |
| Android SDK | `C:\Users\dell\AppData\Local\Android\Sdk` |
| Android Studio | Rabbit 1 / 2026.2.1 |
| Zip backups | `D:\ABAY all files\` |

## Roz ke commands
```powershell
cd C:\dev\abhay_app
flutter pub get
flutter analyze
flutter test
flutter run -d chrome        # quick UI check
flutter devices              # connected devices
```

## Agar `flutter` not recognized aaye
```powershell
$env:Path = "C:\dev\flutter\bin;" + [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
```
(naya terminal kholne par bhi na chale to PATH dobara set karo)

## Git workflow (har part ke baad)
```powershell
git add -A
git commit -m "Part N: kya kiya"
git tag phase-xxx
git push
git push --tags
```

## Important
- Flutter SDK aur project **OneDrive mein nahi** (sync issues).
- Test imports `package:abhay/...` use karte hain, isliye project name `abhay` hi rehna chahiye.
- `flutter doctor` mein Visual Studio red cross ignore karo (Windows desktop apps ke liye).
