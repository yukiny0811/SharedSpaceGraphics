//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import SwiftUI

struct ControlBarView: View {
    
    let renderer: MainRenderer
    let exportManager: ExportManager
    
    let projDirURL: URL
    
    @State var exportTask: Task<(), Never>? = nil
    @State var frameRate: Double = 60
    @State var exportType: ExportFileType = .mp4
    @State var exportFolderURL: URL?
    @State var exportFileName: String = "sample"
    
    var leftSection: some View {
        HStack {
            if renderer.renderingStatus != .exporting {
                Text("Export")
                    .foregroundStyle(.mint)
                    .padding(3)
                    .onTapGesture {
                        guard renderer.renderingStatus != .exporting && renderer.renderingStatus != .requestedSetup && renderer.renderingStatus != .settingUp else {
                            return
                        }
                        guard let exportFolderURL else {
                            return
                        }
                        if FileManager.default.fileExists(atPath: exportFolderURL.absoluteString) {
                            print("already file there!")
                            return
                        }
                        if FileManager.default.fileExists(atPath: exportFolderURL.appending(path: exportFileName + "." + exportType.rawValue).absoluteString) {
                            print("already file there!")
                            return
                        }
                        renderer.renderingStatus = .exporting
                        exportTask = Task {
                            let exportedImageUrls = await exportManager.export(
                                renderer: renderer,
                                fps: frameRate,
                                exportFolderURL: exportFolderURL,
                                fileName: exportFileName,
                                fileType: exportType
                            )
                            if exportType == .mp4 {
                                await exportManager.generateVideo(
                                    folderURL: exportFolderURL,
                                    frameUrls: exportedImageUrls,
                                    fps: frameRate,
                                    movieName: exportFileName
                                )
                                for url in exportedImageUrls {
                                    try? FileManager.default.removeItem(at: url)
                                }
                            }
                            renderer.renderingStatus = .paused
                        }
                    }
            } else {
                Text("Cancel")
                    .foregroundStyle(.pink)
                    .padding(3)
                    .onTapGesture {
                        exportTask?.cancel()
                        renderer.renderingStatus = .paused
                    }
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Exporting...")
                        .font(.caption)
                    ProgressView(value: exportManager.currentProgress)
                }
                .frame(minWidth: 100, maxWidth: 250)
            }
            
            Picker("", selection: $frameRate) {
                ForEach([Double(30), Double(60), Double(29.97)], id: \.self) { rate in
                    Text(String(format: "%.2f", rate))
                        .tag(rate)
                }
            }
            .pickerStyle(.palette)
            .frame(minWidth: 150, maxWidth: 250)
            
            Picker("", selection: $exportType) {
                ForEach(ExportFileType.allCases, id: \.self) { fileType in
                    Text(fileType.rawValue)
                        .tag(fileType)
                }
            }
            .pickerStyle(.palette)
            .frame(minWidth: 150, maxWidth: 250)
            
            TextField("File name", text: $exportFileName)
                .frame(minWidth: 50, maxWidth: 100)
            
            HStack {
                if let exportFolderURL {
                    Button {
                        let openPanel = NSOpenPanel()
                        openPanel.allowsMultipleSelection = false
                        openPanel.canChooseDirectories = true
                        openPanel.canChooseFiles = false
                        if openPanel.runModal() == .OK {
                            self.exportFolderURL = openPanel.url
                        }
                    } label: {
                        Text(exportFolderURL.absoluteString)
                            .font(.caption)
                    }
                } else {
                    Button("Export Folder (none)") {
                        let openPanel = NSOpenPanel()
                        openPanel.allowsMultipleSelection = false
                        openPanel.canChooseDirectories = true
                        openPanel.canChooseFiles = false
                        if openPanel.runModal() == .OK {
                            exportFolderURL = openPanel.url
                        }
                    }
                }
            }
        }
    }
    
    var rightSection: some View {
        HStack {
            Image(systemName: "flag.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.mint)
                .onTapGesture {
                    let globalTimeNormalized = renderer.currentSecondsFromStart / renderer.videoLength
                    renderer.eyeXKeyframes.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.eye.x, minValue: -30, maxValue: 30))
                    renderer.eyeYKeyframes.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.eye.y, minValue: -30, maxValue: 30))
                    renderer.eyeZKeyframes.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.eye.z, minValue: -30, maxValue: 30))
                    renderer.lookXKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.center.x, minValue: -30, maxValue: 30))
                    renderer.lookYKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.center.y, minValue: -30, maxValue: 30))
                    renderer.lookZKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.center.z, minValue: -30, maxValue: 30))
                    renderer.upXKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.up.x, minValue: -30, maxValue: 30))
                    renderer.upYKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.up.y, minValue: -30, maxValue: 30))
                    renderer.upZKeyFrames.append(Keyframe(id: UUID().uuidString, globalTime: globalTimeNormalized, value: renderer.previewCamera.up.z, minValue: -30, maxValue: 30))
                }
            Picker(
                "",
                selection: Binding {
                    renderer.cameraType
                } set: { newValue in
                    renderer.cameraType = newValue
                }
            ) {
                ForEach(CameraType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.palette)
            .frame(minWidth: 100, maxWidth: 250)
            .padding(.trailing, 12)
            
            Image(systemName: renderer.renderingStatus == .rendering ? "stop" : "play")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(renderer.renderingStatus == .rendering ? Color.pink : Color.mint)
                .onTapGesture {
                    if renderer.renderingStatus == .rendering {
                        renderer.pause()
                    } else if renderer.renderingStatus == .paused {
                        renderer.play()
                    }
                }
            Text(String(format: "%.2f", renderer.currentSecondsFromStart) + "/" + String(format: "%.2f", renderer.videoLength))
                .font(.title3)
                .monospaced()
                .frame(width: 120)
            
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.mint)
                .onTapGesture {
                    SaveManager.save(renderer: renderer, projDirURL: projDirURL)
                }
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 8)
            
            leftSection
            
            Spacer()
            
            rightSection
            
            Spacer()
                .frame(width: 8)
        }
        .frame(maxWidth: .infinity)
    }
}

