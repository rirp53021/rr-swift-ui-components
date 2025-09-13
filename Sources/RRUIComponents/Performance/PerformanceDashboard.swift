// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Performance Dashboard

/// Comprehensive performance monitoring dashboard
public struct PerformanceDashboard: View {
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    @StateObject private var bundleOptimizer = BundleOptimizer.shared
    @StateObject private var performanceMonitor = PerformanceMonitor.shared
    
    @State private var isExpanded = false
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                RRLabel("Performance Dashboard", style: .title)
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(.regularMaterial)
            
            if isExpanded {
                // Content
                VStack(spacing: 16) {
                    // Tab Selector
                    Picker("Tab", selection: $selectedTab) {
                        Text("Overview").tag(0)
                        Text("Memory").tag(1)
                        Text("Cache").tag(2)
                        Text("Bundle").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Tab Content
                    Group {
                        switch selectedTab {
                        case 0:
                            OverviewTab()
                        case 1:
                            MemoryTab()
                        case 2:
                            CacheTab()
                        case 3:
                            BundleTab()
                        default:
                            OverviewTab()
                        }
                    }
                    .animation(.easeInOut, value: selectedTab)
                }
                .padding()
            }
        }
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// MARK: - Overview Tab

private struct OverviewTab: View {
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    @StateObject private var bundleOptimizer = BundleOptimizer.shared
    @StateObject private var performanceMonitor = PerformanceMonitor.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Performance Status
            HStack {
                RRLabel("Performance Status", style: .title)
                
                Spacer()
                
                StatusIndicator(
                    isEnabled: performanceOptimizer.isEnabled,
                    label: performanceOptimizer.isEnabled ? "Optimized" : "Disabled"
                )
            }
            
            // Key Metrics
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                MetricCard(
                    title: "FPS",
                    value: String(format: "%.1f", performanceMonitor.metrics.fps),
                    color: performanceMonitor.metrics.fps > 55 ? .green : .orange
                )
                
                MetricCard(
                    title: "Memory Usage",
                    value: memoryOptimizer.memoryStats.formattedCurrentUsage,
                    color: memoryOptimizer.memoryStats.pressureLevel.color
                )
                
                MetricCard(
                    title: "Cache Hit Rate",
                    value: String(format: "%.1f%%", performanceMonitor.metrics.cacheHitRate * 100),
                    color: performanceMonitor.metrics.cacheHitRate > 0.8 ? .green : .orange
                )
                
                MetricCard(
                    title: "Bundle Cache",
                    value: "\(bundleOptimizer.cacheStats.totalCacheSize)",
                    color: .blue
                )
            }
            
            // Quick Actions
            HStack(spacing: 12) {
                RRButton("Clear Caches", style: .secondary, size: .sm) {
                    performanceOptimizer.clearCaches()
                    bundleOptimizer.clearAllCaches()
                }
                
                RRButton("Optimize Memory", style: .secondary, size: .sm) {
                    memoryOptimizer.performMemoryCleanup()
                }
                
                RRButton("Reset Stats", style: .secondary, size: .sm) {
                    performanceMonitor.reset()
                }
            }
        }
    }
}

// MARK: - Memory Tab

private struct MemoryTab: View {
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Memory Usage Chart
            VStack(alignment: .leading, spacing: 8) {
                RRLabel("Memory Usage", style: .title)
                
                MemoryUsageChart()
            }
            
            // Memory Details
            VStack(spacing: 8) {
                MemoryDetailRow(
                    title: "Current Usage",
                    value: memoryOptimizer.memoryStats.formattedCurrentUsage,
                    color: .primary
                )
                
                MemoryDetailRow(
                    title: "Peak Usage",
                    value: memoryOptimizer.memoryStats.formattedPeakUsage,
                    color: .orange
                )
                
                MemoryDetailRow(
                    title: "Max Usage",
                    value: memoryOptimizer.memoryStats.formattedMaxUsage,
                    color: .secondary
                )
                
                MemoryDetailRow(
                    title: "Usage Percentage",
                    value: String(format: "%.1f%%", memoryOptimizer.memoryStats.usagePercentage * 100),
                    color: memoryOptimizer.memoryStats.pressureLevel.color
                )
                
                MemoryDetailRow(
                    title: "Pressure Level",
                    value: memoryOptimizer.memoryStats.pressureLevel.rawValue.capitalized,
                    color: memoryOptimizer.memoryStats.pressureLevel.color
                )
            }
        }
    }
}

// MARK: - Cache Tab

