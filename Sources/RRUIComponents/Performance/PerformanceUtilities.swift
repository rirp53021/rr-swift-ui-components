// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Performance Utilities

/// Central performance utilities for RRUIComponents
@MainActor
public class PerformanceUtilities: ObservableObject {
    public static let shared = PerformanceUtilities()
    
    // MARK: - Managers
    
    @Published public var optimizer = PerformanceOptimizer.shared
    @Published public var memoryOptimizer = MemoryOptimizer.shared
    @Published public var bundleOptimizer = BundleOptimizer.shared
    @Published public var monitor = PerformanceMonitor.shared
    @Published public var configuration = PerformanceConfiguration.shared
    @Published public var logger = PerformanceLogger.shared
    
    // MARK: - Initialization
    
    private init() {
        setupPerformanceOptimizations()
    }
    
    // MARK: - Setup
    
    private func setupPerformanceOptimizations() {
        // Configure optimizers based on configuration
        optimizer.isEnabled = configuration.isEnabled
        optimizer.lazyLoadingEnabled = configuration.lazyLoadingEnabled
        optimizer.themeCachingEnabled = configuration.themeCachingEnabled
        optimizer.memoryOptimizationEnabled = configuration.memoryOptimizationEnabled
        optimizer.bundleOptimizationEnabled = configuration.bundleOptimizationEnabled
        
        memoryOptimizer.isEnabled = configuration.memoryOptimizationEnabled
        memoryOptimizer.maxMemoryUsage = configuration.maxMemoryUsage
        
        bundleOptimizer.isEnabled = configuration.bundleOptimizationEnabled
        bundleOptimizer.cacheEnabled = configuration.bundleCacheEnabled
        bundleOptimizer.preloadEnabled = configuration.resourcePreloadingEnabled
        
        monitor.isMonitoring = configuration.monitoringEnabled
        
        // Start performance monitoring if enabled
        if configuration.monitoringEnabled {
            monitor.startMonitoring()
        }
        
        // Preload resources if enabled
        if configuration.resourcePreloadingEnabled {
            bundleOptimizer.preloadAllResources()
        }
    }
    
    // MARK: - Performance Optimization
    
    /// Apply all performance optimizations to a view
    public func optimizeView<Content: View>(_ content: Content) -> some View {
        content
            .performanceConfigured()
            .lazy()
            .memoryOptimized()
            .onAppear {
                BundleOptimizer.shared.preloadAllResources()
            }
    }
    
    /// Apply lazy loading optimization
    public func lazyLoad<Content: View>(_ content: Content) -> some View {
        LazyComponent {
            content
        }
    }
    
    /// Apply memory optimization
    public func memoryOptimize<Content: View>(_ content: Content) -> some View {
        MemoryOptimizedView {
            content
        }
    }
    
    /// Apply bundle optimization
    public func bundleOptimize<Content: View>(_ content: Content) -> some View {
        content
            .onAppear {
                BundleOptimizer.shared.preloadAllResources()
            }
    }
    
    // MARK: - Performance Monitoring
    
    /// Start performance monitoring
    public func startMonitoring() {
        monitor.startMonitoring()
        configuration.update(\.monitoringEnabled, to: true)
    }
    
    /// Stop performance monitoring
    public func stopMonitoring() {
        monitor.stopMonitoring()
        configuration.update(\.monitoringEnabled, to: false)
    }
    
    /// Get current performance metrics
    public var currentMetrics: PerformanceMetrics {
        monitor.metrics
    }
    
    /// Get memory statistics
    public var memoryStats: MemoryStats {
        memoryOptimizer.memoryStats
    }
    
    /// Get cache statistics
    public var cacheStats: CacheStats {
        optimizer.cacheStats
    }
    
    /// Get bundle statistics
    public var bundleStats: BundleCacheStats {
        bundleOptimizer.cacheStats
    }
    
    // MARK: - Cache Management
    
    /// Clear all caches
    public func clearAllCaches() {
        optimizer.clearCaches()
        bundleOptimizer.clearAllCaches()
        memoryOptimizer.clearCaches()
    }
    
