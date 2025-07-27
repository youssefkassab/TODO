# Image Upload Guide

This document provides information about the image upload functionality in the TODO app, including platform-specific considerations and known issues.

## Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web (with limitations)
- ✅ Desktop (Windows, macOS, Linux)

## Web-Specific Limitations

### Image Picker

The app uses the `image_picker` package which has the following limitations on web:

1. **File Selection Dialog**
   - The file picker dialog is browser-native and cannot be customized
   - The dialog appearance and behavior varies across different browsers

2. **File Types**
   - Some browsers may restrict certain file types
   - Recommended formats: JPG, PNG, GIF
   - Maximum file size: 10MB (configurable in server settings)

3. **Mobile Web**
   - On mobile web, the camera might not be available in all browsers
   - Some mobile browsers may require HTTPS to access the camera

4. **Safari Specific**
   - Safari has stricter security policies for file uploads
   - May require user interaction (click) to trigger file selection

## Troubleshooting

### Common Issues

1. **Upload Fails Silently**
   - Check browser console for CORS errors
   - Verify the API endpoint is correctly configured
   - Ensure the file size is within limits

2. **Image Doesn't Appear After Upload**
   - The page might need to be refreshed to show the new image
   - Check network tab in developer tools for upload errors

3. **Permission Errors**
   - On mobile web, ensure the app has camera/storage permissions
   - On desktop, check browser permissions for camera/file access

## Testing

### Web Testing

1. **Manual Testing**
   - Test on different browsers (Chrome, Firefox, Safari, Edge)
   - Test on different devices (desktop, mobile, tablet)
   - Test with different image formats and sizes

2. **Automated Testing**
   - Unit tests are available in `test/image_upload_test.dart`
   - Run tests with: `flutter test test/image_upload_test.dart`

## Best Practices

1. **For Users**
   - Use common image formats (JPG, PNG)
   - Keep image size under 5MB for best performance
   - Crop/resize images before uploading when possible

2. **For Developers**
   - Always handle upload errors gracefully
   - Show upload progress to users
   - Implement client-side validation for file types and sizes
   - Consider using a CDN for serving uploaded images

## Future Improvements

- [ ] Implement image compression before upload
- [ ] Add drag-and-drop support for desktop
- [ ] Add image cropping/editing before upload
- [ ] Implement progress indicators for uploads
- [ ] Add support for cloud storage providers (S3, Firebase, etc.)
