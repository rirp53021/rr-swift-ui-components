// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Performance Configuration

/// Central configuration for performance optimizations
@MainActor
public struct PerformanceConfiguration {
    // MARK: - Singleton
    
    public static let shared = PerformanceConfiguration()
    
    // MARK: - General Settings
    
    public var isEnabled: Bool = true
    public var debugMode: Bool = false
    public var monitoringEnabled: Bool = true
    
    // MARK: - Lazy Loading Settings
    
    public var lazyLoadingEnabled: Bool = true
    public var lazyLoadingDelay: TimeInterval = 0.1
    public var lazyLoadingAnimation: Animation = .easeInOut(duration: 0.2)
    
    // MARK: - Theme Caching Settings
    
    public var themeCachingEnabled: Bool = true
    public var themeCacheSize: Int = 50
    public var themeCacheExpiration: TimeInterval = 300 // 5 minutes
    
    // MARK: - Memory Optimization Settings
    
    public var memoryOptimizationEnabled: Bool = true
    public var maxMemoryUsage: UInt64 = 100 * 1024 * 1024 // 100MB
    public var memoryCleanupThreshold: Double = 0.8 // 80%
    public var memoryWarningThreshold: Double = 0.9 // 90%
    
    // MARK: - Bundle Optimization Settings
    
    public var bundleOptimizationEnabled: Bool = true
    public var bundleCacheEnabled: Bool = true
    public var resourcePreloadingEnabled: Bool = true
    public var bundleCacheSize: Int = 100
    
    // MARK: - Component-Specific Settings
    
    public var carouselLazyLoading: Bool = true
    public var carouselVisibleRange: Int = 3
    public var carouselPreloadCount: Int = 5
    
    public var listLazyLoading: Bool = true
    public var listBatchSize: Int = 20
    public var listThreshold: Int = 5
    
    public var gridLazyLoading: Bool = true
    public var gridBatchSize: Int = 20
    public var gridThreshold: Int = 5
    
    public var imageLazyLoading: Bool = true
    public var imageCacheSize: Int = 50
    public var imageCompressionQuality: Double = 0.8
    
    public var modalLazyLoading: Bool = true
    public var modalPreloadDelay: TimeInterval = 0.1
    
    // MARK: - Animation Settings
    
    public var animationEnabled: Bool = true
    public var animationDuration: TimeInterval = 0.3
    public var animationEasing: Animation = .easeInOut
    
    // MARK: - Debug Settings
    
    public var showPerformanceOverlay: Bool = false
    public var logPerformanceMetrics: Bool = false
    public var performanceLogLevel: PerformanceLogLevel = .info
    
    // MARK: - Initialization
    
    private init() {
        loadConfiguration()
    }
    
    // MARK: - Configuration Management
    
    private mutating func loadConfiguration() {
        // Load from UserDefaults
        isEnabled = UserDefaults.standard.bool(forKey: "performanceEnabled")
        debugMode = UserDefaults.standard.bool(forKey: "performanceDebugMode")
        monitoringEnabled = UserDefaults.standard.bool(forKey: "performanceMonitoringEnabled")
    }
    
    public func saveConfiguration() {
        UserDefaults.standard.set(isEnabled, forKey: "performanceEnabled")
        UserDefaults.standard.set(debugMode, forKey: "performanceDebugMode")
        UserDefaults.standard.set(monitoringEnabled, forKey: "performanceMonitoringEnabled")
    }
    
    // MARK: - Configuration Updates
    
    public mutating func update<T>(_ keyPath: WritableKeyPath<PerformanceConfiguration, T>, to value: T) {
        self[keyPath: keyPath] = value
        saveConfiguration()
    }
    
    public mutating func resetToDefaults() {
        self = PerformanceConfiguration()
        saveConfiguration()
    }
}

// MARK: - Performance Log Level

public enum PerformanceLogLevel: String, CaseIterable, Sendable {
    case debug = "debug"
    case info = "info"
    case warning = "warning"
    case error = "error"
    
    public var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
}

// MARK: - Performance Logger

/// Performance logging utility
@MainActor public class PerformanceLogger {
    public static let shared = PerformanceLogger()
    
    private let configuration = PerformanceConfiguration.shared
    
    private init() {}
    
