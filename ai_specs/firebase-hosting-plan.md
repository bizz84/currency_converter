# Firebase Hosting Deployment Plan

## ✅ Initial Deployment Complete!

## Prerequisites
- [x] Flutter SDK installed and configured
- [x] Firebase CLI installed (`npm install -g firebase-tools` or check with `which firebase`)
- [x] Firebase account created at https://console.firebase.google.com
- [x] Flutter web support enabled (should be by default)

## Deployment Steps

### 1. Build Flutter Web Application
- [x] Run `flutter clean` to ensure clean build
- [x] Run `flutter build web --release` to create production build
- [x] Verify build output in `build/web/` directory

### 2. Initialize Firebase Project
- [x] Run `firebase login` to authenticate with Firebase
- [x] Run `firebase init` in project root
- [x] Select **Hosting** when prompted for Firebase features
- [x] Choose existing Firebase project or create new one:
  - [x] Select existing project OR
  - [x] Create new project with appropriate name
- [x] Configure hosting options:
  - [x] Set public directory: `build/web`
  - [x] Configure as single-page app: **Yes**
  - [x] Set up automatic builds and deploys with GitHub: **No** (for now)
  - [x] Overwrite `build/web/index.html`: **No**

### 3. Configure Firebase Hosting
- [x] Review generated `firebase.json` file
- [x] Add custom configurations if needed:
  ```json
  {
    "hosting": {
      "public": "build/web",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ],
      "rewrites": [
        {
          "source": "**",
          "destination": "/index.html"
        }
      ],
      "headers": [
        {
          "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|js|css|eot|otf|ttf|ttc|woff|woff2|font.css)",
          "headers": [
            {
              "key": "Cache-Control",
              "value": "max-age=604800"
            }
          ]
        }
      ]
    }
  }
  ```

### 4. Update .gitignore
- [x] Add Firebase-specific entries:
  ```
  # Firebase
  .firebase/
  .firebaserc
  firebase-debug.log
  firebase-debug.*.log
  ```

### 5. Deploy to Firebase
- [x] Run `firebase deploy --only hosting`
- [x] Note the hosting URL provided after deployment
- [x] Test the deployed app at:
  - [x] `https://[project-id].web.app`
  - [x] `https://[project-id].firebaseapp.com`

### 6. Verify Deployment
- [x] Open deployed URL in browser
- [x] Test currency conversion functionality
- [x] Test charts functionality
- [x] Verify responsive design on different screen sizes
- [x] Check browser console for errors

## Post-Deployment Tasks (Optional)

### Custom Domain Setup
- [ ] Purchase domain (if not already owned)
- [ ] Add custom domain in Firebase Hosting settings
- [ ] Configure DNS records as instructed by Firebase
- [ ] Verify domain ownership
- [ ] Wait for SSL certificate provisioning (automatic)

### Performance Optimization
- [ ] Enable Firebase Performance Monitoring
- [ ] Configure CDN settings if needed
- [ ] Review and optimize asset caching headers

### CI/CD Pipeline (Future)
- [ ] Create `.github/workflows/firebase-hosting.yml`
- [ ] Configure GitHub Actions for automatic deployment
- [ ] Set up Firebase service account for GitHub Actions
- [ ] Store service account key as GitHub secret
- [ ] Configure build and deploy triggers (on push to main)

## Troubleshooting

### Common Issues
- **Build fails**: Ensure all dependencies are installed (`flutter pub get`)
- **Firebase init fails**: Check Firebase CLI is logged in (`firebase login`)
- **Deploy fails**: Verify Firebase project has Hosting enabled
- **App not loading**: Check browser console for errors, verify `base href` in index.html
- **Routing issues**: Ensure rewrites are configured for single-page app

### Useful Commands
```bash
# Check Flutter web support
flutter devices

# Build web app with source maps for debugging
flutter build web --source-maps

# Deploy with specific project
firebase deploy --only hosting --project [project-id]

# Preview before deploying
firebase hosting:channel:deploy preview

# List Firebase projects
firebase projects:list

# View deployment history
firebase hosting:releases:list
```

## Resources
- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web/building)
- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)