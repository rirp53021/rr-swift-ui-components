import Testing
import SwiftUI
@testable import RRUIComponents

@MainActor
struct PerformanceOptimizerTests {
    
    // MARK: - Initialization Tests
    
    @Test("PerformanceOptimizer initialization")
    func testPerformanceOptimizerInitialization() {
        let _ = PerformanceOptimizer.shared
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
        let _ = PerformanceOptimizer.shared
        // Test that clearCaches method exists and can be called
        PerformanceOptimizer.shared.clearCaches()
    }
    
    @Test("Optimize caches")
    func testOptimizeCaches() {
        let _ = PerformanceOptimizer.shared
        // Test that optimizeCaches method exists and can be called
        PerformanceOptimizer.shared.optimizeCaches()
    }
}