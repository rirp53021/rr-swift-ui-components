// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Performance Optimizer

/// Central performance optimization manager for RRUIComponents
@MainActor public class PerformanceOptimizer: ObservableObject {
    public static let shared = PerformanceOptimizer()
    
    // MARK: - Configuration
    
    @Published public var isEnabled: Bool = true
    @Published public var lazyLoadingEnabled: Bool = true
    @Published public var themeCachingEnabled: Bool = true
    @Published public var memoryOptimizationEnabled: Bool = true
    @Published public var bundleOptimizationEnabled: Bool = true
    
    // MARK: - Caches
    
    private var themeCache: [String: Theme] = [:]
    private var colorCache: [String: Color] = [:]
    private var fontCache: [String: Font] = [:]
    private var imageCache: [String: Image] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Memory Management
    
    private let maxCacheSize = 100
    private var cacheAccessCount: [String: Int] = [:]
    
    private init() {
        setupMemoryWarningObserver()
    }
    
    // MARK: - Theme Caching
    
    /// Get cached theme or create and cache new one
    public func getCachedTheme(name: String, bundle: Bundle, colorScheme: ThemeColorScheme) -> Theme {
        let cacheKey = "\(name)_\(bundle.bundleIdentifier ?? "unknown")_\(colorScheme.rawValue)"
        
        if let cachedTheme = themeCache[cacheKey] {
            cacheAccessCount[cacheKey, default: 0] += 1
            return cachedTheme
        }
        
        let theme = Theme.create(
            name: name,
            colorScheme: colorScheme,
            bundle: bundle
        )
        
        cacheTheme(theme, key: cacheKey)
        return theme
    }
    
    private func cacheTheme(_ theme: Theme, key: String) {
        if themeCache.count >= maxCacheSize {
            evictLeastUsedTheme()
        }
        
        themeCache[key] = theme
        cacheAccessCount[key] = 1
    }
    
    private func evictLeastUsedTheme() {
        guard let leastUsedKey = cacheAccessCount.min(by: { $0.value < $1.value })?.key else { return }
        themeCache.removeValue(forKey: leastUsedKey)
        cacheAccessCount.removeValue(forKey: leastUsedKey)
    }
    
    // MARK: - Color Caching
    
    /// Get cached color or create and cache new one
    public func getCachedColor(name: String, bundle: Bundle) -> Color {
        let cacheKey = "\(name)_\(bundle.bundleIdentifier ?? "unknown")"
        
        if let cachedColor = colorCache[cacheKey] {
            cacheAccessCount[cacheKey, default: 0] += 1
            return cachedColor
        }
        
        let color = Color(name, bundle: bundle)
        cacheColor(color, key: cacheKey)
        return color
    }
    
    private func cacheColor(_ color: Color, key: String) {
        if colorCache.count >= maxCacheSize {
            evictLeastUsedColor()
        }
        
        colorCache[key] = color
        cacheAccessCount[key] = 1
    }
    
    private func evictLeastUsedColor() {
        guard let leastUsedKey = cacheAccessCount.min(by: { $0.value < $1.value })?.key else { return }
        colorCache.removeValue(forKey: leastUsedKey)
        cacheAccessCount.removeValue(forKey: leastUsedKey)
    }
    
    // MARK: - Font Caching
    
    /// Get cached font or create and cache new one
    public func getCachedFont(style: String, weight: Font.Weight = .regular) -> Font {
        let cacheKey = "\(style)_\(weight)"
        
        if let cachedFont = fontCache[cacheKey] {
            cacheAccessCount[cacheKey, default: 0] += 1
            return cachedFont
        }
        
        let font = Font.system(size: 16, weight: weight)
        cacheFont(font, key: cacheKey)
        return font
    }
    
    private func cacheFont(_ font: Font, key: String) {
        if fontCache.count >= maxCacheSize {
            evictLeastUsedFont()
        }
        
        fontCache[key] = font
        cacheAccessCount[key] = 1
    }
    
    private func evictLeastUsedFont() {
        guard let leastUsedKey = cacheAccessCount.min(by: { $0.value < $1.value })?.key else { return }
        fontCache.removeValue(forKey: leastUsedKey)
        cacheAccessCount.removeValue(forKey: leastUsedKey)
    }
    
    // MARK: - Image Caching
    
    /// Get cached image or create and cache new one
    public func getCachedImage(name: String, bundle: Bundle) -> Image {
        let cacheKey = "\(name)_\(bundle.bundleIdentifier ?? "unknown")"
        
        if let cachedImage = imageCache[cacheKey] {
            cacheAccessCount[cacheKey, default: 0] += 1
            return cachedImage
        }
        
        let image = Image(name, bundle: bundle)
        cacheImage(image, key: cacheKey)
        return image
    }
    
    private func cacheImage(_ image: Image, key: String) {
        if imageCache.count >= maxCacheSize {
            evictLeastUsedImage()
        }
        
        imageCache[key] = image
        cacheAccessCount[key] = 1
    }
    
    private func evictLeastUsedImage() {
        guard let leastUsedKey = cacheAccessCount.min(by: { $0.value < $1.value })?.key else { return }
        imageCache.removeValue(forKey: leastUsedKey)
        cacheAccessCount.removeValue(forKey: leastUsedKey)
    }
    
    // MARK: - Memory Management
    
