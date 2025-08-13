//
//  FeaturePhotoPicker.swift
//  WeLink
//
//  Created by 남만두 on 8/4/25.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

struct PhotoPickerWithPermission: View {
    @Binding var selectedImage: UIImage?
    @Binding var showPicker: Bool
    @State private var showPermissionAlert = false
    @State private var permissionDenied = false
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $showPicker) {
                PhotoPickerView()
            }
            .alert("사진 라이브러리 접근 권한", isPresented: $showPermissionAlert) {
                Button("설정으로 이동") {
                    openSettings()
                }
                Button("취소", role: .cancel) {
                    showPicker = false
                }
            } message: {
                Text("사진을 선택하려면 사진 라이브러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
            }
            .onChange(of: showPicker) { newValue in
                if newValue {
                    checkPhotoLibraryPermission()
                }
            }
    }
    
    private func PhotoPickerView() -> some View {
        PhotoPicker(selectedImage: $selectedImage)
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            break
        case .denied, .restricted:
            showPicker = false
            showPermissionAlert = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                    } else {
                        showPicker = false
                        showPermissionAlert = true
                    }
                }
            }
        @unknown default:
            showPicker = false
            showPermissionAlert = true
        }
    }
    
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
