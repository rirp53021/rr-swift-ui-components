// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Bundle Optimizer

/// Bundle optimization utilities for RRUIComponents
@MainActor
public class BundleOptimizer: ObservableObject {
    public static let shared = BundleOptimizer()
    
    // MARK: - Configuration
    
    @Published public var isEnabled: Bool = true
    @Published public var cacheEnabled: Bool = true
    @Published public var preloadEnabled: Bool = true
    
    // MARK: - Bundle Cache
    
    private var bundleCache: [String: Bundle] = [:]
    private var resourceCache: [String: Any] = [:]
    private var preloadedResources: Set<String> = []
    
    // MARK: - Bundle Management
    
    /// Get bundle with caching
    public func getBundle(for identifier: String) -> Bundle? {
        guard isEnabled else {
            return Bundle(identifier: identifier)
        }
        
        if let cachedBundle = bundleCache[identifier] {
            return cachedBundle
        }
        
        guard let bundle = Bundle(identifier: identifier) else {
            return nil
        }
        
        if cacheEnabled {
            bundleCache[identifier] = bundle
        }
        
        return bundle
    }
    
    /// Get bundle for current module
    public func getCurrentBundle() -> Bundle {
        return Bundle(for: BundleToken.self)
    }
    
    /// Clear bundle cache
    public func clearBundleCache() {
        bundleCache.removeAll()
    }
    
    // MARK: - Resource Management
    
    /// Get resource with caching
    public func getResource<T>(name: String, type: String? = nil, bundle: Bundle? = nil) -> T? {
        let cacheKey = "\(name)_\(type ?? "unknown")_\(bundle?.bundleIdentifier ?? "unknown")"
        
        if let cachedResource = resourceCache[cacheKey] as? T {
            return cachedResource
        }
        
        let targetBundle = bundle ?? getCurrentBundle()
        
        guard let resource = targetBundle.url(forResource: name, withExtension: type) else {
            return nil
        }
        
        // Cache the resource URL
        if cacheEnabled {
            resourceCache[cacheKey] = resource
        }
        
        return resource as? T
    }
    
    /// Get image resource with caching
    public func getImage(name: String, bundle: Bundle? = nil) -> Image? {
        let cacheKey = "image_\(name)_\(bundle?.bundleIdentifier ?? "unknown")"
        
        if let cachedImage = resourceCache[cacheKey] as? Image {
            return cachedImage
        }
        
        let targetBundle = bundle ?? getCurrentBundle()
        let image = Image(name, bundle: targetBundle)
        
        if cacheEnabled {
            resourceCache[cacheKey] = image
        }
        
        return image
    }
    
    /// Get color resource with caching
    public func getColor(name: String, bundle: Bundle? = nil) -> Color? {
        let cacheKey = "color_\(name)_\(bundle?.bundleIdentifier ?? "unknown")"
        
        if let cachedColor = resourceCache[cacheKey] as? Color {
            return cachedColor
        }
        
        let targetBundle = bundle ?? getCurrentBundle()
        let color = Color(name, bundle: targetBundle)
        
        if cacheEnabled {
            resourceCache[cacheKey] = color
        }
        
        return color
    }
    
    /// Get font resource with caching
    public func getFont(name: String, size: CGFloat, bundle: Bundle? = nil) -> Font? {
        let cacheKey = "font_\(name)_\(size)_\(bundle?.bundleIdentifier ?? "unknown")"
        
        if let cachedFont = resourceCache[cacheKey] as? Font {
            return cachedFont
        }
        
        let targetBundle = bundle ?? getCurrentBundle()
        
        guard let fontURL = targetBundle.url(forResource: name, withExtension: "ttf") ??
                            targetBundle.url(forResource: name, withExtension: "otf") else {
            return nil
        }
        
        guard let fontData = try? Data(contentsOf: fontURL),
              let provider = CGDataProvider(data: fontData as CFData),
              let font = CGFont(provider) else {
            return nil
        }
        
        let fontName = font.postScriptName as String?
        #if canImport(UIKit)
        let uiFont = UIFont(name: fontName ?? name, size: size)
        let swiftUIFont = Font(uiFont ?? .systemFont(ofSize: size))
        #else
        let swiftUIFont = Font.system(size: size)
        #endif
        
        if cacheEnabled {
            resourceCache[cacheKey] = swiftUIFont
        }
        
        return swiftUIFont
    }
    
    // MARK: - Resource Preloading
    