    /// Optimize all caches
    public func optimizeAllCaches() {
        optimizer.optimizeCaches()
        memoryOptimizer.optimizeCaches()
    }
    
    // MARK: - Memory Management
    
    /// Perform memory cleanup
    public func performMemoryCleanup() {
        memoryOptimizer.performMemoryCleanup()
    }
    
    /// Check if memory usage is high
    public var isMemoryUsageHigh: Bool {
        memoryOptimizer.memoryStats.pressureLevel == .high || memoryOptimizer.memoryStats.pressureLevel == .critical
    }
    
    // MARK: - Performance Logging
    
    /// Log performance metric
    public func logPerformance<T>(_ operation: String, block: () throws -> T) rethrows -> T {
        return try logger.logPerformance(operation, block: block)
    }
    
    /// Log memory usage
    public func logMemoryUsage(_ context: String) {
        logger.logMemoryUsage(context)
    }
    
    /// Log performance message
    public func log(_ message: String, level: PerformanceLogLevel = .info) {
        logger.log(message, level: level)
    }
}

// MARK: - Performance View Modifiers

public extension View {
    /// Apply all performance optimizations
    func performanceOptimized() -> some View {
        PerformanceUtilities.shared.optimizeView(self)
    }
    
    /// Apply lazy loading optimization
    func lazyLoaded() -> some View {
        PerformanceUtilities.shared.lazyLoad(self)
    }
    
    
    /// Add performance dashboard
    func withPerformanceDashboard(position: PerformanceDashboardPosition = .bottomTrailing) -> some View {
        self.performanceDashboard(position: position)
    }
    
    /// Add performance monitoring
    func withPerformanceMonitoring() -> some View {
        self
            .onAppear {
                PerformanceUtilities.shared.logMemoryUsage("view appearance")
            }
    }
}

// MARK: - Performance Hooks

/// Performance hooks for components
@MainActor
public struct PerformanceHooks {
    public static let shared = PerformanceHooks()
    
    private init() {}
    
    /// Hook for component initialization
    public func onComponentInit<T>(_ component: T, context: String = "") {
        let componentName = String(describing: type(of: component))
        PerformanceUtilities.shared.log("\(componentName) initialized\(context.isEmpty ? "" : " in \(context)")", level: .debug)
    }
    
    /// Hook for component deinitialization
    public func onComponentDeinit<T>(_ component: T, context: String = "") {
        let componentName = String(describing: type(of: component))
        PerformanceUtilities.shared.log("\(componentName) deinitialized\(context.isEmpty ? "" : " in \(context)")", level: .debug)
    }
    
    /// Hook for expensive operations
    public func onExpensiveOperation<T>(_ operation: String, block: () throws -> T) rethrows -> T {
        return try PerformanceUtilities.shared.logPerformance(operation, block: block)
    }
    
    /// Hook for memory allocation
    public func onMemoryAllocation(_ context: String) {
        PerformanceUtilities.shared.logMemoryUsage(context)
    }
}

// MARK: - Performance Constants

/// Performance-related constants
public struct PerformanceConstants {
    // MARK: - Memory Limits
    
    public static let defaultMaxMemoryUsage: UInt64 = 100 * 1024 * 1024 // 100MB
    public static let criticalMemoryThreshold: Double = 0.9 // 90%
    public static let warningMemoryThreshold: Double = 0.8 // 80%
    
    // MARK: - Cache Limits
    
    public static let defaultCacheSize: Int = 100
    public static let maxCacheSize: Int = 500
    public static let cacheCleanupThreshold: Double = 0.8 // 80%
    
    // MARK: - Lazy Loading
    
    public static let defaultLazyLoadingDelay: TimeInterval = 0.1
    public static let maxLazyLoadingDelay: TimeInterval = 1.0
    public static let defaultBatchSize: Int = 20
    public static let maxBatchSize: Int = 100
    
    // MARK: - Animation
    