    private func setupMemoryWarningObserver() {
        #if canImport(UIKit)
        NotificationCenter.default
            .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clearCaches()
            }
            .store(in: &cancellables)
        #endif
    }
    
    /// Clear all caches to free memory
    public func clearCaches() {
        themeCache.removeAll()
        colorCache.removeAll()
        fontCache.removeAll()
        imageCache.removeAll()
        cacheAccessCount.removeAll()
    }
    
    /// Clear least used cache entries
    public func optimizeCaches() {
        let threshold = maxCacheSize / 2
        
        if themeCache.count > threshold {
            evictLeastUsedTheme()
        }
        
        if colorCache.count > threshold {
            evictLeastUsedColor()
        }
        
        if fontCache.count > threshold {
            evictLeastUsedFont()
        }
        
        if imageCache.count > threshold {
            evictLeastUsedImage()
        }
    }
    
    // MARK: - Performance Metrics
    
    public var cacheStats: CacheStats {
        CacheStats(
            themeCacheSize: themeCache.count,
            colorCacheSize: colorCache.count,
            fontCacheSize: fontCache.count,
            imageCacheSize: imageCache.count,
            totalCacheSize: themeCache.count + colorCache.count + fontCache.count + imageCache.count,
            maxCacheSize: maxCacheSize
        )
    }
}

// MARK: - Cache Stats

public struct CacheStats {
    public let themeCacheSize: Int
    public let colorCacheSize: Int
    public let fontCacheSize: Int
    public let imageCacheSize: Int
    public let totalCacheSize: Int
    public let maxCacheSize: Int
    
    public var cacheUtilization: Double {
        Double(totalCacheSize) / Double(maxCacheSize)
    }
    
    public var isNearCapacity: Bool {
        cacheUtilization > 0.8
    }
}

// MARK: - Lazy Loading Utilities

/// Lazy loading wrapper for expensive view computations
public struct LazyView<Content: View>: View {
    private let content: () -> Content
    @State private var isLoaded = false
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Group {
            if isLoaded {
                content()
            } else {
                Color.clear
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isLoaded = true
                        }
                    }
            }
        }
    }
}

/// Lazy loading wrapper with custom loading view
public struct LazyViewWithLoading<Content: View, LoadingView: View>: View {
    private let content: () -> Content
    private let loadingView: () -> LoadingView
    @State private var isLoaded = false
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder loadingView: @escaping () -> LoadingView
    ) {
        self.content = content
        self.loadingView = loadingView
    }
    
    public var body: some View {
        Group {
            if isLoaded {
                content()
            } else {
                loadingView()
                    .onAppear {
                        DelayedExecution.after(0.1) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isLoaded = true
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Memory Optimization


// MARK: - Bundle Optimization

/// Optimized bundle access with caching
@MainActor
public struct OptimizedBundle {
    private static let bundleCache = NSMutableDictionary()
    
    public static func getBundle(for identifier: String) -> Bundle? {
        if let cachedBundle = bundleCache[identifier] as? Bundle {
            return cachedBundle
        }
        
        let bundle = Bundle(identifier: identifier)
        if let bundle = bundle {
            bundleCache[identifier] = bundle
        }
        
        return bundle
    }
    
    public static func clearBundleCache() {
        bundleCache.removeAllObjects()
    }
}

// MARK: - Performance Monitoring

/// Performance monitoring utilities
@MainActor
public class PerformanceMonitor: ObservableObject {
    public static let shared = PerformanceMonitor()
    
    @Published public var isMonitoring = false
    @Published public var metrics: PerformanceMetrics = PerformanceMetrics()
    
    private var startTime: Date?
    private var frameCount = 0
    private var lastFrameTime: Date?
    
    private init() {}
    
    public func startMonitoring() {
        isMonitoring = true
        startTime = Date()
        frameCount = 0
        lastFrameTime = Date()
    }
    
    public func stopMonitoring() {
        isMonitoring = false
        startTime = nil
        frameCount = 0
        lastFrameTime = nil
    }
    
    public func recordFrame() {
        guard isMonitoring else { return }
        
        frameCount += 1
        
        if let lastTime = lastFrameTime {
            let frameTime = Date().timeIntervalSince(lastTime)
            metrics.averageFrameTime = (metrics.averageFrameTime + frameTime) / 2
        }
        
        lastFrameTime = Date()
    }
    
    public func reset() {
        metrics = PerformanceMetrics()
        startTime = nil
        frameCount = 0
        lastFrameTime = nil
    }
}

// MARK: - Performance Metrics

public struct PerformanceMetrics {
    public var averageFrameTime: TimeInterval = 0
    public var totalFrames: Int = 0
    public var memoryUsage: UInt64 = 0
    public var cacheHits: Int = 0
    public var cacheMisses: Int = 0
    
    public var fps: Double {
        guard averageFrameTime > 0 else { return 0 }
        return 1.0 / averageFrameTime
    }
    
    public var cacheHitRate: Double {
        let total = cacheHits + cacheMisses
        guard total > 0 else { return 0 }
        return Double(cacheHits) / Double(total)
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply lazy loading to the view
    func lazy() -> some View {
        LazyView {
            self
        }
    }
    
    /// Apply lazy loading with custom loading view
    func lazy<LoadingView: View>(@ViewBuilder loadingView: @escaping () -> LoadingView) -> some View {
        LazyViewWithLoading(
            content: { self },
            loadingView: loadingView
        )
    }
    
    
    /// Apply performance monitoring to the view
    func performanceMonitored() -> some View {
        self.onAppear {
            PerformanceMonitor.shared.recordFrame()
        }
    }
}
