import Testing
import SwiftUI
@testable import RRUIComponents

@MainActor
struct PerformanceOptimizerTests {
    
    // MARK: - Initialization Tests
    
    @Test("PerformanceOptimizer initialization")
    func testPerformanceOptimizerInitialization() {
        let performanceOptimizer = PerformanceOptimizer.shared
        #expect(performanceOptimizer != nil)
    }
    
    @Test("PerformanceOptimizer singleton")
    func testPerformanceOptimizerSingleton() {
        let instance1 = PerformanceOptimizer.shared
        let instance2 = PerformanceOptimizer.shared
        
        #expect(instance1 === instance2)
    }
    
    // MARK: - Cache Management Tests
    
    @Test("Clear all caches")
    func testClearAllCaches() {
        let performanceOptimizer = PerformanceOptimizer.shared
        // Test that clearCaches method exists and can be called
        performanceOptimizer.clearCaches()
        #expect(performanceOptimizer != nil)
    }
    
    @Test("Optimize caches")
    func testOptimizeCaches() {
        let performanceOptimizer = PerformanceOptimizer.shared
        // Test that optimizeCaches method exists and can be called
        performanceOptimizer.optimizeCaches()
        #expect(performanceOptimizer != nil)
    }
}