    public func log(_ message: String, level: PerformanceLogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        guard configuration.logPerformanceMetrics else { return }
        guard level.priority >= configuration.performanceLogLevel.priority else { return }
        
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue.uppercased())] [\(fileName):\(line)] \(function): \(message)"
        
        print(logMessage)
    }
    
    public func logPerformance<T>(_ operation: String, block: () throws -> T) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        defer {
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            log("\(operation) took \(String(format: "%.3f", timeElapsed)) seconds", level: .debug)
        }
        
        return try block()
    }
    
    public func logMemoryUsage(_ context: String) {
        var memoryInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let result = withUnsafeMutablePointer(to: &memoryInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if result == KERN_SUCCESS {
            let memoryUsage = UInt64(memoryInfo.resident_size)
            let formattedUsage = ByteCountFormatter.string(fromByteCount: Int64(memoryUsage), countStyle: .memory)
            log("Memory usage in \(context): \(formattedUsage)", level: .debug)
        }
    }
}

// MARK: - Date Formatter Extension

private extension DateFormatter {
    static let logTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

// MARK: - Performance Configuration View

/// SwiftUI view for configuring performance settings
public struct PerformanceConfigurationView: View {
    @State private var configuration = PerformanceConfiguration.shared
    @State private var showingResetAlert = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                // General Settings
                Section {
                    Toggle("Enable Performance Optimizations", isOn: $configuration.isEnabled)
                    Toggle("Debug Mode", isOn: $configuration.debugMode)
                    Toggle("Enable Monitoring", isOn: $configuration.monitoringEnabled)
                }
                
                // Lazy Loading Settings
                Section {
                    Toggle("Enable Lazy Loading", isOn: $configuration.lazyLoadingEnabled)
                    
                    if configuration.lazyLoadingEnabled {
                        VStack(alignment: .leading) {
                            RRLabel("Loading Delay", style: .body)
                            Slider(value: $configuration.lazyLoadingDelay, in: 0...1, step: 0.1)
                            RRLabel("\(String(format: "%.1f", configuration.lazyLoadingDelay)) seconds", style: .caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Memory Settings
                Section {
                    Toggle("Enable Memory Optimization", isOn: $configuration.memoryOptimizationEnabled)
                    
                    if configuration.memoryOptimizationEnabled {
                        VStack(alignment: .leading) {
                            RRLabel("Max Memory Usage", style: .body)
                            Slider(value: Binding(
                                get: { Double(configuration.maxMemoryUsage) / (1024 * 1024) },
                                set: { configuration.maxMemoryUsage = UInt64($0 * 1024 * 1024) }
                            ), in: 50...500, step: 50)
                            RRLabel("\(Int(configuration.maxMemoryUsage / (1024 * 1024))) MB", style: .caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            RRLabel("Cleanup Threshold", style: .body)
                            Slider(value: $configuration.memoryCleanupThreshold, in: 0.5...1.0, step: 0.1)
                            RRLabel("\(Int(configuration.memoryCleanupThreshold * 100))%", style: .caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Component Settings
                Section {
                    Toggle("Carousel Lazy Loading", isOn: $configuration.carouselLazyLoading)
                    Toggle("List Lazy Loading", isOn: $configuration.listLazyLoading)
                    Toggle("Grid Lazy Loading", isOn: $configuration.gridLazyLoading)
                    Toggle("Image Lazy Loading", isOn: $configuration.imageLazyLoading)
                    Toggle("Modal Lazy Loading", isOn: $configuration.modalLazyLoading)
                }
                
                // Debug Settings
                Section {
                    Toggle("Show Performance Overlay", isOn: $configuration.showPerformanceOverlay)
                    Toggle("Log Performance Metrics", isOn: $configuration.logPerformanceMetrics)
                    
                    if configuration.logPerformanceMetrics {
                        Picker("Log Level", selection: $configuration.performanceLogLevel) {
                            ForEach(PerformanceLogLevel.allCases, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // Actions
                Section {
                    RRButton("Reset to Defaults", style: .destructive) {
                        showingResetAlert = true
                    }
                }
            }
            .navigationTitle("Performance Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onDisappear {
                configuration.saveConfiguration()
            }
            .alert("Reset Configuration", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    configuration.resetToDefaults()
                }
            } message: {
                Text("This will reset all performance settings to their default values. This action cannot be undone.")
            }
        }
    }
}

// MARK: - Performance Configuration Modifier

public extension View {
    /// Apply performance configuration to the view
    func performanceConfigured() -> some View {
        self
            .onAppear {
                let config = PerformanceConfiguration.shared
                if config.debugMode {
                    PerformanceLogger.shared.log("View appeared", level: .debug)
                }
            }
            .onDisappear {
                let config = PerformanceConfiguration.shared
                if config.debugMode {
                    PerformanceLogger.shared.log("View disappeared", level: .debug)
                }
            }
    }
    
}
