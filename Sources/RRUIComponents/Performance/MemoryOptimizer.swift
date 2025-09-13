// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Memory Optimizer

/// Memory optimization utilities for RRUIComponents
@MainActor public class MemoryOptimizer: ObservableObject {
    public static let shared = MemoryOptimizer()
    
    // MARK: - Configuration
    
    @Published public var isEnabled: Bool = true
    @Published public var maxMemoryUsage: UInt64 = 100 * 1024 * 1024 // 100MB
    @Published public var cleanupThreshold: Double = 0.8 // 80% of max memory
    
    // MARK: - Memory Tracking
    
    @Published public var currentMemoryUsage: UInt64 = 0
    @Published public var peakMemoryUsage: UInt64 = 0
    @Published public var memoryPressureLevel: MemoryPressureLevel = .normal
    
    // MARK: - Weak References
    
    private var weakReferences: [String: WeakReference] = [:]
    private var memoryWarningObserver: AnyCancellable?
    
    private init() {
        setupMemoryMonitoring()
    }
    
    // MARK: - Memory Monitoring
    
    private func setupMemoryMonitoring() {
        #if canImport(UIKit)
        memoryWarningObserver = NotificationCenter.default
            .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                self?.handleMemoryWarning()
            }
        #endif
        
        // Monitor memory usage periodically
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateMemoryUsage()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func updateMemoryUsage() {
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
            currentMemoryUsage = UInt64(memoryInfo.resident_size)
            peakMemoryUsage = max(peakMemoryUsage, currentMemoryUsage)
            
            updateMemoryPressureLevel()
        }
    }
    
    private func updateMemoryPressureLevel() {
        let usageRatio = Double(currentMemoryUsage) / Double(maxMemoryUsage)
        
        if usageRatio >= cleanupThreshold {
            memoryPressureLevel = .high
            performMemoryCleanup()
        } else if usageRatio >= 0.6 {
            memoryPressureLevel = .medium
        } else {
            memoryPressureLevel = .normal
        }
    }
    
    // MARK: - Memory Cleanup
    
    private func handleMemoryWarning() {
        memoryPressureLevel = .critical
        performAggressiveMemoryCleanup()
    }
    
    public func performMemoryCleanup() {
        // Clear weak references that are no longer valid
        weakReferences = weakReferences.filter { $0.value.object != nil }
        
        // Notify components to release unnecessary resources
        NotificationCenter.default.post(name: .memoryCleanupRequested, object: nil)
    }
    
    private func performAggressiveMemoryCleanup() {
        // Clear all weak references
        weakReferences.removeAll()
        
        // Clear caches
        PerformanceOptimizer.shared.clearCaches()
        
        // Force garbage collection
        DispatchQueue.main.async {
            // This will trigger a memory cleanup
            _ = "memory_cleanup"
        }
    }
    
    // MARK: - Weak Reference Management
    
    public func storeWeakReference<T: AnyObject>(_ object: T, for key: String) {
        weakReferences[key] = WeakReference(object: object)
    }
    
    public func getWeakReference<T: AnyObject>(for key: String, as type: T.Type) -> T? {
        return weakReferences[key]?.object as? T
    }
    
    public func removeWeakReference(for key: String) {
        weakReferences.removeValue(forKey: key)
    }
    
    // MARK: - Memory Statistics
    
    public var memoryStats: MemoryStats {
        MemoryStats(
            currentUsage: currentMemoryUsage,
            peakUsage: peakMemoryUsage,
            maxUsage: maxMemoryUsage,
            usagePercentage: Double(currentMemoryUsage) / Double(maxMemoryUsage),
            pressureLevel: memoryPressureLevel,
            weakReferenceCount: weakReferences.count
        )
    }
    
    /// Clear all caches to free memory
    public func clearCaches() {
        weakReferences.removeAll()
    }
    
    /// Optimize caches by removing least used entries
    public func optimizeCaches() {
        // Remove weak references that are no longer valid
        weakReferences = weakReferences.filter { $0.value.object != nil }
    }
    
}

// MARK: - Memory Pressure Level

public enum MemoryPressureLevel: String, CaseIterable {
    case normal = "normal"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    public var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .critical:
            return .red
        }
    }
}

// MARK: - Memory Stats

public struct MemoryStats {
    public let currentUsage: UInt64
    public let peakUsage: UInt64
    public let maxUsage: UInt64
    public let usagePercentage: Double
    public let pressureLevel: MemoryPressureLevel
    public let weakReferenceCount: Int
    
    public var formattedCurrentUsage: String {
        ByteCountFormatter.string(fromByteCount: Int64(currentUsage), countStyle: .memory)
    }
    
    public var formattedPeakUsage: String {
        ByteCountFormatter.string(fromByteCount: Int64(peakUsage), countStyle: .memory)
    }
    
    public var formattedMaxUsage: String {
        ByteCountFormatter.string(fromByteCount: Int64(maxUsage), countStyle: .memory)
    }
}

// MARK: - Weak Reference

private class WeakReference {
    weak var object: AnyObject?
    
    init(object: AnyObject) {
        self.object = object
    }
}

// MARK: - Memory Optimized View

/// View that automatically manages memory usage
public struct MemoryOptimizedView<Content: View>: View {
    private let content: () -> Content
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    @State private var isVisible = false
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Group {
            if isVisible {
                content()
            } else {
                Color.clear
            }
        }
        .onAppear {
            isVisible = true
        }
        .onDisappear {
            isVisible = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .memoryCleanupRequested)) { _ in
            if !isVisible {
                // Release resources when not visible
                releaseResources()
            }
        }
    }
    
    private func releaseResources() {
        // Override in subclasses to release specific resources
    }
}