    /// Preload resources for better performance
    public func preloadResources(_ resourceNames: [String], bundle: Bundle? = nil) {
        guard preloadEnabled else { return }
        
        let targetBundle = bundle ?? getCurrentBundle()
        
        for resourceName in resourceNames {
            let cacheKey = "preload_\(resourceName)_\(targetBundle.bundleIdentifier ?? "unknown")"
            
            if preloadedResources.contains(cacheKey) {
                continue
            }
            
            // Preload image
            if let _ = targetBundle.url(forResource: resourceName, withExtension: "png") ??
                      targetBundle.url(forResource: resourceName, withExtension: "jpg") ??
                      targetBundle.url(forResource: resourceName, withExtension: "jpeg") {
                _ = getImage(name: resourceName, bundle: targetBundle)
            }
            
            // Preload color
            if let _ = targetBundle.url(forResource: resourceName, withExtension: "colorset") {
                _ = getColor(name: resourceName, bundle: targetBundle)
            }
            
            preloadedResources.insert(cacheKey)
        }
    }
    
    /// Preload all resources from a bundle
    public func preloadAllResources(from bundle: Bundle? = nil) {
        guard preloadEnabled else { return }
        
        let targetBundle = bundle ?? getCurrentBundle()
        
        guard let resourceURLs = targetBundle.urls(forResourcesWithExtension: nil, subdirectory: nil) else {
            return
        }
        
        let resourceNames = resourceURLs.compactMap { url in
            url.deletingPathExtension().lastPathComponent
        }
        
        preloadResources(resourceNames, bundle: targetBundle)
    }
    
    // MARK: - Cache Management
    
    /// Clear resource cache
    public func clearResourceCache() {
        resourceCache.removeAll()
        preloadedResources.removeAll()
    }
    
    /// Clear all caches
    public func clearAllCaches() {
        clearBundleCache()
        clearResourceCache()
    }
    
    // MARK: - Statistics
    
    public var cacheStats: BundleCacheStats {
        BundleCacheStats(
            bundleCacheSize: bundleCache.count,
            resourceCacheSize: resourceCache.count,
            preloadedResourcesCount: preloadedResources.count,
            totalCacheSize: bundleCache.count + resourceCache.count
        )
    }
}

// MARK: - Bundle Cache Stats

public struct BundleCacheStats {
    public let bundleCacheSize: Int
    public let resourceCacheSize: Int
    public let preloadedResourcesCount: Int
    public let totalCacheSize: Int
    
    public var cacheUtilization: Double {
        Double(totalCacheSize) / 100.0 // Assuming max 100 items
    }
}


// MARK: - Bundle Token

private final class BundleToken {}

// MARK: - Optimized Image Component

/// Image component with bundle optimization
public struct OptimizedImage: View {
    private let name: String
    private let bundle: Bundle?
    private let contentMode: ContentMode
    
    @State private var image: Image?
    @State private var isLoading = true
    
    public init(
        name: String,
        bundle: Bundle? = nil,
        contentMode: ContentMode = .fit
    ) {
        self.name = name
        self.bundle = bundle
        self.contentMode = contentMode
    }
    
    public var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let loadedImage = BundleOptimizer.shared.getImage(name: name, bundle: bundle)
        self.image = loadedImage
        self.isLoading = false
    }
}

// MARK: - Optimized Color Component

/// Color component with bundle optimization
public struct OptimizedColor: View {
    private let name: String
    private let bundle: Bundle?
    
    @State private var color: Color?
    @State private var isLoading = true
    
    public init(
        name: String,
        bundle: Bundle? = nil
    ) {
        self.name = name
        self.bundle = bundle
    }
    
    public var body: some View {
        Group {
            if let color = color {
                color
            } else if isLoading {
                Color.clear
            } else {
                Color.secondary
            }
        }
        .onAppear {
            loadColor()
        }
    }
    
    private func loadColor() {
        let loadedColor = BundleOptimizer.shared.getColor(name: name, bundle: bundle)
        self.color = loadedColor
        self.isLoading = false
    }
}

// MARK: - Bundle Monitor View

/// View that displays bundle optimization statistics
public struct BundleMonitorView: View {
    @StateObject private var bundleOptimizer = BundleOptimizer.shared
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RRLabel("Bundle Optimization", style: .title)
                
                Spacer()
                
                Circle()
                    .fill(bundleOptimizer.isEnabled ? .green : .red)
                    .frame(width: 12, height: 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    RRLabel("Bundle Cache:", style: .caption)
                    Spacer()
                    RRLabel("\(bundleOptimizer.cacheStats.bundleCacheSize)", style: .caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    RRLabel("Resource Cache:", style: .caption)
                    Spacer()
                    RRLabel("\(bundleOptimizer.cacheStats.resourceCacheSize)", style: .caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    RRLabel("Preloaded Resources:", style: .caption)
                    Spacer()
                    RRLabel("\(bundleOptimizer.cacheStats.preloadedResourcesCount)", style: .caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    RRLabel("Total Cache Size:", style: .caption)
                    Spacer()
                    RRLabel("\(bundleOptimizer.cacheStats.totalCacheSize)", style: .caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}

// MARK: - View Extensions