    public static let defaultAnimationDuration: TimeInterval = 0.3
    public static let fastAnimationDuration: TimeInterval = 0.1
    public static let slowAnimationDuration: TimeInterval = 0.5
    
    // MARK: - Monitoring
    
    public static let monitoringInterval: TimeInterval = 1.0
    public static let metricsRetentionPeriod: TimeInterval = 300 // 5 minutes
}

// MARK: - Performance Debugging

/// Performance debugging utilities
@MainActor
public struct PerformanceDebugger {
    public static let shared = PerformanceDebugger()
    
    private init() {}
    
    /// Print performance statistics
    public func printStats() {
        let utilities = PerformanceUtilities.shared
        
        print("=== Performance Statistics ===")
        print("Memory Usage: \(utilities.memoryStats.formattedCurrentUsage)")
        print("Memory Pressure: \(utilities.memoryStats.pressureLevel.rawValue)")
        print("Cache Utilization: \(String(format: "%.1f%%", utilities.cacheStats.cacheUtilization * 100))")
        print("FPS: \(String(format: "%.1f", utilities.currentMetrics.fps))")
        print("Cache Hit Rate: \(String(format: "%.1f%%", utilities.currentMetrics.cacheHitRate * 100))")
        print("=============================")
    }
    
    /// Export performance data
    public func exportData() -> [String: Any] {
        let utilities = PerformanceUtilities.shared
        
        return [
            "memory": [
                "currentUsage": utilities.memoryStats.currentUsage,
                "peakUsage": utilities.memoryStats.peakUsage,
                "pressureLevel": utilities.memoryStats.pressureLevel.rawValue
            ],
            "cache": [
                "utilization": utilities.cacheStats.cacheUtilization,
                "totalSize": utilities.cacheStats.totalCacheSize
            ],
            "performance": [
                "fps": utilities.currentMetrics.fps,
                "cacheHitRate": utilities.currentMetrics.cacheHitRate
            ],
            "timestamp": Date().timeIntervalSince1970
        ]
    }
}

// MARK: - Performance Testing

/// Performance testing utilities
@MainActor
public struct PerformanceTester {
    public static let shared = PerformanceTester()
    
    private init() {}
    
    /// Test component rendering performance
    public func testRenderingPerformance<Content: View>(
        _ content: Content,
        iterations: Int = 100
    ) -> PerformanceTestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = content.body
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        let averageTime = totalTime / Double(iterations)
        
        return PerformanceTestResult(
            totalTime: totalTime,
            averageTime: averageTime,
            iterations: iterations,
            fps: 1.0 / averageTime
        )
    }
    
    /// Test memory allocation performance
    public func testMemoryAllocation(
        block: () -> Void,
        iterations: Int = 1000
    ) -> MemoryTestResult {
        let startMemory = getCurrentMemoryUsage()
        
        for _ in 0..<iterations {
            block()
        }
        
        let endMemory = getCurrentMemoryUsage()
        let memoryDelta = endMemory - startMemory
        
        return MemoryTestResult(
            startMemory: startMemory,
            endMemory: endMemory,
            memoryDelta: memoryDelta,
            iterations: iterations
        )
    }
    
    private func getCurrentMemoryUsage() -> UInt64 {
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
            return UInt64(memoryInfo.resident_size)
        }
        
        return 0
    }
}

// MARK: - Performance Test Results

public struct PerformanceTestResult {
    public let totalTime: TimeInterval
    public let averageTime: TimeInterval
    public let iterations: Int
    public let fps: Double
    
    public var isGoodPerformance: Bool {
        fps >= 55.0
    }
}

public struct MemoryTestResult {
    public let startMemory: UInt64
    public let endMemory: UInt64
    public let memoryDelta: UInt64
    public let iterations: Int
    
    public var averageMemoryPerIteration: UInt64 {
        memoryDelta / UInt64(iterations)
    }
    
    public var isMemoryEfficient: Bool {
        averageMemoryPerIteration < 1024 // Less than 1KB per iteration
    }
}