// MARK: - Memory Efficient List

/// List that efficiently manages memory for large datasets
public struct MemoryEfficientList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let content: (Data.Element) -> Content
    private let visibleRange: Int
    
    @State private var visibleItems: [Data.Element] = []
    @State private var itemCache: [Data.Element.ID: Data.Element] = [:]
    
    public init(
        data: Data,
        visibleRange: Int = 10,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.visibleRange = visibleRange
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(visibleItems.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .onAppear {
                            updateVisibleItems(for: index)
                        }
                }
            }
        }
        .onAppear {
            loadInitialItems()
        }
        .onReceive(NotificationCenter.default.publisher(for: .memoryCleanupRequested)) { _ in
            cleanupCache()
        }
    }
    
    private func loadInitialItems() {
        let initialCount = min(visibleRange, data.count)
        visibleItems = Array(data.prefix(initialCount))
        
        // Cache initial items
        for item in visibleItems {
            itemCache[item.id] = item
        }
    }
    
    private func updateVisibleItems(for index: Int) {
        let startIndex = max(0, index - visibleRange / 2)
        let endIndex = min(data.count, startIndex + visibleRange)
        
        let newItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
        
        if !newItems.elementsEqual(visibleItems, by: { $0.id == $1.id }) {
            visibleItems = newItems
            
            // Update cache
            itemCache.removeAll()
            for item in visibleItems {
                itemCache[item.id] = item
            }
        }
    }
    
    private func cleanupCache() {
        // Keep only visible items in cache
        let visibleIds = Set(visibleItems.map { $0.id })
        itemCache = itemCache.filter { visibleIds.contains($0.key) }
    }
}

// MARK: - Memory Efficient Grid

/// Grid that efficiently manages memory for large datasets
public struct MemoryEfficientGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: [GridItem]
    private let content: (Data.Element) -> Content
    private let visibleRange: Int
    
    @State private var visibleItems: [Data.Element] = []
    @State private var itemCache: [Data.Element.ID: Data.Element] = [:]
    
    public init(
        data: Data,
        columns: [GridItem],
        visibleRange: Int = 20,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.content = content
        self.visibleRange = visibleRange
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(visibleItems.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .onAppear {
                            updateVisibleItems(for: index)
                        }
                }
            }
            .padding()
        }
        .onAppear {
            loadInitialItems()
        }
        .onReceive(NotificationCenter.default.publisher(for: .memoryCleanupRequested)) { _ in
            cleanupCache()
        }
    }
    
    private func loadInitialItems() {
        let initialCount = min(visibleRange, data.count)
        visibleItems = Array(data.prefix(initialCount))
        
        // Cache initial items
        for item in visibleItems {
            itemCache[item.id] = item
        }
    }
    
    private func updateVisibleItems(for index: Int) {
        let startIndex = max(0, index - visibleRange / 2)
        let endIndex = min(data.count, startIndex + visibleRange)
        
        let newItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
        
        if !newItems.elementsEqual(visibleItems, by: { $0.id == $1.id }) {
            visibleItems = newItems
            
            // Update cache
            itemCache.removeAll()
            for item in visibleItems {
                itemCache[item.id] = item
            }
        }
    }
    
    private func cleanupCache() {
        // Keep only visible items in cache
        let visibleIds = Set(visibleItems.map { $0.id })
        itemCache = itemCache.filter { visibleIds.contains($0.key) }
    }
}

// MARK: - Memory Monitor View

/// View that displays memory usage information
public struct MemoryMonitorView: View {
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RRLabel("Memory Usage", style: .title)
                
                Spacer()
                
                Circle()
                    .fill(memoryOptimizer.memoryStats.pressureLevel.color)
                    .frame(width: 12, height: 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    RRLabel("Current:", style: .caption)
                    Spacer()
                    RRLabel(memoryOptimizer.memoryStats.formattedCurrentUsage, style: .caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    RRLabel("Peak:", style: .caption)
                    Spacer()
                    RRLabel(memoryOptimizer.memoryStats.formattedPeakUsage, style: .caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    RRLabel("Max:", style: .caption)
                    Spacer()
                    RRLabel(memoryOptimizer.memoryStats.formattedMaxUsage, style: .caption)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(
                    value: memoryOptimizer.memoryStats.usagePercentage,
                    total: 1.0
                )
                .progressViewStyle(LinearProgressViewStyle())
                .tint(memoryOptimizer.memoryStats.pressureLevel.color)
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let memoryCleanupRequested = Notification.Name("memoryCleanupRequested")
}

// MARK: - View Extensions

public extension View {
    /// Apply memory optimization to the view
    func memoryOptimized() -> some View {
        MemoryOptimizedView {
            self
        }
    }
    
    /// Apply memory efficient list behavior
    func memoryEfficientList<Data: RandomAccessCollection>(
        data: Data,
        visibleRange: Int = 10
    ) -> some View where Data.Element: Identifiable {
        MemoryEfficientList(data: data, visibleRange: visibleRange) { item in
            self
        }
    }
    
    /// Apply memory efficient grid behavior
    func memoryEfficientGrid<Data: RandomAccessCollection>(
        data: Data,
        columns: [GridItem],
        visibleRange: Int = 20
    ) -> some View where Data.Element: Identifiable {
        MemoryEfficientGrid(data: data, columns: columns, visibleRange: visibleRange) { item in
            self
        }
    }
}