private struct CacheTab: View {
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Cache Statistics
            VStack(alignment: .leading, spacing: 8) {
                RRLabel("Cache Statistics", style: .title)
                
                let stats = performanceOptimizer.cacheStats
                
                VStack(spacing: 8) {
                    CacheDetailRow(
                        title: "Theme Cache",
                        value: "\(stats.themeCacheSize)",
                        color: .blue
                    )
                    
                    CacheDetailRow(
                        title: "Color Cache",
                        value: "\(stats.colorCacheSize)",
                        color: .green
                    )
                    
                    CacheDetailRow(
                        title: "Font Cache",
                        value: "\(stats.fontCacheSize)",
                        color: .purple
                    )
                    
                    CacheDetailRow(
                        title: "Image Cache",
                        value: "\(stats.imageCacheSize)",
                        color: .orange
                    )
                    
                    CacheDetailRow(
                        title: "Total Cache",
                        value: "\(stats.totalCacheSize)",
                        color: .primary
                    )
                    
                    CacheDetailRow(
                        title: "Cache Utilization",
                        value: String(format: "%.1f%%", stats.cacheUtilization * 100),
                        color: stats.isNearCapacity ? .red : .green
                    )
                }
            }
            
            // Cache Actions
            VStack(spacing: 8) {
                RRButton("Clear All Caches", style: .primary) {
                    performanceOptimizer.clearCaches()
                }
                
                RRButton("Optimize Caches", style: .secondary) {
                    performanceOptimizer.optimizeCaches()
                }
            }
        }
    }
}

// MARK: - Bundle Tab

private struct BundleTab: View {
    @StateObject private var bundleOptimizer = BundleOptimizer.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Bundle Statistics
            VStack(alignment: .leading, spacing: 8) {
                RRLabel("Bundle Statistics", style: .title)
                
                let stats = bundleOptimizer.cacheStats
                
                VStack(spacing: 8) {
                    BundleDetailRow(
                        title: "Bundle Cache",
                        value: "\(stats.bundleCacheSize)",
                        color: .blue
                    )
                    
                    BundleDetailRow(
                        title: "Resource Cache",
                        value: "\(stats.resourceCacheSize)",
                        color: .green
                    )
                    
                    BundleDetailRow(
                        title: "Preloaded Resources",
                        value: "\(stats.preloadedResourcesCount)",
                        color: .purple
                    )
                    
                    BundleDetailRow(
                        title: "Total Cache",
                        value: "\(stats.totalCacheSize)",
                        color: .primary
                    )
                }
            }
            
            // Bundle Actions
            VStack(spacing: 8) {
                RRButton("Preload All Resources", style: .primary) {
                    bundleOptimizer.preloadAllResources()
                }
                
                RRButton("Clear Bundle Cache", style: .secondary) {
                    bundleOptimizer.clearAllCaches()
                }
            }
        }
    }
}

// MARK: - Supporting Views

private struct StatusIndicator: View {
    let isEnabled: Bool
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isEnabled ? .green : .red)
                .frame(width: 8, height: 8)
            
            RRLabel(label, style: .caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            RRLabel(title, style: .caption)
                .foregroundColor(.secondary)
            
            RRLabel(value, style: .title)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
    }
}

private struct MemoryUsageChart: View {
    @StateObject private var memoryOptimizer = MemoryOptimizer.shared
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(
                value: memoryOptimizer.memoryStats.usagePercentage,
                total: 1.0
            )
            .progressViewStyle(LinearProgressViewStyle())
            .tint(memoryOptimizer.memoryStats.pressureLevel.color)
            
            HStack {
                RRLabel("0 MB", style: .caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                RRLabel(memoryOptimizer.memoryStats.formattedMaxUsage, style: .caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct MemoryDetailRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            RRLabel(title, style: .body)
            
            Spacer()
            
            RRLabel(value, style: .body)
                .foregroundColor(color)
        }
        .padding(.vertical, 2)
    }
}

private struct CacheDetailRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            RRLabel(title, style: .body)
            
            Spacer()
            
            RRLabel(value, style: .body)
                .foregroundColor(color)
        }
        .padding(.vertical, 2)
    }
}

private struct BundleDetailRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            RRLabel(title, style: .body)
            
            Spacer()
            
            RRLabel(value, style: .body)
                .foregroundColor(color)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Performance Dashboard Modifier

public extension View {
    /// Add performance dashboard to the view
    func performanceDashboard() -> some View {
        self.overlay(
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    PerformanceDashboard()
                        .frame(maxWidth: 300)
                }
            }
            .padding()
        )
    }
    
    /// Add performance dashboard with custom position
    func performanceDashboard(position: PerformanceDashboardPosition = .bottomTrailing) -> some View {
        self.overlay(
            VStack {
                if position == .topLeading || position == .topTrailing {
                    HStack {
                        if position == .topLeading {
                            PerformanceDashboard()
                                .frame(maxWidth: 300)
                        } else {
                            Spacer()
                        }
                        
                        if position == .topTrailing {
                            PerformanceDashboard()
                                .frame(maxWidth: 300)
                        } else {
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                if position == .bottomLeading || position == .bottomTrailing {
                    HStack {
                        if position == .bottomLeading {
                            PerformanceDashboard()
                                .frame(maxWidth: 300)
                        } else {
                            Spacer()
                        }
                        
                        if position == .bottomTrailing {
                            PerformanceDashboard()
                                .frame(maxWidth: 300)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        )
    }
}

// MARK: - Performance Dashboard Position

public enum PerformanceDashboardPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}
