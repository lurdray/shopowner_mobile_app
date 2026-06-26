# Publishing / updating ShopOwner on Google Play

Google Play needs a **release-signed `.aab`** (App Bundle), not the debug APK.
The `Build AAB (Play Store)` GitHub Action produces one. App id: `com.shopowner.mobileapp`.

---

## One-time setup: the upload keystore

> ⚠️ The upload key is permanent. If the app is **already on Play**, reuse the
> **existing** keystore — a new one will be rejected for updates. Only create a
> new keystore for a brand-new app. Back it up somewhere safe; losing it means
> you can't update the app again.

1. Create the keystore (on any machine with the JDK / Android Studio):
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   Remember the **store password**, **key password**, and alias (`upload`).

2. Base64-encode it for GitHub:
   ```bash
   base64 -i upload-keystore.jks | pbcopy     # macOS (copies to clipboard)
   # or: base64 upload-keystore.jks > keystore.b64.txt
   ```

3. Add these **repository secrets** (GitHub → repo → Settings → Secrets and
   variables → Actions → New repository secret):
   | Secret | Value |
   |--------|-------|
   | `ANDROID_KEYSTORE_BASE64`   | the base64 string from step 2 |
   | `ANDROID_KEYSTORE_PASSWORD` | store password |
   | `ANDROID_KEY_PASSWORD`      | key password |
   | `ANDROID_KEY_ALIAS`         | `upload` |

---

## Build the .aab

GitHub → **Actions** → **Build AAB (Play Store)** → **Run workflow**, and enter:
- **version_name** — e.g. `1.0.0` (the human version users see)
- **build_number** — the **versionCode**; must be **higher than the last one on Play**

When it finishes, download the `.aab` from the run's **Releases** entry
(`aab-<version>-<code>`) or the **ShopOwner-AAB** artifact.

---

## First-time publishing

1. Play Console → **Create app** (name, language, app/free, declarations).
2. Complete **App setup**: privacy policy URL, data safety form, content rating,
   target audience, ads declaration, etc. (the dashboard checklist).
3. **Release → Testing → Internal testing** (recommended first) → **Create release**.
4. Keep **Play App Signing** enabled (Google holds the app signing key; you sign
   uploads with your upload key — exactly what this setup does).
5. **Upload** the `.aab`, add release notes, **Review**, then **Roll out**.
6. Promote Internal → Closed/Open testing → **Production** when ready.

---

## Updating an already-published app

1. Increase **build_number** (versionCode) above the currently live one.
2. Run the **Build AAB** workflow (same signing secrets) and download the `.aab`.
3. Play Console → your app → **Production** (or a testing track) → **Create new
   release** → **Upload** the new `.aab`.
4. Add **release notes**, **Review release**, then **Roll out** (optionally a
   staged % rollout).
5. The update goes live after Google's review.

> versionCode must strictly increase every upload; versionName is just the label.
